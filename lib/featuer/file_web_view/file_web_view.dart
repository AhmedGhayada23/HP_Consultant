import 'package:flutter/material.dart';
import 'package:hb/core/styles/app_color.dart';
import 'package:hb/core/styles/app_font.dart';
import 'package:webview_flutter/webview_flutter.dart';

class FileWebViewPage extends StatefulWidget {
  final String fileName;
  final String fileUrl;

  const FileWebViewPage({
    super.key,
    required this.fileName,
    required this.fileUrl,
  });

  @override
  State<FileWebViewPage> createState() => _FileWebViewPageState();
}

class _FileWebViewPageState extends State<FileWebViewPage> {
  WebViewController? controller;
  bool isLoading = true;
  String? loadError;

  // WebView على أندرويد لا يعرض PDF/مستندات Office مباشرة،
  // لذلك نغلّفها بعارض Google Docs ليتم عرضها داخل الصفحة.
  String _resolveViewUrl(String rawUrl) {
    final url = rawUrl.trim();
    if (url.isEmpty) return url;

    final lower = url.toLowerCase().split('?').first;
    const docExtensions = [
      '.pdf',
      '.doc',
      '.docx',
      '.xls',
      '.xlsx',
      '.ppt',
      '.pptx',
    ];
    final isDocument = docExtensions.any((ext) => lower.endsWith(ext));

    if (isDocument) {
      final encoded = Uri.encodeComponent(url);
      return 'https://docs.google.com/gview?embedded=true&url=$encoded';
    }
    return url;
  }

  @override
  void initState() {
    super.initState();

    final resolvedUrl = _resolveViewUrl(widget.fileUrl);
    final uri = Uri.tryParse(resolvedUrl);
    // تأكد أن الرابط صالح ويحتوي على http/https قبل تحميله،
    // وإلا سيرمي loadRequest استثناء "Missing scheme in uri".
    if (uri == null || !uri.hasScheme || !uri.isAbsolute) {
      loadError = 'Invalid or missing file link.';
      isLoading = false;
      return;
    }

    controller = WebViewController()
      ..setJavaScriptMode(JavaScriptMode.unrestricted)
      ..setNavigationDelegate(
        NavigationDelegate(
          onProgress: (int progress) {
            // يمكن استخدامه لشريط تحميل
          },
          onPageStarted: (url) => setState(() => isLoading = true),
          onPageFinished: (url) => setState(() => isLoading = false),
          onWebResourceError: (error) {
            if (!mounted) return;
            setState(() => isLoading = false); // إيقاف المؤشر عند الخطأ
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(content: Text('Error loading file: ${error.description}')),
            );
          },
          onNavigationRequest: (request) {
            // منع أي روابط خارجية إذا احتجت
            return NavigationDecision.navigate;
          },
        ),
      )
      ..loadRequest(uri);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        iconTheme: IconThemeData(color: AppColor.whiteColor),
        title: Text(widget.fileName,

        style: MyTextStyle().textStyleSemiBold16().copyWith(color: AppColor.whiteColor),
        ),
        backgroundColor: AppColor.blackColor,
        actions: [
          if (isLoading)
            Padding(
              padding: const EdgeInsets.all(12.0),
              child: CircularProgressIndicator(color: Colors.white),
            ),
        ],
      ),
      body: loadError != null || controller == null
          ? Center(
              child: Padding(
                padding: const EdgeInsets.all(24.0),
                child: Text(
                  loadError ?? 'Invalid or missing file link.',
                  textAlign: TextAlign.center,
                  style: MyTextStyle().textStyleSemiBold16(),
                ),
              ),
            )
          : WebViewWidget(controller: controller!),
    );
  }
}
