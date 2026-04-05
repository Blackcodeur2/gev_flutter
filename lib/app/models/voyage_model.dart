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
  
  // Extra fields for UI and filtering
  final String? nomAgence;
  final String? villeSource;
  final String? villeDestination;

  VoyageModel({
    required this.id, 
    required this.numVoyage, 
    required this.trajetId, 
    required this.busId, 
    required this.dateDepart, 
    required this.prix, 
    required this.chauffeurId, 
    required this.statut, 
    required this.gareId,
    this.nomAgence,
    this.villeSource,
    this.villeDestination,
  });

  factory VoyageModel.fromJson(Map<String, dynamic> json) {
    return VoyageModel(
      id: json['id'] != null ? int.parse(json['id'].toString()) : null, 
      numVoyage: json['nom_voyage'] ?? json['num_voyage'] ?? '', 
      trajetId: json['trajet_id'] != null ? int.parse(json['trajet_id'].toString()) : 0, 
      busId: json['bus_id'] != null ? int.parse(json['bus_id'].toString()) : 0, 
      dateDepart: DateTime.parse(json['date_depart'].toString()), 
      prix: double.parse(json['prix'].toString()), 
      chauffeurId: json['chauffeur_id'] != null ? int.parse(json['chauffeur_id'].toString()) : 0, 
      statut: json['statut'] ?? '', 
      gareId: json['gare_id'] != null ? int.parse(json['gare_id'].toString()) : 0,
      nomAgence: json['nom_agence'],
      villeSource: json['ville_source'],
      villeDestination: json['ville_destination'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'nom_voyage': numVoyage,
      'trajet_id': trajetId,
      'bus_id': busId,
      'date_depart': dateDepart.toIso8601String(),
      'prix': prix,
      'chauffeur_id': chauffeurId,
      'statut': statut,
      'gare_id': gareId,
      'nom_agence': nomAgence,
      'ville_source': villeSource,
      'ville_destination': villeDestination,
    };
  }
}