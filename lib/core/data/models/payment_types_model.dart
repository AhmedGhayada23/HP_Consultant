class PaymentTypesModel {
  final int id;
  final String value;
  final String name;
  final String nameAr;

  PaymentTypesModel({required this.id, required this.value, required this.name, required this.nameAr});


  factory PaymentTypesModel.fromJson(Map<String, dynamic> json) {
    return PaymentTypesModel(
      id: json['id'] as int,
      value: json['value'] as String,
      name: json['name'] as String,
      nameAr: json['name_ar'] as String,
    );
  }
}
