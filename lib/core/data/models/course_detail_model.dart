class CourseDetailModel {
  final int id;
  final String title;
  final String description;
  final String level;
  final String levelLabel;
  final String price;
  final String priceDisplay;
  final int durationHours;
  final String? thumbnailUrl;
  final String? videoIntroUrl;
  final double rating;
  final int reviewsCount;
  final CourseCategory? category;
  final Trainer? trainer;
  final List<String> learningOutcomes;
  final CourseStats stats;
  final bool paymentRequired;
  final bool hasPaidAccess;
  final bool isEnrolled;
  final List<CourseModule> modules;

  CourseDetailModel({
    required this.id,
    required this.title,
    required this.description,
    required this.level,
    required this.levelLabel,
    required this.price,
    required this.priceDisplay,
    required this.durationHours,
    required this.thumbnailUrl,
    required this.videoIntroUrl,
    required this.rating,
    required this.reviewsCount,
    required this.category,
    required this.trainer,
    required this.learningOutcomes,
    required this.stats,
    required this.paymentRequired,
    required this.hasPaidAccess,
    required this.isEnrolled,
    required this.modules,
  });

  factory CourseDetailModel.fromJson(Map<String, dynamic> json) {
    return CourseDetailModel(
      id: json['id'] as int? ?? 0,
      title: json['title'] as String? ?? '',
      description: json['description'] as String? ?? '',
      level: json['level'] as String? ?? '',
      levelLabel: json['level_label'] as String? ?? '',
      price: json['price']?.toString() ?? '',
      priceDisplay: json['price_display'] as String? ?? '',
      durationHours: json['duration_hours'] as int? ?? 0,
      thumbnailUrl: json['thumbnail_url'] as String?,
      videoIntroUrl: json['video_intro_url'] as String?,
      rating: (json['rating'] as num?)?.toDouble() ?? 0,
      reviewsCount: json['reviews_count'] as int? ?? 0,
      category: json['category'] != null
          ? CourseCategory.fromJson(Map<String, dynamic>.from(json['category'] as Map))
          : null,
      trainer: json['trainer'] != null
          ? Trainer.fromJson(Map<String, dynamic>.from(json['trainer'] as Map))
          : null,
      learningOutcomes: (json['learning_outcomes'] as List?)
              ?.map((e) => e.toString())
              .toList() ??
          [],
      stats: CourseStats.fromJson(
        json['stats'] != null
            ? Map<String, dynamic>.from(json['stats'] as Map)
            : const {},
      ),
      paymentRequired: json['payment_required'] as bool? ?? false,
      hasPaidAccess: json['has_paid_access'] as bool? ?? false,
      isEnrolled: json['is_enrolled'] as bool? ?? false,
      modules: (json['modules'] as List?)
              ?.map((e) => CourseModule.fromJson(Map<String, dynamic>.from(e as Map)))
              .toList() ??
          [],
    );
  }
}

class CourseCategory {
  final int id;
  final String name;

  CourseCategory({required this.id, required this.name});

  factory CourseCategory.fromJson(Map<String, dynamic> json) {
    return CourseCategory(
      id: json['id'] as int? ?? 0,
      name: json['name'] as String? ?? '',
    );
  }
}

class CourseStats {
  final int durationHours;
  final String level;
  final String format;
  final bool certificate;

  CourseStats({
    required this.durationHours,
    required this.level,
    required this.format,
    required this.certificate,
  });

  factory CourseStats.fromJson(Map<String, dynamic> json) {
    return CourseStats(
      durationHours: json['duration_hours'] as int? ?? 0,
      level: json['level'] as String? ?? '',
      format: json['format'] as String? ?? '',
      certificate: json['certificate'] as bool? ?? false,
    );
  }
}

class Trainer {
  final String name;
  final String bio;
  final List<String> experience;
  final List<String> certifications;

  Trainer({
    required this.name,
    required this.bio,
    required this.experience,
    required this.certifications,
  });

  factory Trainer.fromJson(Map<String, dynamic> json) {
    return Trainer(
      name: json['name'] as String? ?? '',
      bio: json['bio'] as String? ?? '',
      experience:
          (json['experience'] as List?)?.map((e) => e.toString()).toList() ?? [],
      certifications: (json['certifications'] as List?)
              ?.map((e) => e.toString())
              .toList() ??
          [],
    );
  }
}

class CourseModule {
  final int id;
  final String title;
  final int order;
  final List<CourseLesson> lessons;

  CourseModule({
    required this.id,
    required this.title,
    required this.order,
    required this.lessons,
  });

  factory CourseModule.fromJson(Map<String, dynamic> json) {
    return CourseModule(
      id: json['id'] as int? ?? 0,
      title: json['title'] as String? ?? '',
      order: json['order'] as int? ?? 0,
      lessons: (json['lessons'] as List?)
              ?.map((e) => CourseLesson.fromJson(Map<String, dynamic>.from(e as Map)))
              .toList() ??
          [],
    );
  }
}

class CourseLesson {
  final int id;
  final String title;
  final String type;
  final int durationMinutes;
  final int order;
  final bool isPreview;
  final String? videoUrl;

  CourseLesson({
    required this.id,
    required this.title,
    required this.type,
    required this.durationMinutes,
    required this.order,
    required this.isPreview,
    required this.videoUrl,
  });

  factory CourseLesson.fromJson(Map<String, dynamic> json) {
    return CourseLesson(
      id: json['id'] as int? ?? 0,
      title: json['title'] as String? ?? '',
      type: json['type'] as String? ?? '',
      durationMinutes: json['duration_minutes'] as int? ?? 0,
      order: json['order'] as int? ?? 0,
      isPreview: json['is_preview'] as bool? ?? false,
      videoUrl: json['video_url'] as String?,
    );
  }
}
