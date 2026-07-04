import 'package:hb/core/data/models/skills_model.dart';

Map<String, dynamic> _m(dynamic v) =>
    v == null ? {} : Map<String, dynamic>.from(v as Map);

class ProfileResponseModel {
  final UserModel user;
  final CountryModel country;
  final ProvinceModel province;
  final String imageUrl;
  final String message;
  final bool status;

  ProfileResponseModel({
    required this.user,
    required this.country,
    required this.province,
    required this.imageUrl,
    required this.message,
    required this.status,
  });

  factory ProfileResponseModel.fake() => ProfileResponseModel(
        user: UserModel.fake(),
        country: CountryModel(
            id: 0, name: 'Country', nameAr: 'الدولة', code: '', phoneCode: '', flag: ''),
        province: ProvinceModel(id: 0, name: 'Province'),
        imageUrl: '',
        message: '',
        status: false,
      );

  factory ProfileResponseModel.fromJson(Map<String, dynamic> json) {
    final data = _m(json['data']);
    final type = (data['type'] ?? '').toString();
    final userRaw = _m(data['user']);
    final profileRaw = _m(userRaw['profile']);

    // عميل المحاسبة: بيانات المستخدم من contact_person، والأعمال من business_information
    final contactPerson = _m(data['contact_person']);
    final businessInfo = _m(data['business_information']);

    final Map<String, dynamic> userJson = userRaw.isNotEmpty
        ? {...userRaw, 'type': type}
        : {
            'name': contactPerson['full_name'] ?? '',
            'email': contactPerson['email'] ?? '',
            'mobile': contactPerson['mobile'] ?? '',
            'country_code': contactPerson['country_code'] ?? '',
            'type': type,
          };
    if (businessInfo.isNotEmpty) {
      userJson['business_information'] = businessInfo;
    }

    final imageUrl = data['image_url'] as String? ??
        userRaw['image_url'] as String? ??
        profileRaw['profile_photo_url'] as String? ??
        '';

    return ProfileResponseModel(
      user: UserModel.fromJson(userJson),
      country: data['country'] != null
          ? CountryModel.fromJson(_m(data['country']))
          : CountryModel(id: 0, name: '', nameAr: '', code: '', phoneCode: '', flag: ''),
      province: data['province'] != null
          ? ProvinceModel.fromJson(_m(data['province']))
          : ProvinceModel(id: 0, name: ''),
      imageUrl: imageUrl,
      message: json['message'] as String? ?? '',
      status: json['status'] as bool? ?? false,
    );
  }
}

class CountryModel {
  final int id;
  final String name;
  final String nameAr;
  final String code;
  final String phoneCode;
  final String flag;

  CountryModel({
    required this.id,
    required this.name,
    required this.nameAr,
    required this.code,
    required this.phoneCode,
    required this.flag,
  });

  factory CountryModel.fromJson(Map<String, dynamic> json) {
    return CountryModel(
      id: json['id'] as int? ?? 0,
      name: json['name'] as String? ?? '',
      nameAr: json['name_ar'] as String? ?? '',
      code: json['code'] as String? ?? '',
      phoneCode: json['phone_code'] as String? ?? '',
      flag: json['flag'] as String? ?? '',
    );
  }
}

class ProvinceModel {
  final int id;
  final String name;

  ProvinceModel({required this.id, required this.name});

  factory ProvinceModel.fromJson(Map<String, dynamic> json) {
    return ProvinceModel(
      id: json['id'] as int? ?? 0,
      name: json['name'] as String? ?? '',
    );
  }
}

class StudentProfileModel {
  final String? schoolUniversity;
  final int? professionId;
  final String? professionName;
  final String? major;

  StudentProfileModel({
    this.schoolUniversity,
    this.professionId,
    this.professionName,
    this.major,
  });

  factory StudentProfileModel.fromJson(Map<String, dynamic> json) {
    return StudentProfileModel(
      schoolUniversity: json['school_university'] as String?,
      professionId: json['profession_id'] as int?,
      professionName: json['profession_name'] as String? ??
          (json['profession'] is Map ? _m(json['profession'])['name'] as String? : null),
      major: json['major'] as String?,
    );
  }
}

class AccountingProfileModel {
  final String businessName;
  final String businessEmail;
  final String taxId;
  final String taxType;
  final String taxTypeTitle;

  AccountingProfileModel({
    this.businessName = '',
    this.businessEmail = '',
    this.taxId = '',
    this.taxType = '',
    this.taxTypeTitle = '',
  });

  factory AccountingProfileModel.fromJson(Map<String, dynamic> json) {
    return AccountingProfileModel(
      businessName: json['business_name']?.toString() ?? '',
      businessEmail: json['business_email']?.toString() ?? '',
      taxId: json['tax_id']?.toString() ?? '',
      taxType: json['tax_type']?.toString() ?? '',
      taxTypeTitle: json['tax_type_title']?.toString() ?? '',
    );
  }
}

class ConsultantProfileModel {
  final int? professionId;
  final String? professionName;
  final String? hourlyRate;
  final String? portfolioUrl1;
  final String? portfolioUrl2;
  final String? cvUrl;

  ConsultantProfileModel({
    this.professionId,
    this.professionName,
    this.hourlyRate,
    this.portfolioUrl1,
    this.portfolioUrl2,
    this.cvUrl,
  });

  factory ConsultantProfileModel.fromJson(Map<String, dynamic> json) {
    final profession = json['profession'] != null ? _m(json['profession']) : null;
    return ConsultantProfileModel(
      professionId: json['profession_id'] as int?,
      professionName: profession?['name'] as String?,
      hourlyRate: json['hourly_rate']?.toString(),
      portfolioUrl1: json['portfolio_url_1'] as String?,
      portfolioUrl2: json['portfolio_url_2'] as String?,
      cvUrl: json['cv_url'] as String?,
    );
  }
}

class CompanyModel {
  final int id;
  final int userId;
  final String name;
  final String type;
  final String typeTitle;
  final String taxId;
  final String industry;
  final String? address;
  final String? website;
  final String? description;
  final String createdAt;
  final String? deletedAt;
  final String? imageUrl;
  final CountryModel? country;
  final ProvinceModel? province;

  CompanyModel({
    required this.id,
    required this.userId,
    required this.name,
    required this.type,
    required this.typeTitle,
    required this.taxId,
    required this.industry,
    this.address,
    this.website,
    this.description,
    required this.createdAt,
    this.deletedAt,
    this.imageUrl,
    this.country,
    this.province,
  });

  factory CompanyModel.fromJson(Map<String, dynamic> json) {
    return CompanyModel(
      id: json['id'] as int? ?? 0,
      userId: json['user_id'] as int? ?? 0,
      name: json['name'] as String? ?? '',
      type: json['type'] as String? ?? '',
      typeTitle: json['type_title'] as String? ?? '',
      taxId: json['tax_id'] as String? ?? '',
      industry: json['industry'] as String? ?? '',
      address: json['address'] as String?,
      website: json['website'] as String?,
      description: json['description'] as String?,
      createdAt: json['created_at'] as String? ?? '',
      deletedAt: json['deleted_at'] as String?,
      imageUrl: json['image_url'] as String?,
      country: json['country'] != null
          ? CountryModel.fromJson(_m(json['country']))
          : null,
      province: json['province'] != null
          ? ProvinceModel.fromJson(_m(json['province']))
          : null,
    );
  }
}

class UserModel {
  final int id;
  final String name;
  final String email;
  final String type;
  final String mobile;
  final String countryCode;
  final int active;
  final String activeTitle;
  final CompanyModel? company;
  final ConsultantProfileModel? consultantProfile;
  final StudentProfileModel? studentProfile;
  final AccountingProfileModel? accountingProfile;
  final List<SkillsModel> skills;

  UserModel({
    required this.id,
    required this.name,
    required this.email,
    required this.type,
    required this.mobile,
    this.countryCode = '',
    required this.active,
    required this.activeTitle,
    this.company,
    this.consultantProfile,
    this.studentProfile,
    this.accountingProfile,
    this.skills = const [],
  });

  factory UserModel.fromJson(Map<String, dynamic> json) {
    return UserModel(
      id: json['id'] as int? ?? 0,
      name: json['name'] as String? ?? '',
      email: json['email'] as String? ?? '',
      type: json['type'] as String? ?? '',
      mobile: json['mobile'] as String? ?? '',
      countryCode: json['country_code'] as String? ?? '',
      active: json['active'] as int? ?? 0,
      activeTitle: json['active_title'] as String? ?? '',
      company: json['company'] != null
          ? CompanyModel.fromJson(_m(json['company']))
          : null,
      consultantProfile: json['profile'] != null
          ? ConsultantProfileModel.fromJson(_m(json['profile']))
          : null,
      // بيانات الطالب ترد تحت المفتاح "student" (مع بدائل احتياطية)
      studentProfile: json['student'] != null
          ? StudentProfileModel.fromJson(_m(json['student']))
          : json['student_profile'] != null
              ? StudentProfileModel.fromJson(_m(json['student_profile']))
              : (json['school_university'] != null
                  ? StudentProfileModel.fromJson(json)
                  : null),
      accountingProfile: json['business_information'] != null
          ? AccountingProfileModel.fromJson(_m(json['business_information']))
          : null,
      skills: (json['skills'] as List? ?? [])
          .map((e) => SkillsModel.fromJson(_m(e)))
          .toList(),
    );
  }

  factory UserModel.fake() {
    return UserModel(
      id: 0,
      name: 'name',
      email: 'email',
      type: 'type',
      mobile: 'mobile',
      active: 1,
      activeTitle: 'activeTitle',
    );
  }
}
