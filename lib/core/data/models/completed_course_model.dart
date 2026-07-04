class CompletedCourseModel {
  final int id;
  final String title;

  CompletedCourseModel({this.id = 0, this.title = ''});

  factory CompletedCourseModel.fromJson(Map<String, dynamic> json) {
    return CompletedCourseModel(
      id: json['id'] ?? 0,
      title: json['title'] ?? '',
    );
  }
}
