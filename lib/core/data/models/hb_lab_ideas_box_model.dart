class HbLabIdeasBoxModel {
  final int? id;
  final String? title;
  final String? authorName;
  final String? submittedOnDisplay;
  final int? votesCount;
  final String? status;
  final String? statusLabel;
  final List<String>? tags;
  final bool userHasUpvoted;

  HbLabIdeasBoxModel({
    this.id,
    this.title,
    this.authorName,
    this.submittedOnDisplay,
    this.votesCount,
    this.status,
    this.statusLabel,
    this.tags,
    this.userHasUpvoted = false,
  });

  factory HbLabIdeasBoxModel.fromJson(Map<String, dynamic> json) {
    final rawTags = json['tags'] as List?;
    return HbLabIdeasBoxModel(
      id: json['id'] as int?,
      title: json['title'] as String?,
      authorName: json['author_name'] as String?,
      submittedOnDisplay: json['submitted_on_display'] as String?,
      votesCount: json['votes_count'] as int?,
      status: json['status'] as String?,
      statusLabel: json['status_label'] as String?,
      tags: rawTags?.map((t) => t.toString()).toList(),
      userHasUpvoted: json['user_has_upvoted'] as bool? ?? false,
    );
  }

  HbLabIdeasBoxModel copyWith({
    int? votesCount,
    bool? userHasUpvoted,
  }) {
    return HbLabIdeasBoxModel(
      id: id,
      title: title,
      authorName: authorName,
      submittedOnDisplay: submittedOnDisplay,
      votesCount: votesCount ?? this.votesCount,
      status: status,
      statusLabel: statusLabel,
      tags: tags,
      userHasUpvoted: userHasUpvoted ?? this.userHasUpvoted,
    );
  }

  factory HbLabIdeasBoxModel.fake() {
    return HbLabIdeasBoxModel(
      id: 1,
      title: 'Blockchain Payroll Tool',
      authorName: 'John Doe',
      submittedOnDisplay: '15 Sept 25',
      votesCount: 25,
      status: 'submitted',
      statusLabel: 'Under Review',
      tags: ['FinTech', 'Blockchain'],
      userHasUpvoted: false,
    );
  }
}

class HbLabIdeasPageResponse {
  final List<HbLabIdeasBoxModel> ideas;
  final int currentPage;
  final int lastPage;
  final int total;

  HbLabIdeasPageResponse({
    required this.ideas,
    required this.currentPage,
    required this.lastPage,
    required this.total,
  });
}
