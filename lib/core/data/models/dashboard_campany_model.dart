class DashboardCampanyModel {
  final KeyMetrics keyMetrics;
  final List<RecentInvoices> recentInvoices;
  final List<LatestProjects> latestProjects;

  DashboardCampanyModel({
    required this.keyMetrics,
    required this.recentInvoices,
    required this.latestProjects,
  });

  factory DashboardCampanyModel.fromJson(Map<String, dynamic> json) {
    return DashboardCampanyModel(
      keyMetrics: KeyMetrics.fromJson(
        json['key_metrics'] != null
            ? Map<String, dynamic>.from(json['key_metrics'])
            : const {},
      ),
      recentInvoices: (json['recent_invoices'] as List? ?? [])
          .map((e) => RecentInvoices.fromJson(Map<String, dynamic>.from(e)))
          .toList(),
      latestProjects: (json['latest_projects'] as List? ?? [])
          .map((e) => LatestProjects.fromJson(Map<String, dynamic>.from(e)))
          .toList(),
    );
  }

  factory DashboardCampanyModel.fack() {
    return DashboardCampanyModel(
      keyMetrics: KeyMetrics.fack(),
      latestProjects: [],
      recentInvoices: []
    );
  }
}

class KeyMetrics {
  final int activeProjects;
  final int activeConsultants;
  final int pendingApplications;
  final int upcomingDeadlines;

  KeyMetrics({
    required this.activeProjects,
    required this.activeConsultants,
    required this.pendingApplications,
    required this.upcomingDeadlines,
  });

  factory KeyMetrics.fromJson(Map<String, dynamic> json) {
    return KeyMetrics(
      activeProjects: json['active_projects'] ?? 0,
    activeConsultants: json['active_consultants'] ?? 0,
    pendingApplications: json['pending_applications'] ?? 0,
    upcomingDeadlines: json['upcoming_deadlines'] ?? 0,
    );
  }

  factory KeyMetrics.fack() {
    return KeyMetrics(
      activeConsultants: 0,
      activeProjects: 0,
      pendingApplications: 0,
      upcomingDeadlines: 0,
    );
  }
}

class RecentInvoices {
  final int id;
  final String invoiceNumber;
  final String title;
  final String date;
  final String amount;
  final String status;
  final String statusLabel;
  final String statusColor;

  RecentInvoices({
    required this.id,
    required this.invoiceNumber,
    required this.title,
    required this.date,
    required this.amount,
    required this.status,
    required this.statusLabel,
    required this.statusColor,
  });

  factory RecentInvoices.fromJson(Map<String, dynamic> json) {
    return RecentInvoices(
      id: json['id'] ?? 0,
      invoiceNumber: json['invoice_number'] ?? '',
      title: json['title'] ?? '',
      date: json['date_display'] ?? json['date'] ?? '',
      amount: json['amount_display'] ?? json['amount']?.toString() ?? '',
      status: json['status'] ?? '',
      statusLabel: json['status_label'] ?? '',
      statusColor: json['status_color'] ?? 'gray',
    );
  }
  factory RecentInvoices.fack() {
    return RecentInvoices(
      id: 0,
      invoiceNumber: 'INV-0000',
      title: 'title',
      date: '26 May 2026',
      amount: '\$0.00',
      status: 'paid',
      statusLabel: 'Paid',
      statusColor: 'green',
    );
  }
}

class LatestProjects {
  final int id;
  final String title;
  final String date;
  final String assignedPerson;
  final String statusLabel;
  final String statusColor;

  LatestProjects({
    this.id = 0,
    required this.title,
    required this.date,
    required this.assignedPerson,
    required this.statusLabel,
    required this.statusColor,
  });

  factory LatestProjects.fromJson(Map<String, dynamic> json) {
    return LatestProjects(
      id: json['id'] ?? 0,
      title: json['title'] ?? '',
      date: json['date'] ?? '',
      assignedPerson: json['assigned_person'] ?? '',
      statusLabel: json['status_label'] ?? json['status'] ?? '',
      statusColor: json['status_color'] ?? 'gray',
    );
  }

  factory LatestProjects.fack() {
    return LatestProjects(
      title: 'Project Title',
      date: '26 - 01 - 2026',
      assignedPerson: 'Unassigned',
      statusLabel: 'Planning',
      statusColor: 'purple',
    );
  }
}
