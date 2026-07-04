class TrainerModel {
  final int id;
  final String name;

  TrainerModel({required this.id, required this.name});

  factory TrainerModel.fromJson(Map<String, dynamic> json) {
    return TrainerModel(
      id: (json['id'] as num?)?.toInt() ?? 0,
      name: json['name']?.toString() ?? '',
    );
  }

  factory TrainerModel.fake() => TrainerModel(id: 0, name: 'د. ياسر القاسم');
}

class TrainingCourseModel {
  final int id;
  final String title;
  final String description;
  final String category;
  final TrainerModel trainer;
  final String level;
  final int durationHours;
  final String price;
  final String priceDisplay;
  final double rating;
  final int totalEnrollments;
  final String? thumbnail;

  TrainingCourseModel({
    required this.id,
    required this.title,
    required this.description,
    required this.category,
    required this.trainer,
    required this.level,
    required this.durationHours,
    required this.price,
    required this.priceDisplay,
    required this.rating,
    required this.totalEnrollments,
    this.thumbnail,
  });

  factory TrainingCourseModel.fromJson(Map<String, dynamic> json) {
    return TrainingCourseModel(
      id: (json['id'] as num?)?.toInt() ?? 0,
      title: json['title']?.toString() ?? '',
      description: json['description']?.toString() ?? '',
      category: json['category']?.toString() ?? '',
      trainer: TrainerModel.fromJson(json['trainer']),
      level: json['level']?.toString() ?? '',
      durationHours: (json['duration_hours'] as num?)?.toInt() ?? 0,
      price: json['price']?.toString() ?? '',
      priceDisplay: json['price_display']?.toString() ?? '',
      rating: (json['rating'] as num?)?.toDouble() ?? 0.0,
      totalEnrollments: (json['total_enrollments'] as num?)?.toInt() ?? 0,
      thumbnail: json['thumbnail']?.toString(),
    );
  }

  factory TrainingCourseModel.fake() {
    return TrainingCourseModel(
      id: 0,
      title: 'Laravel للمبتدئين',
      description: 'تعلم Laravel من الصفر',
      category: 'البرمجة والتطوير',
      trainer: TrainerModel.fake(),
      level: 'Beginner',
      durationHours: 40,
      price: '500.00',
      priceDisplay: '€500.00',
      rating: 0.0,
      totalEnrollments: 5,
      thumbnail: null,
    );
  }
}
