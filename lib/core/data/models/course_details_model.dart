class CourseDetailsModel {
  final int id;
  final String title;
  final String description;
  final String objectives;
  final String? prerequisites;
  final CourseCategory category;
  final CourseTrainer trainer;
  final String level;
  final String levelDisplay;
  final int durationHours;
  final double price;
  final String priceDisplay;
  final String? thumbnail;
  final String? videoIntro;
  final String status;
  final int maxStudents;
  final double rating;
  final int totalEnrollments;
  final List<dynamic> modules;

  CourseDetailsModel({
    required this.id,
    required this.title,
    required this.description,
    required this.objectives,
    this.prerequisites,
    required this.category,
    required this.trainer,
    required this.level,
    required this.levelDisplay,
    required this.durationHours,
    required this.price,
    required this.priceDisplay,
    this.thumbnail,
    this.videoIntro,
    required this.status,
    required this.maxStudents,
    required this.rating,
    required this.totalEnrollments,
    required this.modules,
  });

  factory CourseDetailsModel.fromJson(Map<String, dynamic> json) {
    return CourseDetailsModel(
      id: json['id'],
      title: json['title'],
      description: json['description'],
      objectives: json['objectives'],
      prerequisites: json['prerequisites'],
      category: CourseCategory.fromJson(json['category']),
      trainer: CourseTrainer.fromJson(json['trainer']),
      level: json['level'],
      levelDisplay: json['level_display'],
      durationHours: json['duration_hours'],
      price: (json['price'] as num).toDouble(),
      priceDisplay: json['price_display'],
      thumbnail: json['thumbnail'],
      videoIntro: json['video_intro'],
      status: json['status'],
      maxStudents: json['max_students'],
      rating: (json['rating'] as num).toDouble(),
      totalEnrollments: json['total_enrollments'],
      modules: json['modules'] ?? [],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'title': title,
      'description': description,
      'objectives': objectives,
      'prerequisites': prerequisites,
      'category': category.toJson(),
      'trainer': trainer.toJson(),
      'level': level,
      'level_display': levelDisplay,
      'duration_hours': durationHours,
      'price': price,
      'price_display': priceDisplay,
      'thumbnail': thumbnail,
      'video_intro': videoIntro,
      'status': status,
      'max_students': maxStudents,
      'rating': rating,
      'total_enrollments': totalEnrollments,
      'modules': modules,
    };
  }

  factory CourseDetailsModel.fake() {
    return CourseDetailsModel(
      id: 0,
      title: 'Course Title Placeholder',
      description: 'Description placeholder text goes here',
      objectives: 'Learning objectives placeholder',
      prerequisites: null,
      category: CourseCategory(id: 0, name: 'Category'),
      trainer: CourseTrainer(id: 0, name: 'Trainer Name', email: 'trainer@example.com'),
      level: 'beginner',
      levelDisplay: 'Beginner',
      durationHours: 40,
      price: 500,
      priceDisplay: '€500.00',
      thumbnail: null,
      videoIntro: null,
      status: 'published',
      maxStudents: 30,
      rating: 0.0,
      totalEnrollments: 0,
      modules: [],
    );
  }
}

class CourseCategory {
  final int id;
  final String name;

  CourseCategory({required this.id, required this.name});

  factory CourseCategory.fromJson(Map<String, dynamic> json) {
    return CourseCategory(id: json['id'], name: json['name']);
  }

  Map<String, dynamic> toJson() => {'id': id, 'name': name};
}

class CourseTrainer {
  final int id;
  final String name;
  final String email;

  CourseTrainer({required this.id, required this.name, required this.email});

  factory CourseTrainer.fromJson(Map<String, dynamic> json) {
    return CourseTrainer(id: json['id'], name: json['name'], email: json['email']);
  }

  Map<String, dynamic> toJson() => {'id': id, 'name': name, 'email': email};
}
