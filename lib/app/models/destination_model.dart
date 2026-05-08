class Destination {
  final String name;
  final String from;
  final String price;
  final String duration;
  final String emoji;
  const Destination({
    required this.name,
    required this.from,
    required this.price,
    required this.duration,
    required this.emoji,
  });

  factory Destination.fromJson(Map<String, dynamic> json) {
    String getName(dynamic val) {
      if (val is Map) return val['ville'] ?? val['nom'] ?? 'Inconnu';
      return val?.toString() ?? 'Inconnu';
    }

    return Destination(
      name: getName(json['arrivee']),
      from: getName(json['depart']),
      price: json['prix']?.toString() ?? '...',
      duration: 'Intercités',
      emoji: '📍',
    );
  }

}
