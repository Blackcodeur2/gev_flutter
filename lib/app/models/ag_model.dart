import 'package:flutter/material.dart';

class Agence {
  final String name;
  final String route;
  final String rating;
  final Color color;
  final IconData icon;
  const Agence({
    required this.name,
    required this.route,
    required this.rating,
    required this.color,
    required this.icon,
  });

  factory Agence.fromJson(Map<String, dynamic> json) {
    return Agence(
      name: json['nom'] ?? 'Agence Partenaire',
      route: 'Réseau National', 
      rating: '4.8',
      color: const Color(0xFF2E3192), 
      icon: Icons.directions_bus_filled_rounded,
    );
  }
}