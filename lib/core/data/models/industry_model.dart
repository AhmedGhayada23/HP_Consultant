class IndustryModel {
  final String value;
  final String name;
  final String nameAr;

  IndustryModel({
    required this.value,
    required this.name,
    required this.nameAr,
  });

  // الاسم المعروض حسب اللغة
  String displayName(bool isArabic) =>
      isArabic ? (nameAr.isNotEmpty ? nameAr : name) : name;

  factory IndustryModel.fromJson(Map<String, dynamic> json) {
    return IndustryModel(
      value: (json['value'] ?? '').toString(),
      name: (json['name'] ?? '').toString(),
      nameAr: (json['name_ar'] ?? '').toString(),
    );
  }

  factory IndustryModel.fake() =>
      IndustryModel(value: 'industry', name: 'Industry', nameAr: 'قطاع');
}
