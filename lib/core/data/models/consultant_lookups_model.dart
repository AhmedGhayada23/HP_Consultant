import 'package:hb/core/data/models/skills_model.dart';

class JobCategoryModel {
  final int id;
  final String name;
  final String nameAr;
  final String slug;

  JobCategoryModel({
    required this.id,
    required this.name,
    required this.nameAr,
    required this.slug,
  });

  factory JobCategoryModel.fromJson(Map<String, dynamic> json) {
    return JobCategoryModel(
      id: json['id'],
      name: json['name'] ?? '',
      nameAr: json['name_ar'] ?? '',
      slug: json['slug'] ?? '',
    );
  }
}

class ConsultantLookupsModel {
  final List<JobCategoryModel> jobCategories;
  final List<JobCategoryModel> professions;
  final List<SkillsModel> skills;

  ConsultantLookupsModel({
    required this.jobCategories,
    required this.professions,
    required this.skills,
  });

  factory ConsultantLookupsModel.fromJson(Map<String, dynamic> json) {
    final data = json['data'] ?? {};
    return ConsultantLookupsModel(
      jobCategories: (data['job_categories'] as List? ?? [])
          .map((e) => JobCategoryModel.fromJson(e))
          .toList(),
      professions: (data['professions'] as List? ?? [])
          .map((e) => JobCategoryModel.fromJson(e))
          .toList(),
      skills: (data['skills'] as List? ?? [])
          .map((e) => SkillsModel.fromJson(e))
          .toList(),
    );
  }
}
