class ConsultantCategoryModel {
  final int id;
  final String name;
  final String slug;

  ConsultantCategoryModel({this.id = 0, this.name = '', this.slug = ''});

  factory ConsultantCategoryModel.fromJson(Map<String, dynamic> json) {
    return ConsultantCategoryModel(
      id: json['id'] is int ? json['id'] : int.tryParse('${json['id']}') ?? 0,
      name: json['name']?.toString() ?? '',
      slug: json['slug']?.toString() ?? '',
    );
  }
}
