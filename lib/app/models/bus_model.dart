class BusModel {
  final int? id;
  final String immatriculation;
  final String codeBus;
  final int? nbPlaces;
  final String typeBus;
  final String classBus;
  final int stationId;
  final String statut;

  BusModel({
    required this.id,
    required this.immatriculation,
    required this.codeBus,
    required this.nbPlaces,
    required this.typeBus,
    required this.classBus,
    required this.stationId,
    required this.statut,
  });

  factory BusModel.fromJson(Map<String, dynamic> json) {
    return BusModel(
      id: int.parse(json['id'].toString()),
      immatriculation: json['immatriculation'],
      codeBus: json['code_bus'],
      nbPlaces: int.parse(json['nb_places'].toString()),
      typeBus: json['type_bus'],
      classBus: json['classe_bus'],
      stationId: int.parse(json['station_id'].toString()),
      statut: json['statut'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'immatriculation': immatriculation,
      'code_bus': codeBus,
      'nb_places': nbPlaces,
      'type_bus': typeBus,
      'classe_bus': classBus,
      'station_id': stationId,
      'statut': statut,
    };
  }
}
