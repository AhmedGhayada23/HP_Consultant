class ProjectTypesModel {
  final int id;
  final String name;
  final String nameAr;

  ProjectTypesModel({required this.id, required this.name, required this.nameAr});

  factory ProjectTypesModel.fromJson(Map<String, dynamic> json) {
    return ProjectTypesModel(
      id: json['id'] as int,
      name: json['name'] as String,
      nameAr: json['name_ar'] as String,
    );
  }
}
