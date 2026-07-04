class CitiesModel {
  final int id;
  final String name;


  CitiesModel({
    required this.id,
    required this.name,
  });

  factory CitiesModel.fromJson(Map<String, dynamic> json) {
    return CitiesModel(
      id: json['id'],
      name: json['name'],

    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,

    };
  }

  factory CitiesModel.fackCitiesModel() {
    return CitiesModel(
      id: 0,
      name: 'Cities',

    );
  }
}
