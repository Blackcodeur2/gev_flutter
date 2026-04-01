class VoyageModel {
  final int? id;
  final String numVoyage;
  final int trajetId;
  final int busId;
  final DateTime dateDepart;
  final double prix;
  final int chauffeurId;
  final String statut;
  final int gareId;

  VoyageModel({required this.id, required this.numVoyage, required this.trajetId, required this.busId, required this.dateDepart, required this.prix, required this.chauffeurId, required this.statut, required this.gareId});

  factory VoyageModel.fromJson(Map<String, dynamic> json) {
    return VoyageModel(
      id: int.parse(json['id']), 
      numVoyage: json['nom_voyage'], 
      trajetId: int.parse(json['trajet_id']), 
      busId: int.parse(json['bus_id']), 
      dateDepart: DateTime.parse(json['date_depart'].toString()), 
      prix: double.parse(json['prix']), 
      chauffeurId: int.parse(json['chauffeur_id']), 
      statut: json['statut'], 
      gareId: int.parse(json['gare_id'])
    );
  }

  Map<String, dynamic> toJson() {
    return {

    };
  }
}