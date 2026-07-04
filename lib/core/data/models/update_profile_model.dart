import 'dart:io';
import 'package:dio/dio.dart';

class UpdateProfileModel {
  final File? profileImage;
  final String fullName;
  final String email;
  final String codeCountry;
  final String mobileNumber;
  final String? companyName;
  final String? registrationNumber;
  final String? industry;
  final int? mainCountryId;
  final int? mainCityId;
  final String type;

  UpdateProfileModel({
    this.profileImage,
    required this.fullName,
    required this.email,
    required this.codeCountry,
    required this.mobileNumber,
    this.companyName,
    this.registrationNumber,
    this.industry,
    this.mainCountryId,
    this.mainCityId,
    required this.type,
  });

  Future<FormData> toFormData() async {
    final Map<String, dynamic> data = {
      'owner_name': fullName,
      'email': email,
      'country_code': codeCountry,
      'mobile': mobileNumber,
      'name': companyName,
      'tax_id': registrationNumber,
      'industry': industry,
      'country_id': mainCountryId,
      'province_id': mainCityId,
      'type': type,
    };

    if (profileImage != null) {
      data['image'] = await MultipartFile.fromFile(
        profileImage!.path,
        filename: profileImage!.path.split('/').last,
      );
    }

    return FormData.fromMap(data);
  }
}
