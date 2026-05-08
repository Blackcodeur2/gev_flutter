class VoyageModel {
  final int? id;
  final String numVoyage;
  final int stationId;
  final int trajetId;
  final int busId;
  final int? chauffeurId;
  final String dateDepart;
  final String heureDepart;
  final double prix;
  final double promo;
  final String statut;
  
  // Extra fields for UI (calculated or from relations)
  final String? nomAgence;
  final String? villeSource;
  final String? villeDestination;
  final int? nbPlaces;
  final int? reservationsCount;

  VoyageModel({
    required this.id, 
    required this.numVoyage, 
    required this.stationId,
    required this.trajetId, 
    required this.busId, 
    this.chauffeurId,
    required this.dateDepart, 
    required this.heureDepart,
    required this.prix, 
    this.promo = 0,
    required this.statut, 
    this.nbPlaces,
    this.nomAgence,
    this.villeSource,
    this.villeDestination,
    this.reservationsCount,
  });

  factory VoyageModel.fromJson(Map<String, dynamic> json) {
    // Relations handles
    final trajet = json['trajet'];
    final bus = json['bus'];
    final station = json['station'];
    final agence = station?['agence'];

    return VoyageModel(
      id: json['id'] != null ? int.parse(json['id'].toString()) : null, 
      numVoyage: json['num_voyage'] ?? '', 
      stationId: json['station_id'] != null ? int.parse(json['station_id'].toString()) : 0,
      trajetId: json['trajet_id'] != null ? int.parse(json['trajet_id'].toString()) : 0, 
      busId: json['bus_id'] != null ? int.parse(json['bus_id'].toString()) : 0, 
      chauffeurId: json['chauffeur_id'] != null ? int.parse(json['chauffeur_id'].toString()) : null,
      dateDepart: json['date_depart']?.toString() ?? '', 
      heureDepart: json['heure_depart']?.toString() ?? '',
      prix: double.tryParse(json['prix'].toString()) ?? 0.0, 
      promo: double.tryParse(json['promo'].toString()) ?? 0.0,
      statut: json['statut'] ?? 'en attente', 
      nbPlaces: bus?['nb_places'] != null ? int.parse(bus['nb_places'].toString()) : null,
      nomAgence: agence?['nom'] ?? json['nom_agence'],
      villeSource: trajet?['depart'] ?? json['ville_source'],
      villeDestination: trajet?['arrivee'] ?? json['ville_destination'],
      reservationsCount: json['reservations_count'] != null ? int.parse(json['reservations_count'].toString()) : null,
    );
  }

  // Combiner date et heure pour le parsing DateTime si nécessaire
  DateTime get fullDepartureDate => DateTime.parse("$dateDepart $heureDepart");

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'num_voyage': numVoyage,
      'station_id': stationId,
      'trajet_id': trajetId,
      'bus_id': busId,
      'chauffeur_id': chauffeurId,
      'date_depart': dateDepart,
      'heure_depart': heureDepart,
      'prix': prix,
      'promo': promo,
      'statut': statut,
    };
  }
}