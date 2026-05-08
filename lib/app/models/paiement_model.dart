class PaiementModel {
  final int? id;
  final String? reference;
  final int reservationId;
  final double montant;
  final int station_id;

  PaiementModel({
    this.id,
    this.reference,
    required this.reservationId,
    required this.montant,
    required this.station_id,
  });

  factory PaiementModel.fromJson(Map<String, dynamic> json) {
    return PaiementModel(
      id: json['id'],
      reference: json['reference'],
      reservationId: json['reservation_id'] ?? 0,
      montant: double.tryParse(json['montant'].toString()) ?? 0.0,
      station_id: json['station_id'] ?? 0,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'reference': reference,
      'reservation_id': reservationId,
      'montant': montant,
      'station_id': station_id,
    };
  }
}