import 'package:camer_trip/app/models/voyage_model.dart';
import 'package:flutter/material.dart';

class Agence {
  final int id;
  final String name;
  final String? email;
  final String? telephone;
  final String? description;
  final String? logoUrl;
  final List<dynamic> stations;
  final List<VoyageModel> allVoyages;
  final Color color;
  final IconData icon;

  const Agence({
    required this.id,
    required this.name,
    this.email,
    this.telephone,
    this.description,
    this.logoUrl,
    this.stations = const [],
    this.allVoyages = const [],
    required this.color,
    required this.icon,
  });

  factory Agence.fromJson(Map<String, dynamic> json) {
    List<VoyageModel> voyages = [];
    List<dynamic> stationsJson = json['stations'] ?? [];
    
    for (var station in stationsJson) {
      if (station['voyages'] != null) {
        for (var v in station['voyages']) {
          // On injecte le nom de l'agence dans le voyage pour la cohérence
          v['nom_agence'] = json['nom'];
          voyages.add(VoyageModel.fromJson(v));
        }
      }
    }

    return Agence(
      id: json['id'] ?? 0,
      name: json['nom'] ?? 'Agence Partenaire',
      email: json['email'],
      telephone: json['telephone'],
      description: json['description'],
      logoUrl: json['logo_url'],
      stations: stationsJson,
      allVoyages: voyages,
      color: _getRandomColor(json['id'] ?? 0), 
      icon: Icons.directions_bus_filled_rounded,
    );
  }

  static Color _getRandomColor(int id) {
    final colors = [
      const Color(0xFF2E3192),
      const Color(0xFF1B1464),
      const Color(0xFF006837),
      const Color(0xFFC1272D),
      const Color(0xFF8B5CF6),
    ];
    return colors[id % colors.length];
  }
}