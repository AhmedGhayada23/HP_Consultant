class ConsultantProjectModel {
  final int id;
  final String name;
  final String email;
  final String mobile;       // ✅ مضاف
  final String role;
  final dynamic expertise;
  final List<dynamic> assignedProjects;
  final double rate;
  final int experience;      // ✅ مضاف
  final String location;     // ✅ مضاف
  final String status;
  final String statusLabel;
  final String? cvUrl; // رابط السيرة الذاتية (قد يكون null)

  ConsultantProjectModel({
    required this.id,
    required this.name,
    required this.email,
    required this.mobile,
    required this.role,
    required this.expertise,
    required this.assignedProjects,
    required this.rate,
    required this.experience,
    required this.location,
    required this.status,
    required this.statusLabel,
    this.cvUrl,
  });

  factory ConsultantProjectModel.fromJson(Map<String, dynamic> json) {
    return ConsultantProjectModel(
      id: json['id'] ?? 0,
      name: json['name']?.toString() ?? '',
      email: json['email']?.toString() ?? '',
      mobile: json['mobile']?.toString() ?? '',
      role: json['role']?.toString() ?? '',
      expertise: json['experience']?.toString() ?? '',
      assignedProjects: json['assigned_projects'] ?? [],
      rate: double.tryParse(json['rate'].toString()) ?? 0.0,
      experience: int.tryParse(json['experience'].toString()) ?? 0,
      location: json['location']?.toString() ?? 'N/A',
      status: json['status']?.toString() ?? '',
      statusLabel: json['status_label']?.toString() ?? '',
      cvUrl: (json['cv_download_url'] ??
              json['cv_url'] ??
              json['cv'] ??
              json['resume_url'])
          ?.toString(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      "id": id,
      "name": name,
      "email": email,
      "mobile": mobile,
      "role": role,
      "expertise": expertise,
      "assigned_projects": assignedProjects,
      "rate": rate,
      "experience": experience,
      "location": location,
      "status": status,
      "status_label": statusLabel,
    };
  }

  factory ConsultantProjectModel.fake() => ConsultantProjectModel(
        id: 0,
        name: 'name',
        email: 'email',
        mobile: 'mobile',
        role: 'role',
        expertise: 'expertise',
        assignedProjects: [],
        rate: 0,
        experience: 0,
        location: 'N/A',
        status: 'status',
        statusLabel: 'statusLabel',
      );
}
