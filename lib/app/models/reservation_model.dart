class ReservationModel {
  final String id;
  final String agenceName;
  final String route;
  final String date;
  final String status; // 'À venir', 'Passé', 'Annulé'
  final String price;
  final String seatNumber;
  final String qrCodeId;
  final String time;

  const ReservationModel({
    required this.id,
    required this.agenceName,
    required this.route,
    required this.date,
    required this.status,
    required this.price,
    required this.seatNumber,
    required this.qrCodeId,
    required this.time,
  });
}