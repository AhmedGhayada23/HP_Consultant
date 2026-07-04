import 'dart:io';
import 'package:dio/dio.dart';

class RegisterModel {
  final File? profileImage;
  final String fullName;
  final String email;
  final String codeCountry;
  final String mobileNumber;
  final String password;
  final String type;
  final bool termsAccepted;

  // Company
  final String? companyName;
  final String? registrationNumber;
  final String? industry;
  final int? mainCountryId;
  final int? mainCityId;

  // Consultant
  final int? professionId;
  final List<int>? skillIds;
  final String? hourlyRate;
  final String? portfolioUrl1;
  final String? portfolioUrl2;
  final File? cv;

  // Student
  final String? schoolUniversity;

  // Accounting client
  final String? businessName;
  final String? businessEmail;
  final String? taxId;
  final String? taxType;
  final String? address;
  final String? website;
  final String? notes;
  final String? clientType;

  RegisterModel({
    this.profileImage,
    required this.fullName,
    required this.email,
    required this.codeCountry,
    required this.mobileNumber,
    required this.password,
    required this.type,
    this.termsAccepted = true,
    this.companyName,
    this.registrationNumber,
    this.industry,
    this.mainCountryId,
    this.mainCityId,
    this.professionId,
    this.skillIds,
    this.hourlyRate,
    this.portfolioUrl1,
    this.portfolioUrl2,
    this.cv,
    this.schoolUniversity,
    this.businessName,
    this.businessEmail,
    this.taxId,
    this.taxType,
    this.address,
    this.website,
    this.notes,
    this.clientType,
  });

  Future<FormData> toFormData() async {
    final Map<String, dynamic> data = {
      'email': email,
      'country_code': codeCountry,
      'mobile': mobileNumber,
      'password': password,
      'password_confirmation': password,
      'type': type,
      'terms_accepted': termsAccepted ? 1 : 0,
    };

    switch (type) {
      case 'company':
        data['owner_name'] = fullName;
        if (companyName != null) data['name'] = companyName;
        if (registrationNumber != null) data['tax_id'] = registrationNumber;
        if (industry != null) data['industry'] = industry;
        if (mainCountryId != null) data['country_id'] = mainCountryId;
        if (mainCityId != null) data['province_id'] = mainCityId;
        break;

      case 'consultant':
        data['name'] = fullName;
        if (professionId != null) data['profession_id'] = professionId;
        if (hourlyRate != null && hourlyRate!.isNotEmpty) data['hourly_rate'] = hourlyRate;
        if (portfolioUrl1 != null && portfolioUrl1!.isNotEmpty) data['portfolio_url_1'] = portfolioUrl1;
        if (portfolioUrl2 != null && portfolioUrl2!.isNotEmpty) data['portfolio_url_2'] = portfolioUrl2;
        break;

      case 'student':
        data['name'] = fullName;
        if (schoolUniversity != null && schoolUniversity!.isNotEmpty) {
          data['school_university'] = schoolUniversity;
        }
        if (professionId != null) { data['profession_id'] = professionId; }
        break;

      case 'accounting':
        data['contact_person'] = fullName;
        if (businessName != null) data['business_name'] = businessName;
        if (businessEmail != null && businessEmail!.isNotEmpty) {
          data['business_email'] = businessEmail;
        }
        if (taxId != null) data['tax_id'] = taxId;
        if (taxType != null && taxType!.isNotEmpty) data['tax_type'] = taxType;
        break;
    }

    // image field name differs per type
    if (profileImage != null) {
      final imageFieldName = type == 'consultant' ? 'profile_photo' : 'image';
      data[imageFieldName] = await MultipartFile.fromFile(
        profileImage!.path,
        filename: profileImage!.path.split('/').last,
      );
    }

    final formData = FormData.fromMap(data);

    if (skillIds != null && skillIds!.isNotEmpty) {
      for (int i = 0; i < skillIds!.length; i++) {
        formData.fields.add(MapEntry('skill_ids[$i]', skillIds![i].toString()));
      }
    }

    if (cv != null) {
      formData.files.add(MapEntry(
        'cv',
        await MultipartFile.fromFile(cv!.path, filename: cv!.path.split('/').last),
      ));
    }

    return formData;
  }
}
