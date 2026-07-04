import 'package:hb/core/data/models/cities_model.dart';
import 'package:hb/core/data/models/country_model.dart';

class CompanyModel {
  final int id;
  final String name;
  final String type;
  final String typeTitle;
  final String? taxId;
  final String? industry;
  final String imageUrl;
  final Country country;
  final CitiesModel province;

  CompanyModel({
    required this.id,
    required this.name,
    required this.type,
    required this.typeTitle,
    this.taxId,
    this.industry,
    required this.imageUrl,
    required this.country,
    required this.province,
  });

  factory CompanyModel.fromJson(Map<String, dynamic> json) {
    return CompanyModel(
      id: json['id'],
      name: json['name'],
      type: json['type'],
      typeTitle: json['type_title'],
      taxId: json['tax_id'],
      industry: json['industry'],
      imageUrl: json['image_url'],
      country: Country.fromJson(json['country']),
      province: CitiesModel.fromJson(json['province']),
    );
  }

  factory CompanyModel.fackCopany() {
    return CompanyModel(
      id: 1,
      name: 'Acme Corp',
      type: 'LLC',
      typeTitle: 'Limited Liability Company',
      taxId: '123456789',
      industry: 'Technology',
      imageUrl: 'https://example.com/image.png',
      country: Country.fackCountry(),
      province: CitiesModel.fackCitiesModel(),
    );
  }
}
