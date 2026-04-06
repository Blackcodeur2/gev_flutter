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
    return ReservationModel(
      id: json['id'],
      numReservation: json['num_reservation'],
      userId: json['user_id'] ?? 0,
      gareId: json['gare_id'] ?? 0,
      voyageId: json['voyage_id'] ?? 0,
      place: json['place'] ?? '',
      prix: double.tryParse(json['prix'].toString()) ?? 0.0,
      status: json['status'] ?? 'À venir',
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