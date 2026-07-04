class ConsultantProfileDetailsModel {
  final int id;
  final String name;
  final String? profileImageUrl;
  final String availabilityStatus;
  final String role;
  final String summaryHourlyRate;
  final String experienceYearsSummary;
  final String? location;
  final String aboutText;
  final List<String> skills;
  final List<String> experienceTimeline;
  final List<String> certifications;
  final RateAndServices? rateAndServices;

  ConsultantProfileDetailsModel({
    this.id = 0,
    this.name = '',
    this.profileImageUrl,
    this.availabilityStatus = '',
    this.role = '',
    this.summaryHourlyRate = '',
    this.experienceYearsSummary = '',
    this.location,
    this.aboutText = '',
    this.skills = const [],
    this.experienceTimeline = const [],
    this.certifications = const [],
    this.rateAndServices,
  });

  factory ConsultantProfileDetailsModel.fromJson(Map<String, dynamic> json) {
    List<String> strList(dynamic v) =>
        v is List ? v.map((e) => e.toString()).toList() : <String>[];

    return ConsultantProfileDetailsModel(
      id: json['id'] is int ? json['id'] : int.tryParse('${json['id']}') ?? 0,
      name: json['name']?.toString() ?? '',
      profileImageUrl: json['profile_image_url']?.toString(),
      availabilityStatus: json['availability_status']?.toString() ?? '',
      role: json['role']?.toString() ?? '',
      summaryHourlyRate: json['summary_hourly_rate']?.toString() ?? '',
      experienceYearsSummary:
          json['experience_years_summary']?.toString() ?? '',
      location: json['location']?.toString(),
      aboutText: json['about_text']?.toString() ?? '',
      skills: strList(json['skills']),
      experienceTimeline: strList(json['experience_timeline']),
      certifications: strList(json['certifications']),
      rateAndServices: json['rate_and_services'] is Map
          ? RateAndServices.fromJson(
              Map<String, dynamic>.from(json['rate_and_services']))
          : null,
    );
  }
}

class RateAndServices {
  final String hourlyRate;
  final String projectRateStart;
  final String paymentTerms;

  RateAndServices({
    this.hourlyRate = '',
    this.projectRateStart = '',
    this.paymentTerms = '',
  });

  factory RateAndServices.fromJson(Map<String, dynamic> json) {
    return RateAndServices(
      hourlyRate: json['hourly_rate']?.toString() ?? '',
      projectRateStart: json['project_rate_start']?.toString() ?? '',
      paymentTerms: json['payment_terms']?.toString() ?? '',
    );
  }
}
