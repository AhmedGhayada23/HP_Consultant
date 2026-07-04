class CourseEnrollResult {
  final int orderId;
  final int courseId;
  final num amount;
  final String currency;
  final String? paymentUrl;
  final bool paymentRequired;
  final String message;

  CourseEnrollResult({
    this.orderId = 0,
    this.courseId = 0,
    this.amount = 0,
    this.currency = '',
    this.paymentUrl,
    this.paymentRequired = false,
    this.message = '',
  });

  factory CourseEnrollResult.fromResponse(Map<String, dynamic> json) {
    final data = json['data'] is Map
        ? Map<String, dynamic>.from(json['data'])
        : <String, dynamic>{};
    return CourseEnrollResult(
      orderId: data['order_id'] ?? 0,
      courseId: data['course_id'] ?? 0,
      amount: data['amount'] ?? 0,
      currency: data['currency']?.toString() ?? '',
      paymentUrl: data['payment_url']?.toString(),
      paymentRequired: data['payment_required'] ?? false,
      message: json['message']?.toString() ?? '',
    );
  }
}
