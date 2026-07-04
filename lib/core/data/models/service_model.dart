class ServiceModel {
  final int id;
  final String name;
  final String description;
  final String type;
  final String serviceType;
  final String price;

  ServiceModel({
    this.id = 0,
    this.name = '',
    this.description = '',
    this.type = '',
    this.serviceType = '',
    this.price = '',
  });

  factory ServiceModel.fromJson(Map<String, dynamic> json) {
    return ServiceModel(
      id: json['id'] is int ? json['id'] : int.tryParse('${json['id']}') ?? 0,
      name: json['name']?.toString() ?? '',
      description: json['description']?.toString() ?? '',
      type: json['type']?.toString() ?? '',
      serviceType: json['service_type']?.toString() ?? '',
      price: json['price']?.toString() ?? '',
    );
  }
}
