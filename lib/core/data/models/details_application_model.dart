class DetailsApplicationModel {
  final String? about;
  final String? education;
  final String? availability;
  final String? recentProject;
  final String? workHistory;
  final String? availableDates;

  // معلومات إضافية من تفاصيل الطلب (متاحة لو احتجناها)
  final String? coverLetter;
  final String? proposedRate;
  final String? statusLabel;

  DetailsApplicationModel({
    this.about,
    this.education,
    this.availability,
    this.recentProject,
    this.workHistory,
    this.availableDates,
    this.coverLetter,
    this.proposedRate,
    this.statusLabel,
  });

  factory DetailsApplicationModel.fromJson(Map<String, dynamic> json) {
    final data = json['data'] is Map
        ? Map<String, dynamic>.from(json['data'])
        : json;

    final consultant = data['consultant'] is Map
        ? Map<String, dynamic>.from(data['consultant'])
        : <String, dynamic>{};
    final availability = data['availability'] is Map
        ? Map<String, dynamic>.from(data['availability'])
        : <String, dynamic>{};
    final interview = data['interview'] is Map
        ? Map<String, dynamic>.from(data['interview'])
        : <String, dynamic>{};

    final bio = (consultant['bio']?.toString().trim().isNotEmpty ?? false)
        ? consultant['bio'].toString()
        : null;
    final coverLetter = data['cover_letter']?.toString();

    return DetailsApplicationModel(
      about: bio ?? coverLetter,
      education: _joinList(data['education'], const ['title', 'degree', 'name', 'institution']),
      availability: _formatAvailability(availability),
      recentProject: _joinList(data['recent_projects'], const ['title', 'name', 'description']),
      workHistory: _joinList(data['work_history'], const ['title', 'role', 'company', 'name']),
      availableDates: _formatInterview(interview, availability),
      coverLetter: coverLetter,
      proposedRate: data['proposed_rate']?.toString(),
      statusLabel: data['status_label']?.toString(),
    );
  }

  static String _joinList(dynamic value, List<String> keys) {
    if (value is! List) return '';
    return value
        .map((e) {
          if (e is Map) {
            for (final k in keys) {
              if (e[k] != null && e[k].toString().trim().isNotEmpty) {
                return e[k].toString();
              }
            }
            return e.values.map((v) => v.toString()).join(' - ');
          }
          return e.toString();
        })
        .where((s) => s.trim().isNotEmpty)
        .join('\n');
  }

  static String _formatAvailability(Map<String, dynamic> a) {
    final parts = <String>[];
    if ((a['start_date']?.toString().trim().isNotEmpty ?? false)) {
      parts.add('Start date: ${a['start_date']}');
    }
    if (a['weekly_hours'] != null) {
      parts.add('Weekly availability: ${a['weekly_hours']} hours/week');
    }
    if ((a['timezone']?.toString().trim().isNotEmpty ?? false)) {
      parts.add('Time zone: ${a['timezone']}');
    }
    return parts.join('\n');
  }

  static String _formatInterview(
      Map<String, dynamic> interview, Map<String, dynamic> availability) {
    if (interview['scheduled_at']?.toString().trim().isNotEmpty ?? false) {
      final title = interview['title']?.toString();
      return [
        if (title != null && title.trim().isNotEmpty) title,
        interview['scheduled_at'].toString(),
      ].join(' — ');
    }
    // ما في مقابلة مجدولة: اعرض تاريخ التوفّر إن وُجد
    if (availability['start_date']?.toString().trim().isNotEmpty ?? false) {
      return 'Available from ${availability['start_date']}';
    }
    return '';
  }
}
