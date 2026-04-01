class BusModel {
  final int? id;
  final String immatriculation;
  final String codeBus;
  final int? nbPlaces;
  final String typeBus;
  final String classBus;
  final int gareId;
  final String statut;

  BusModel({required this.id,required this.immatriculation,required this.codeBus, required this.nbPlaces, required this.typeBus, required this.classBus, required this.gareId, required this.statut});

  factory BusModel.fromJson(Map<String, dynamic> json) {
    return BusModel(
      id: int.parse(json['id']), 
      immatriculation: json['immatriculation'], 
      codeBus: json['code_bus'], 
      nbPlaces: int.parse(json['nb_places']), 
      typeBus: json['type_bus'], 
      classBus: json['classe_bus'], 
      gareId: int.parse(json['gare_id']), 
      statut: json['statut']
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id' : id,
      'immatriculation' : immatriculation,
      'code_bus' : codeBus,
      'nb_places' : nbPlaces,
      'type_bus' : typeBus,
      'classe_bus' : classBus,
      'gare_id' : gareId,
      'statut' : statut
    };
  }
}