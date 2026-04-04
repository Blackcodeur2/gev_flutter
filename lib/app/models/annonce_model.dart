import 'package:camer_trip/app/models/ag_model.dart';
import 'package:flutter/material.dart';

class AnnonceModel {
  final String id;
  final Agence agence;
  final String content;
  final String? imageUrl;
  final DateTime date;
  final int likes;
  final bool isPromo;
  final String? actionLabel;

  AnnonceModel({
    required this.id,
    required this.agence,
    required this.content,
    this.imageUrl,
    required this.date,
    this.likes = 0,
    this.isPromo = false,
    this.actionLabel,
  });
}

// 📌 Données simulées
final List<AnnonceModel> dummyAnnonces = [
  AnnonceModel(
    id: '1',
    agence: const Agence(
      name: 'Touristique Express',
      route: 'Yaoundé - Douala',
      rating: '4.8',
      color: Colors.green,
      icon: Icons.bus_alert,
    ),
    content: '🎉 Grande Promotion ! Voyagez de Yaoundé à Douala pour seulement 3500 FCFA durant tout le mois de Mars. Réservez dès maintenant pour en profiter !',
    imageUrl: 'https://images.unsplash.com/photo-1544620347-c4fd4a3d5957?w=800', // Image de bus HD
    date: DateTime.now().subtract(const Duration(hours: 2)),
    isPromo: true,
    actionLabel: 'Réserver Promo',
  ),
  AnnonceModel(
    id: '2',
    agence: const Agence(
      name: 'Finexs Voyages',
      route: 'Douala - Yaoundé',
      rating: '4.5',
      color: Colors.blue,
      icon: Icons.directions_bus,
    ),
    content: '📢 Information Importante : Nous avons ajouté 5 nouveaux bus VIP sur la ligne Douala - Yaoundé pour plus de confort et de ponctualité. Départ toutes les heures !',
    date: DateTime.now().subtract(const Duration(hours: 5)),
    actionLabel: 'Voir Horaires',
  ),
  AnnonceModel(
    id: '3',
    agence: const Agence(
      name: 'Buca Voyages',
      route: 'Douala - Kribi',
      rating: '4.2',
      color: Colors.red,
      icon: Icons.beach_access,
    ),
    content: '🌴 Nouveau Trajet : Nous desservons désormais la ville de Kribi ! Profitez de nos bus climatisés pour vos week-ends au bord de mer.',
    imageUrl: 'https://images.unsplash.com/photo-1590523278191-995ccd139e90?w=800', // Image de plage
    date: DateTime.now().subtract(const Duration(days: 1)),
    isPromo: false,
    actionLabel: 'Détails Trajet',
  ),
];
