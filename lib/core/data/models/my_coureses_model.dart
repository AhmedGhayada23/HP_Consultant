import 'package:hb/core/config/constants.dart';

class MyCouresesModel {
  final String? id;
  final int? enrollmentId;
  final String? title;
  final String? level; // التسمية المعروضة (level_label)
  final String? levelRaw; // القيمة الأصلية للفلترة (level: beginner/intermediate/advanced)
  final double? progress; // 0..1
  final String? imageUrl;
  final String? status;
  final double? rating;
  final String? trainerName;
  final String? certificateUrl; // رابط تنزيل الشهادة (null إذا لا توجد)

  MyCouresesModel({
    this.id,
    this.enrollmentId,
    this.title,
    this.level,
    this.levelRaw,
    this.progress,
    this.imageUrl,
    this.status,
    this.rating,
    this.trainerName,
    this.certificateUrl,
  });

  bool get hasCertificate =>
      certificateUrl != null && certificateUrl!.isNotEmpty;

  factory MyCouresesModel.fromJson(Map<String, dynamic> json) {
    final course = json['course'] is Map
        ? Map<String, dynamic>.from(json['course'])
        : <String, dynamic>{};
    final trainer = course['trainer'] is Map
        ? Map<String, dynamic>.from(course['trainer'])
        : null;
    final pct = json['progress_percentage'];

    // الشهادة: قد تكون null أو كائن يحوي رابط التنزيل
    final certificate = json['certificate'] is Map
        ? Map<String, dynamic>.from(json['certificate'])
        : null;
    String? certUrl = certificate?['download_url_v1'] as String? ??
        certificate?['download_url'] as String?;
    if (certUrl != null && certUrl.startsWith('/')) {
      certUrl = '${Constants.imageUrl}$certUrl';
    }

    return MyCouresesModel(
      id: course['id']?.toString(),
      enrollmentId: json['enrollment_id'] as int?,
      title: course['title'] ?? '',
      level: course['level_label'] ?? course['level'] ?? '',
      levelRaw: course['level'] as String?,
      progress: (pct is num ? pct.toDouble() : 0) / 100.0,
      imageUrl: course['thumbnail_url'] as String?,
      status: json['status'] as String?,
      rating: (course['rating'] as num?)?.toDouble(),
      trainerName: trainer?['name'] as String?,
      certificateUrl: certUrl,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'enrollment_id': enrollmentId,
      'title': title,
      'level': level,
      'progress': progress,
      'imageUrl': imageUrl,
      'status': status,
    };
  }
}
