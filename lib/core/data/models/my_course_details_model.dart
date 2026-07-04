import 'package:hb/core/config/constants.dart';

class MyCourseDetailsModel {
  final MyCourseInfo? course;
  final MyEnrollmentInfo? enrollment;
  final List<MyCourseModule> modules;
  final String? certificateUrl; // رابط تنزيل الشهادة (null إذا لا توجد)

  MyCourseDetailsModel({
    this.course,
    this.enrollment,
    this.modules = const [],
    this.certificateUrl,
  });

  bool get hasCertificate =>
      certificateUrl != null && certificateUrl!.isNotEmpty;

  factory MyCourseDetailsModel.fromJson(Map<String, dynamic> json) {
    final data = json['data'] is Map
        ? Map<String, dynamic>.from(json['data'])
        : json;

    // الشهادة قد ترد على مستوى data أو داخل enrollment
    final enrollmentMap = data['enrollment'] is Map
        ? Map<String, dynamic>.from(data['enrollment'])
        : const {};
    final certRaw = data['certificate'] ?? enrollmentMap['certificate'];
    final certificate =
        certRaw is Map ? Map<String, dynamic>.from(certRaw) : null;
    String? certUrl = certificate?['download_url_v1'] as String? ??
        certificate?['download_url'] as String?;
    if (certUrl != null && certUrl.startsWith('/')) {
      certUrl = '${Constants.imageUrl}$certUrl';
    }

    return MyCourseDetailsModel(
      course: data['course'] is Map
          ? MyCourseInfo.fromJson(Map<String, dynamic>.from(data['course']))
          : null,
      enrollment: data['enrollment'] is Map
          ? MyEnrollmentInfo.fromJson(Map<String, dynamic>.from(data['enrollment']))
          : null,
      modules: (data['modules'] as List? ?? [])
          .map((e) => MyCourseModule.fromJson(Map<String, dynamic>.from(e)))
          .toList(),
      certificateUrl: certUrl,
    );
  }
}

class MyCourseInfo {
  final int id;
  final String? title;
  final String? description;
  final String? level;
  final String? levelLabel;
  final String? thumbnailUrl;

  MyCourseInfo({
    this.id = 0,
    this.title,
    this.description,
    this.level,
    this.levelLabel,
    this.thumbnailUrl,
  });

  factory MyCourseInfo.fromJson(Map<String, dynamic> json) {
    return MyCourseInfo(
      id: json['id'] ?? 0,
      title: json['title'] ?? '',
      description: json['description'] ?? '',
      level: json['level'] as String?,
      levelLabel: json['level_label'] as String?,
      thumbnailUrl: json['thumbnail_url'] as String?,
    );
  }
}

class MyEnrollmentInfo {
  final int id;
  final int progressPercentage; // 0..100
  final String? enrolledAt;

  MyEnrollmentInfo({this.id = 0, this.progressPercentage = 0, this.enrolledAt});

  factory MyEnrollmentInfo.fromJson(Map<String, dynamic> json) {
    final pct = json['progress_percentage'];
    return MyEnrollmentInfo(
      id: json['id'] ?? 0,
      progressPercentage: pct is num ? pct.toInt() : 0,
      enrolledAt: json['enrolled_at'] as String?,
    );
  }

  double get progress => progressPercentage / 100.0;
}

class MyCourseModule {
  final int id;
  final String? title;
  final int order;
  final List<MyCourseLesson> lessons;

  MyCourseModule({this.id = 0, this.title, this.order = 0, this.lessons = const []});

  factory MyCourseModule.fromJson(Map<String, dynamic> json) {
    return MyCourseModule(
      id: json['id'] ?? 0,
      title: json['title'] ?? '',
      order: json['order'] ?? 0,
      lessons: (json['lessons'] as List? ?? [])
          .map((e) => MyCourseLesson.fromJson(Map<String, dynamic>.from(e)))
          .toList(),
    );
  }
}

class MyCourseLesson {
  final int id;
  final String? title;
  final String? content;
  final String? type;
  final int durationMinutes;
  final int order;
  final String? videoUrl;
  final String? lessonStatus;
  final String? completedAt;
  final List<MyLessonMaterial> materials;

  MyCourseLesson({
    this.id = 0,
    this.title,
    this.content,
    this.type,
    this.durationMinutes = 0,
    this.order = 0,
    this.videoUrl,
    this.lessonStatus,
    this.completedAt,
    this.materials = const [],
  });

  bool get isCompleted => lessonStatus == 'completed';

  factory MyCourseLesson.fromJson(Map<String, dynamic> json) {
    return MyCourseLesson(
      id: json['id'] ?? 0,
      title: json['title'] ?? '',
      content: json['content'] ?? '',
      type: json['type'] as String?,
      durationMinutes: json['duration_minutes'] ?? 0,
      order: json['order'] ?? 0,
      videoUrl: json['video_url'] as String?,
      lessonStatus: json['lesson_status'] as String?,
      completedAt: json['completed_at'] as String?,
      materials: (json['materials'] as List? ?? [])
          .map((e) => MyLessonMaterial.fromJson(Map<String, dynamic>.from(e)))
          .toList(),
    );
  }
}

class MyLessonMaterial {
  final int id;
  final String name;
  final String typeLabel;
  final String? url;

  MyLessonMaterial({
    this.id = 0,
    this.name = '',
    this.typeLabel = '',
    this.url,
  });

  factory MyLessonMaterial.fromJson(Map<String, dynamic> json) {
    return MyLessonMaterial(
      id: json['id'] ?? 0,
      name: json['file_name'] ?? json['name'] ?? json['title'] ?? '',
      typeLabel: json['type_label'] ?? 'File',
      url: json['download_url'] ?? json['url'],
    );
  }
}
