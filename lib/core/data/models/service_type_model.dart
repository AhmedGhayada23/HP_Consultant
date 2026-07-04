class ServiceTypeModel {
  final int id;
  final String serviceType;

  ServiceTypeModel({this.id = 0, this.serviceType = ''});

  factory ServiceTypeModel.fromJson(Map<String, dynamic> json) {
    return ServiceTypeModel(
      id: json['id'] is int ? json['id'] : int.tryParse('${json['id']}') ?? 0,
      serviceType: json['service_type']?.toString() ?? '',
    );
  }
}
