class SkillsModel {
  final String id;
  final String name;
  final String nameAr;

  SkillsModel({required this.id, required this.name, required this.nameAr});

  factory SkillsModel.fromJson(Map<String, dynamic> json) {
    return SkillsModel(
      id: json['id'].toString(),
      name: json['name'] ?? '',
      nameAr: json['name_ar'] ?? '',
    );
  }

  factory SkillsModel.fack() {
    return SkillsModel(
      id: '0',
      name: 'Skill Name',
      nameAr: 'اسم المهارة',
    );
  }
}
