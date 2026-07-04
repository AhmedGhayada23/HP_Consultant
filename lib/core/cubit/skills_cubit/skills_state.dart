import 'package:hb/core/data/models/skills_model.dart';

class SkillsState {
  final List<SkillsModel>? skills;
  final List<String> selectedSkills;
  final bool loading;
  final bool? success;
  SkillsState({this.skills, this.selectedSkills = const [], this.loading = false, this.success});
  SkillsState copyWith({List<SkillsModel>? skills, List<String>? selectedSkills, bool? loading, bool? success}) {
    return SkillsState(
      skills: skills ?? this.skills,
      selectedSkills: selectedSkills ?? this.selectedSkills,
      loading: loading ?? this.loading,
      success: success ?? this.success,
    );
  }
}
