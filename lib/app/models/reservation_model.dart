class ReservationModel {
  final int? id;
  final String? numReservation;
  final int userId;
  final int stationId;
  final int voyageId;
  final String place;
  final double prix;
  
  // Extra UI fields
  final String? agenceName;
  final String? route;
  final String? date;
  final String? time;
  final String? status;
  final String? voyageStatus;

  ReservationModel({
    this.id,
    this.numReservation,
    required this.userId,
    required this.stationId,
    required this.voyageId,
    required this.place,
    required this.prix,
    this.agenceName,
    this.route,
    this.date,
    this.time,
    this.status,
    this.voyageStatus,
  });

  factory ReservationModel.fromJson(Map<String, dynamic> json) {
    final voyage = json['voyage'];
    final station = json['station'];
    final agence = station?['agence'] ?? voyage?['station']?['agence'];

    
    // Formatage de la date et de l'heure
    String dateStr = '...';
    String timeStr = '...';
    if (voyage != null) {
      if (voyage['date_depart'] != null) {
        DateTime dt = DateTime.parse(voyage['date_depart']);
        final months = ["Janvier", "Février", "Mars", "Avril", "Mai", "Juin", "Juillet", "Août", "Septembre", "Octobre", "Novembre", "Décembre"];
        dateStr = "${dt.day} ${months[dt.month - 1]} ${dt.year}";
      }
      if (voyage['heure_depart'] != null) {
        final rawTime = voyage['heure_depart'].toString();
        timeStr = rawTime.length >= 5 ? rawTime.substring(0, 5) : rawTime;
      }
    }

    final trajet = voyage?['trajet'];
    String villeDep = voyage?['ville_depart']?.toString() ?? '...';
    if (villeDep == '...') {
      final dep = trajet?['depart'];
      villeDep = (dep is Map) ? (dep['ville'] ?? dep['nom'] ?? '...') : dep?.toString() ?? '...';
    }

    String villeArr = voyage?['ville_arrivee']?.toString() ?? '...';
    if (villeArr == '...') {
      final arr = trajet?['arrivee'];
      villeArr = (arr is Map) ? (arr['ville'] ?? arr['nom'] ?? '...') : arr?.toString() ?? '...';
    }



    return ReservationModel(
      id: json['id'],
      numReservation: json['num_reservation'],
      userId: json['user_id'] ?? 0,
      stationId: json['station_id'] ?? 0,
      voyageId: json['voyage_id'] ?? 0,
      place: json['place']?.toString() ?? '',
      prix: double.tryParse(json['prix'].toString()) ?? 0.0,
      status: json['statut'] ?? 'en attente',
      voyageStatus: voyage?['statut'] ?? 'en attente',
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
      'station_id': stationId,
      'voyage_id': voyageId,
      'place': place,
      'prix': prix,
    };
  }
}