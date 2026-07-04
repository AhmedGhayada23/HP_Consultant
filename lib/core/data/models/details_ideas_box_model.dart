class DetailsIdeasBoxModel {
  final int? id;
  final String? title;
  final String? authorName;
  final String? submittedOnDisplay;
  final int? votesCount;
  final String? statusLabel;
  final List<String>? tags;
  final String? description;
  final String? confidentialityLevel;
  final bool? userHasUpvoted;
  final List<IdeaAttachment>? attachments;
  final List<IdeaComment>? comments;

  DetailsIdeasBoxModel({
    this.id,
    this.title,
    this.authorName,
    this.submittedOnDisplay,
    this.votesCount,
    this.statusLabel,
    this.tags,
    this.description,
    this.confidentialityLevel,
    this.userHasUpvoted,
    this.attachments,
    this.comments,
  });

  factory DetailsIdeasBoxModel.fromJson(Map<String, dynamic> json) {
    final data = json['data'] as Map<String, dynamic>? ?? json;
    return DetailsIdeasBoxModel(
      id: data['id'] as int?,
      title: data['title'] as String?,
      authorName: data['author_name'] as String?,
      submittedOnDisplay: data['submitted_on_display'] as String?,
      votesCount: data['votes_count'] as int?,
      statusLabel: data['status_label'] as String?,
      tags: (data['tags'] as List?)?.map((t) => t.toString()).toList(),
      description: data['description'] as String?,
      confidentialityLevel: data['confidentiality_level'] as String?,
      userHasUpvoted: data['user_has_upvoted'] as bool?,
      attachments: (data['attachments'] as List?)
          ?.map((e) => IdeaAttachment.fromJson(e as Map<String, dynamic>))
          .toList(),
      comments: (data['comments'] as List?)
          ?.map((e) => IdeaComment.fromJson(e as Map<String, dynamic>))
          .toList(),
    );
  }

  factory DetailsIdeasBoxModel.fake() {
    return DetailsIdeasBoxModel(
      id: 1,
      title: 'Blockchain Payroll Tool',
      authorName: 'John Doe',
      submittedOnDisplay: '15 Sept 2025',
      votesCount: 25,
      statusLabel: 'Under Review',
      tags: ['FinTech', 'Blockchain'],
      description:
          'This idea proposes building a payroll system powered by blockchain for secure, transparent salary processing across multiple countries.',
      confidentialityLevel: 'public',
      userHasUpvoted: false,
      attachments: [IdeaAttachment.fake()],
      comments: [IdeaComment.fake(), IdeaComment.fake(), IdeaComment.fake()],
    );
  }
}

class IdeaAttachment {
  final int? id;
  final String? fileName;
  final String? typeLabel;
  final String? url;

  IdeaAttachment({this.id, this.fileName, this.typeLabel, this.url});

  factory IdeaAttachment.fromJson(Map<String, dynamic> json) {
    return IdeaAttachment(
      id: json['id'] as int?,
      fileName: json['file_name'] as String?,
      typeLabel: json['type_label'] as String?,
      url: json['url'] as String?,
    );
  }

  factory IdeaAttachment.fake() {
    return IdeaAttachment(
      id: 1,
      fileName: 'ERP_Project_Plan.pdf',
      typeLabel: 'PDF File',
      url: '',
    );
  }
}

class IdeaComment {
  final int? id;
  final String? authorName;
  final String? createdAt;
  final String? body;

  IdeaComment({this.id, this.authorName, this.createdAt, this.body});

  factory IdeaComment.fromJson(Map<String, dynamic> json) {
    return IdeaComment(
      id: json['id'] as int?,
      authorName: json['author_name'] as String?,
      createdAt: json['created_at'] as String?,
      body: json['body'] as String?,
    );
  }

  factory IdeaComment.fake() {
    return IdeaComment(
      id: 1,
      authorName: 'Sarah Ali',
      createdAt: '22-10-2025',
      body: 'This would help HR compliance a lot. Maybe add smart contracts for taxes.',
    );
  }
}
