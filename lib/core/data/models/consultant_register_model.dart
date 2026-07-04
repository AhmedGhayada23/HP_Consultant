import 'dart:io';
import 'package:dio/dio.dart';

class ConsultantRegisterModel {
  final String name;
  final String email;
  final String countryCode;
  final String mobile;
  final String password;
  final int? professionId;
  final String? hourlyRate;
  final String? portfolioUrl1;
  final String? portfolioUrl2;
  final List<int>? skillIds;
  final bool termsAccepted;
  final File? profilePhoto;
  final File? cv;

  ConsultantRegisterModel({
    required this.name,
    required this.email,
    required this.countryCode,
    required this.mobile,
    required this.password,
    this.professionId,
    this.hourlyRate,
    this.portfolioUrl1,
    this.portfolioUrl2,
    this.skillIds,
    this.termsAccepted = true,
    this.profilePhoto,
    this.cv,
  });

  Future<FormData> toFormData() async {
    final formData = FormData();

    formData.fields.addAll([
      MapEntry('name', name),
      MapEntry('email', email),
      MapEntry('country_code', countryCode),
      MapEntry('mobile', mobile),
      MapEntry('password', password),
      MapEntry('password_confirmation', password),
      MapEntry('terms_accepted', termsAccepted ? '1' : '0'),
    ]);

    if (professionId != null) {
      formData.fields.add(MapEntry('profession_id', professionId.toString()));
    }
    if (hourlyRate != null && hourlyRate!.isNotEmpty) {
      formData.fields.add(MapEntry('hourly_rate', hourlyRate!));
    }
    if (portfolioUrl1 != null && portfolioUrl1!.isNotEmpty) {
      formData.fields.add(MapEntry('portfolio_url_1', portfolioUrl1!));
    }
    if (portfolioUrl2 != null && portfolioUrl2!.isNotEmpty) {
      formData.fields.add(MapEntry('portfolio_url_2', portfolioUrl2!));
    }

    if (skillIds != null && skillIds!.isNotEmpty) {
      for (int i = 0; i < skillIds!.length; i++) {
        formData.fields.add(MapEntry('skill_ids[$i]', skillIds![i].toString()));
      }
    }

    if (profilePhoto != null) {
      formData.files.add(MapEntry(
        'profile_photo',
        await MultipartFile.fromFile(
          profilePhoto!.path,
          filename: profilePhoto!.path.split('/').last,
        ),
      ));
    }

    if (cv != null) {
      formData.files.add(MapEntry(
        'cv',
        await MultipartFile.fromFile(
          cv!.path,
          filename: cv!.path.split('/').last,
        ),
      ));
    }

    return formData;
  }
}
