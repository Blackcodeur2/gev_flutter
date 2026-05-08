class ColisModel {
  final int id;
  final int? userId;
  final int? stationId;
  final int? trajetId;
  final String nomColis;
  final String? description;
  final String nomExpediteur;
  final String telExpediteur;
  final String nomDestinataire;
  final String telDestinataire;
  final String destination;
  final double prix;
  final double poids;
  final String statut;
  final DateTime createdAt;

  // Relations
  final String? nomAgence;
  final String? villeSource;

  ColisModel({
    required this.id,
    this.userId,
    this.stationId,
    this.trajetId,
    required this.nomColis,
    this.description,
    required this.nomExpediteur,
    required this.telExpediteur,
    required this.nomDestinataire,
    required this.telDestinataire,
    required this.destination,
    required this.prix,
    required this.poids,
    required this.statut,
    required this.createdAt,
    this.nomAgence,
    this.villeSource,
  });

  factory ColisModel.fromJson(Map<String, dynamic> json) {
    final station = json['station'];
    final agence = station?['agence'];
    final trajet = json['trajet'];

    return ColisModel(
      id: json['id'],
      userId: json['user_id'],
      stationId: json['station_id'],
      trajetId: json['trajet_id'],
      nomColis: json['nom_colis'] ?? 'Colis sans nom',
      description: json['description'],
      nomExpediteur: json['nom_expediteur'] ?? 'Inconnu',
      telExpediteur: json['tel_expediteur'] ?? '',
      nomDestinataire: json['nom_destinataire'] ?? 'Inconnu',
      telDestinataire: json['tel_destinataire'] ?? '',
      destination: json['destination'] ?? '',
      prix: double.tryParse(json['prix']?.toString() ?? '0') ?? 0.0,
      poids: double.tryParse(json['poids']?.toString() ?? '0') ?? 0.0,
      statut: json['statut'] ?? 'en attente',
      createdAt: DateTime.parse(json['created_at']),
      nomAgence: agence?['nom'] ?? station?['nom'] ?? 'CamerTrip',
      villeSource: station?['ville'] ?? trajet?['depart'] ?? '...',
    );
  }
}
