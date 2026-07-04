import 'package:hb/core/data/models/consultant_lookups_model.dart';
import 'package:hb/core/data/models/skills_model.dart';

class ConsultantLookupsState {
  final bool loading;
  final List<JobCategoryModel> jobCategories;
  final List<JobCategoryModel> professions;
  final List<SkillsModel> skills;
  final String? errorMessage;

  const ConsultantLookupsState({
    this.loading = false,
    this.jobCategories = const [],
    this.professions = const [],
    this.skills = const [],
    this.errorMessage,
  });

  ConsultantLookupsState copyWith({
    bool? loading,
    List<JobCategoryModel>? jobCategories,
    List<JobCategoryModel>? professions,
    List<SkillsModel>? skills,
    String? errorMessage,
  }) {
    return ConsultantLookupsState(
      loading: loading ?? this.loading,
      jobCategories: jobCategories ?? this.jobCategories,
      professions: professions ?? this.professions,
      skills: skills ?? this.skills,
      errorMessage: errorMessage,
    );
  }
}
