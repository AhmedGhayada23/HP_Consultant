import 'dart:io';
import 'package:dio/dio.dart';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:open_filex/open_filex.dart';
import 'package:path_provider/path_provider.dart';
import 'package:photo_manager/photo_manager.dart';
import 'package:flutter/foundation.dart';
import 'package:hb/core/config/constants.dart';
import 'package:hb/core/config/storage/local_storage.dart';

enum FileType { video, image, file }

/// نتيجة عملية "تنزيل ثم فتح"
enum DownloadOpenStatus {
  downloadFailed, // فشل التنزيل
  opened, // نُزّل وفُتح بنجاح
  downloadedNotOpened, // نُزّل لكن تعذّر فتحه (لا يوجد تطبيق مناسب مثلاً)
}

class UniversalDownloader extends ChangeNotifier {
  int progress = 0;
  String progressText = "0%";
  bool isDownloading = false;
  String? savedPath; // مسار آخر ملف تم حفظه (لفتحه بعد التحميل)
  String? savedFileName; // اسم آخر ملف تم حفظه

  // ─── تحويل الرابط النسبي إلى رابط مطلق ───────────────────────
  String _resolveUrl(String url) {
    var u = url.trim();
    if (u.isEmpty) return u;
    if (u.startsWith('http://') || u.startsWith('https://')) return u;
    // أصل الدومين (بدون /api/v1) لملفات التخزين
    final base = Constants.imageUrl;
    return u.startsWith('/') ? '$base$u' : '$base/$u';
  }

  // ─── تحديد نوع الملف من الرابط ───────────────────────────────
  FileType _detectFileType(String url) {
    final lower = url.toLowerCase().split('?').first; // تجاهل query params
    if (lower.endsWith('.mp4') ||
        lower.endsWith('.mov') ||
        lower.endsWith('.avi') ||
        lower.endsWith('.mkv') ||
        lower.endsWith('.webm')) {
      return FileType.video;
    } else if (lower.endsWith('.jpg') ||
        lower.endsWith('.jpeg') ||
        lower.endsWith('.png') ||
        lower.endsWith('.gif') ||
        lower.endsWith('.webp') ||
        lower.endsWith('.heic')) {
      return FileType.image;
    } else {
      return FileType.file;
    }
  }

  // ─── تحديد امتداد الملف ──────────────────────────────────────
  String _getExtension(String url, FileType type) {
    final lower = url.toLowerCase().split('?').first;
    final ext = lower.split('.').last;
    const known = [
      'mp4', 'mov', 'avi', 'mkv', 'webm',
      'jpg', 'jpeg', 'png', 'gif', 'webp', 'heic',
      'pdf', 'doc', 'docx', 'xls', 'xlsx', 'zip', 'rar', 'mp3',
    ];
    if (known.contains(ext)) return ext;
    // fallback
    switch (type) {
      case FileType.video:
        return 'mp4';
      case FileType.image:
        return 'jpg';
      case FileType.file:
        return 'bin';
    }
  }

  // ─── الحصول على مسار الحفظ ───────────────────────────────────
  Future<String> _getSavePath(String fileName, FileType type) async {
    if (Platform.isAndroid) {
      final Directory? appDir = await getExternalStorageDirectory();
      if (appDir == null) throw Exception("Unable to get storage directory.");

      String folderName;
      switch (type) {
        case FileType.video:
          folderName = 'Videos';
          break;
        case FileType.image:
          folderName = 'Images';
          break;
        case FileType.file:
          folderName = 'Files';
          break;
      }

      final Directory dir = Directory("${appDir.path}/$folderName");
      if (!dir.existsSync()) dir.createSync(recursive: true);
      return "${dir.path}/$fileName";
    } else {
      // iOS
      final dir = await getApplicationDocumentsDirectory();
      return "${dir.path}/$fileName";
    }
  }

  // ─── حفظ في مكتبة الصور (iOS & Android) ─────────────────────
  Future<bool> _saveToGallery(File file, FileType type) async {
    try {
      final permission = await PhotoManager.requestPermissionExtend();
      if (!permission.isAuth) return false;

      if (type == FileType.video) {
        final asset = await PhotoManager.editor.saveVideo(
          file,
          title: file.path.split('/').last,
        );
        return asset != null;
      } else if (type == FileType.image) {
        final asset = await PhotoManager.editor.saveImageWithPath(
          file.path,
          title: file.path.split('/').last,
        );
        return asset != null;
      }
      return false;
    } catch (e) {
      debugPrint("Gallery save error: $e");
      return false;
    }
  }

  // ─── استخراج اسم الملف من ترويسة content-disposition ────────
  String? _fileNameFromHeaders(Headers headers) {
    final cd = headers.value('content-disposition');
    if (cd == null || cd.isEmpty) return null;
    // filename*=UTF-8''<encoded>
    final star = RegExp(
      r'''filename\*\s*=\s*(?:UTF-8'')?"?([^";]+)"?''',
      caseSensitive: false,
    ).firstMatch(cd);
    if (star != null) {
      final raw = star.group(1)!.trim();
      try {
        return Uri.decodeComponent(raw);
      } catch (_) {
        return raw;
      }
    }
    // filename="<name>"
    final m = RegExp(
      r'''filename\s*=\s*"?([^";]+)"?''',
      caseSensitive: false,
    ).firstMatch(cd);
    return m?.group(1)?.trim();
  }

  // ─── الدالة الرئيسية للتحميل ─────────────────────────────────
  Future<bool> downloadFile({
    required String url,
    String? customFileName,
    bool saveToGallery = true, // للصور والفيديو
  }) async {
    // 1. تحقق من الإنترنت
    final connectivityResult = await Connectivity().checkConnectivity();
    if (connectivityResult == ConnectivityResult.none) {
      debugPrint("No internet connection!");
      return false;
    }

    // تحويل الرابط النسبي إلى مطلق (مثل storage/...)
    url = _resolveUrl(url);

    isDownloading = true;
    progress = 0;
    progressText = "0%";
    notifyListeners();

    try {
      // 2. تحميل الملف مع تتبع التقدم
      final token = LocalStorage().readValue<String>(Constants.token) ?? '';
      final response = await Dio().get(
        url,
        options: Options(
          responseType: ResponseType.bytes,
          headers: {
            if (token.isNotEmpty) 'Authorization': 'Bearer $token',
          },
        ),
        onReceiveProgress: (received, total) {
          if (total > 0) {
            progress = ((received / total) * 100).round();
            progressText = "$progress%";
            notifyListeners();
          }
        },
      );

      // 3. اسم الملف: مخصّص → من ترويسة الخادم → من الرابط
      final headerName = _fileNameFromHeaders(response.headers);
      final FileType type = _detectFileType(headerName ?? url);
      String fileName = customFileName ??
          headerName ??
          "${DateTime.now().millisecondsSinceEpoch}";
      if (!fileName.contains('.')) {
        fileName = "$fileName.${_getExtension(url, type)}";
      }

      // 4. حفظ الملف محلياً
      final String savePath = await _getSavePath(fileName, type);
      final Uint8List bytes = Uint8List.fromList(response.data);
      final File file = File(savePath);
      await file.writeAsBytes(bytes);
      savedPath = savePath;
      savedFileName = fileName;

      // 5. حفظ في Gallery للصور والفيديو
      if (saveToGallery &&
          (type == FileType.video || type == FileType.image)) {
        await _saveToGallery(file, type);
      }

      debugPrint("✅ Downloaded: $savePath");
      return true;
    } catch (e) {
      debugPrint("❌ Download error: $e");
      return false;
    } finally {
      isDownloading = false;
      progress = 0;
      progressText = "0%";
      notifyListeners();
    }
  }

  // ─── تنزيل ثم فتح الملف بعارض الجهاز (قابل لإعادة الاستخدام) ──
  // يميّز بين فشل التنزيل، والتنزيل مع تعذّر الفتح، والنجاح الكامل
  Future<DownloadOpenStatus> downloadAndOpen({
    required String url,
    String? customFileName,
    bool saveToGallery = false,
  }) async {
    final ok = await downloadFile(
      url: url,
      customFileName: customFileName,
      saveToGallery: saveToGallery,
    );
    if (!ok || savedPath == null) return DownloadOpenStatus.downloadFailed;
    final result = await OpenFilex.open(savedPath!);
    return result.type == ResultType.done
        ? DownloadOpenStatus.opened
        : DownloadOpenStatus.downloadedNotOpened;
  }
}


// ════════════════════════════════════════════════════════════
// مثال على الاستخدام في الـ Widget
// ════════════════════════════════════════════════════════════
//
// final downloader = UniversalDownloader();
//
// // تحميل فيديو
// await downloader.downloadFile(url: "https://example.com/video.mp4");
//
// // تحميل صورة
// await downloader.downloadFile(url: "https://example.com/photo.jpg");
//
// // تحميل PDF
// await downloader.downloadFile(
//   url: "https://example.com/doc.pdf",
//   customFileName: "my_document.pdf",
//   saveToGallery: false,
// );
//
// // عرض نسبة التقدم
// Consumer<UniversalDownloader>(
//   builder: (context, dl, _) {
//     return Text(dl.progressText);
//   },
// )
