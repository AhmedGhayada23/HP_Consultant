class ConsultantDashboardStats {
  final int activeProjectsCount;
  final int pendingApplicationsCount;
  final String monthlyEarningsFormatted;
  final int ideasSubmittedCount;

  ConsultantDashboardStats({
    required this.activeProjectsCount,
    required this.pendingApplicationsCount,
    required this.monthlyEarningsFormatted,
    required this.ideasSubmittedCount,
  });

  factory ConsultantDashboardStats.fromJson(Map<String, dynamic> json) {
    final earnings = json['monthly_earnings'] is Map
        ? Map<String, dynamic>.from(json['monthly_earnings'])
        : <String, dynamic>{};
    return ConsultantDashboardStats(
      activeProjectsCount: json['active_projects_count'] ?? 0,
      pendingApplicationsCount: json['pending_applications_count'] ?? 0,
      monthlyEarningsFormatted: earnings['formatted'] as String? ?? '€0',
      ideasSubmittedCount: json['ideas_submitted_count'] ?? 0,
    );
  }

  factory ConsultantDashboardStats.fake() => ConsultantDashboardStats(
        activeProjectsCount: 3,
        pendingApplicationsCount: 5,
        monthlyEarningsFormatted: '€2,000',
        ideasSubmittedCount: 2,
      );
}

class DashboardRecommendedJob {
  final int id;
  final String title;
  final String descriptionExcerpt;
  final String jobTypeLabel;
  final String? category;
  final String? companyName;
  final String budgetDisplay;
  final String deadlineDisplay;
  final String statusLabel;
  final List<String> skills;

  DashboardRecommendedJob({
    required this.id,
    required this.title,
    required this.descriptionExcerpt,
    required this.jobTypeLabel,
    this.category,
    this.companyName,
    required this.budgetDisplay,
    required this.deadlineDisplay,
    required this.statusLabel,
    this.skills = const [],
  });

  factory DashboardRecommendedJob.fromJson(Map<String, dynamic> json) {
    final company = json['company'] is Map
        ? Map<String, dynamic>.from(json['company'])
        : null;
    final categoryJson = json['category'];
    return DashboardRecommendedJob(
      id: json['id'] ?? 0,
      title: json['title'] ?? '',
      descriptionExcerpt: json['description_excerpt'] ?? '',
      jobTypeLabel: json['job_type_label'] ?? '',
      category: categoryJson is Map ? categoryJson['name'] as String? : categoryJson as String?,
      companyName: company?['name'] as String?,
      budgetDisplay: json['budget_display'] ?? '',
      deadlineDisplay: json['deadline_display'] ?? '',
      statusLabel: json['status_label'] ?? '',
      skills: (json['skills'] as List? ?? [])
          .map((e) => e.toString())
          .toList(),
    );
  }

  factory DashboardRecommendedJob.fake() => DashboardRecommendedJob(
        id: 0,
        title: 'UI/UX Designer',
        descriptionExcerpt: 'Looking for a skilled designer...',
        jobTypeLabel: 'Contract',
        category: 'Design',
        companyName: 'Acme Corp',
        budgetDisplay: '€1,000 - €5,000',
        deadlineDisplay: '31 May 2026',
        statusLabel: 'Open',
        skills: const ['Figma', 'UX'],
      );
}

class DashboardActiveProject {
  final int id;
  final String title;
  final String? requestReference;
  final String? category;
  final String? budgetDisplay;
  final String? deadlineDisplay;
  final String? statusLabel;
  final String? nextMilestoneTitle;
  final String? nextMilestoneDueDisplay;
  final int completedMilestones;
  final int totalMilestones;

  DashboardActiveProject({
    required this.id,
    required this.title,
    this.requestReference,
    this.category,
    this.budgetDisplay,
    this.deadlineDisplay,
    this.statusLabel,
    this.nextMilestoneTitle,
    this.nextMilestoneDueDisplay,
    this.completedMilestones = 0,
    this.totalMilestones = 0,
  });

  // نسبة تقدّم المعالم (0.0 → 1.0)
  double get progress =>
      totalMilestones == 0 ? 0 : completedMilestones / totalMilestones;

  static const _months = [
    'Jan', 'Feb', 'Mar', 'Apr', 'May', 'Jun',
    'Jul', 'Aug', 'Sep', 'Oct', 'Nov', 'Dec',
  ];

  // "2026-06-20" → "20 Jun 2026"
  static String? _formatDate(String? raw) {
    if (raw == null || raw.isEmpty) return null;
    try {
      final dt = DateTime.parse(raw);
      return '${dt.day.toString().padLeft(2, '0')} ${_months[dt.month - 1]} ${dt.year}';
    } catch (_) {
      return raw;
    }
  }

  factory DashboardActiveProject.fromJson(Map<String, dynamic> json) {
    final nextMilestone = json['next_milestone'] is Map
        ? Map<String, dynamic>.from(json['next_milestone'])
        : null;
    final milestones = (json['milestones'] as List? ?? []).whereType<Map>();
    final completed = milestones
        .where((m) => (m['status']?.toString() ?? '') == 'completed')
        .length;
    return DashboardActiveProject(
      id: json['id'] ?? 0,
      title: json['title'] ?? '',
      requestReference: json['request_reference'] as String?,
      category: json['category'] as String?,
      budgetDisplay: json['budget_display'] as String?,
      deadlineDisplay: json['deadline_display'] as String?,
      statusLabel: json['status_label'] as String?,
      nextMilestoneTitle: nextMilestone?['title'] as String?,
      nextMilestoneDueDisplay: _formatDate(nextMilestone?['due_date'] as String?),
      completedMilestones: completed,
      totalMilestones: milestones.length,
    );
  }

  factory DashboardActiveProject.fake() => DashboardActiveProject(
        id: 0,
        title: 'Mobile App Development',
        requestReference: 'SR-2026-000',
        category: 'Development',
        budgetDisplay: '€5,000',
        deadlineDisplay: '30 Jun 2026',
        statusLabel: 'In Progress',
        nextMilestoneTitle: 'Backend Setup',
        nextMilestoneDueDisplay: '20 Jun 2026',
        completedMilestones: 1,
        totalMilestones: 4,
      );
}

class ConsultantDashboardModel {
  final ConsultantDashboardStats stats;
  final List<DashboardRecommendedJob> recommendedJobs;
  final List<DashboardActiveProject> activeProjects;

  ConsultantDashboardModel({
    required this.stats,
    required this.recommendedJobs,
    required this.activeProjects,
  });

  factory ConsultantDashboardModel.fromJson(Map<String, dynamic> json) {
    // الداتا قد تكون ملفوفة داخل "data" أو تأتي مباشرة
    final data = json['data'] is Map
        ? Map<String, dynamic>.from(json['data'])
        : json;
    return ConsultantDashboardModel(
      stats: ConsultantDashboardStats.fromJson(
        data['stats'] is Map
            ? Map<String, dynamic>.from(data['stats'])
            : <String, dynamic>{},
      ),
      recommendedJobs: (data['recommended_jobs'] as List? ?? [])
          .whereType<Map>()
          .map((e) => DashboardRecommendedJob.fromJson(
              Map<String, dynamic>.from(e)))
          .toList(),
      activeProjects: (data['active_projects'] as List? ?? [])
          .whereType<Map>()
          .map((e) => DashboardActiveProject.fromJson(
              Map<String, dynamic>.from(e)))
          .toList(),
    );
  }
}
