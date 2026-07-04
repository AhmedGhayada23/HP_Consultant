class Country {
  final int id;
  final String name;
  final String nameAr;
  final String code;
  final String phoneCode;
  final String flag;

  Country({
    required this.id,
    required this.name,
    required this.nameAr,
    required this.code,
    required this.phoneCode,
    required this.flag,
  });

  factory Country.fromJson(Map<String, dynamic> json) {
    return Country(
      id: json['id'],
      name: json['name'],
      nameAr: json['name_ar'],
      code: json['code'],
      phoneCode: json['phone_code'],
      flag: json['flag'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'name_ar': nameAr,
      'code': code,
      'phone_code': phoneCode,
      'flag': flag,
    };
  }

  factory Country.fackCountry() {
    return Country(
      id: 0,
      name: 'Country',
      nameAr: 'الدولة',
      code: '000',
      phoneCode: '+000',
      flag: 'DDD',
    );
  }
}
