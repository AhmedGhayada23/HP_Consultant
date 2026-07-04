class AssignConsultantModel {
  final int consultantId;
  final int? milestoneId; // اختياري
  final String role;
  final String notes;

  AssignConsultantModel({
    required this.consultantId,
    this.milestoneId,
    required this.role,
    required this.notes,
  });

  Map<String, dynamic> toJson() {
    return {
      "consultant_id": consultantId,
      // إرسال المرحلة فقط عند اختيارها
      if (milestoneId != null) "milestone_id": milestoneId,
      "role": role,
      "notes": notes,
    };
  }
}
