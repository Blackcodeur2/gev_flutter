import 'package:flutter/material.dart';

class PromoTrip {
  final String title;
  final String subtitle;
  final String badge;
  final List<Color> colors;
  const PromoTrip({
    required this.title,
    required this.subtitle,
    required this.badge,
    required this.colors,
  });

  factory PromoTrip.fromJson(Map<String, dynamic> json) {
    final depart = json['trajet']?['depart']?['ville'] ?? json['trajet']?['depart']?['nom'] ?? 'Ville';
    final arrivee = json['trajet']?['arrivee']?['ville'] ?? json['trajet']?['arrivee']?['nom'] ?? 'Ville';
    final price = json['trajet']?['prix'] ?? 0;
    
    return PromoTrip(
      title: '$depart → $arrivee',
      subtitle: 'Dès $price FCFA',
      badge: '🔥 Promo Flash',
      colors: const [Color(0xFF2E3192), Color(0xFF4C51BF)],
    );
  }
}