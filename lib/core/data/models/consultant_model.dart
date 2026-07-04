// lib/featuer/counsultants_directory/data/models/consultant_model.dart

class ConsultantModel {
  final String? id;
  final String? name;
  final String? title;
  final List<String>? skills;
  final String? experience;
  final String? rate;
  final String? availability;
  final String? imageUrl;

  ConsultantModel({
     this.id,
     this.name,
     this.title,
     this.skills,
     this.experience,
     this.rate,
     this.availability,
     this.imageUrl,
  });

  factory ConsultantModel.fromJson(Map<String, dynamic> json) {
    return ConsultantModel(
      id: json['id'].toString(),
      name: json['name'] ?? '',
      title: json['role'] ?? json['title'] ?? '',
      skills: List<String>.from(json['skills'] ?? []),
      experience: json['experience'] ?? '',
      rate: json['rate'] ?? '',
      availability: json['availability'] ?? '',
      imageUrl: json['profile_image_url'] ?? json['imageUrl'] ?? '',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'title': title,
      'skills': skills,
      'experience': experience,
      'rate': rate,
      'availability': availability,
      'imageUrl': imageUrl,
    };
  }
}
