class ReservationModel {
  final int? id;
  final String? numReservation;
  final int userId;
  final int gareId;
  final int voyageId;
  final String place;
  final double prix;
  
  // Extra UI fields
  final String? agenceName;
  final String? route;
  final String? date;
  final String? time;
  final String? status;

  ReservationModel({
    this.id,
    this.numReservation,
    required this.userId,
    required this.gareId,
    required this.voyageId,
    required this.place,
    required this.prix,
    this.agenceName,
    this.route,
    this.date,
    this.time,
    this.status,
  });

  factory ReservationModel.fromJson(Map<String, dynamic> json) {
    final voyage = json['voyage'];
    final station = json['station'];
    final agence = station?['agence'] ?? voyage?['station']?['agence'];

    
    // Formatage de la date (ex: 2026-04-08 14:30:00)
    String dateStr = '...';
    String timeStr = '...';
    if (voyage != null && voyage['date_depart'] != null) {
      DateTime dt = DateTime.parse(voyage['date_depart']);
      final months = ["Janvier", "Février", "Mars", "Avril", "Mai", "Juin", "Juillet", "Août", "Septembre", "Octobre", "Novembre", "Décembre"];
      dateStr = "${dt.day} ${months[dt.month - 1]} ${dt.year}";
      timeStr = "${dt.hour.toString().padLeft(2, '0')}:${dt.minute.toString().padLeft(2, '0')}";
    }

    String villeDep = voyage?['trajet']?['depart']?['ville'] ?? voyage?['trajet']?['depart']?['nom'] ?? '...';
    String villeArr = voyage?['trajet']?['arrivee']?['ville'] ?? voyage?['trajet']?['arrivee']?['nom'] ?? '...';

    return ReservationModel(
      id: json['id'],
      numReservation: json['num_reservation'],
      userId: json['user_id'] ?? 0,
      gareId: json['gare_id'] ?? 0,
      voyageId: json['voyage_id'] ?? 0,
      place: json['place']?.toString() ?? '',
      prix: double.tryParse(json['prix'].toString()) ?? 0.0,
      status: json['statut'] ?? 'en attente',
      agenceName: agence?['nom'] ?? 'CamerTrip',
      route: '$villeDep ↔ $villeArr',
      date: dateStr,
      time: timeStr,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'num_reservation': numReservation,
      'user_id': userId,
      'gare_id': gareId,
      'voyage_id': voyageId,
      'place': place,
      'prix': prix,
    };
  }
}