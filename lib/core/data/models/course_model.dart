class CourseCategoryModel {
  final int id;
  final String name;

  CourseCategoryModel({required this.id, required this.name});

  factory CourseCategoryModel.fromJson(Map<String, dynamic> json) {
    return CourseCategoryModel(
      id: json['id'] as int? ?? 0,
      name: json['name'] as String? ?? '',
    );
  }
}

class CourseModel {
  final int? id;
  final String? title;
  final String? description;
  final String? imageUrl;       // thumbnail_url
  final String? level;
  final String? levelLabel;
  final String? price;          // raw e.g. "500.00"
  final String? priceDisplay;   // formatted e.g. "€500.00"
  final int? durationHours;
  final CourseCategoryModel? category;
  final double? rating;
  final int? reviewsCount;
  final int? lessonsCount;

  CourseModel({
    this.id,
    this.title,
    this.description,
    this.imageUrl,
    this.level,
    this.levelLabel,
    this.price,
    this.priceDisplay,
    this.durationHours,
    this.category,
    this.rating,
    this.reviewsCount,
    this.lessonsCount,
  });

  factory CourseModel.fromJson(Map<String, dynamic> json) {
    return CourseModel(
      id: json['id'] as int?,
      title: json['title'] as String?,
      description: json['description'] as String?,
      imageUrl: json['thumbnail_url'] as String?,
      level: json['level'] as String?,
      levelLabel: json['level_label'] as String?,
      price: json['price']?.toString(),
      priceDisplay: json['price_display'] as String?,
      durationHours: json['duration_hours'] as int?,
      category: json['category'] != null
          ? CourseCategoryModel.fromJson(Map<String, dynamic>.from(json['category'] as Map))
          : null,
      rating: (json['rating'] as num?)?.toDouble(),
      reviewsCount: json['reviews_count'] as int?,
      lessonsCount: json['lessons_count'] as int?,
    );
  }
}

class CourseListResult {
  final List<CourseModel> courses;
  final int currentPage;
  final int lastPage;
  final int total;

  CourseListResult({
    required this.courses,
    required this.currentPage,
    required this.lastPage,
    required this.total,
  });
}
