import 'package:camer_trip/app/models/ag_model.dart';
import 'package:camer_trip/app/services/api_client_service.dart';
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

  factory AnnonceModel.fromJson(Map<String, dynamic> json) {
    Map<String, dynamic>? stationJson = json['station'];
    Map<String, dynamic>? agenceJson = stationJson != null ? stationJson['agence'] : null;
    
    Agence agence = agenceJson != null 
        ? Agence.fromJson(agenceJson) 
        : const Agence(id: 0, name: 'Agence', color: Colors.blue, icon: Icons.campaign);

    return AnnonceModel(
      id: json['id']?.toString() ?? '',
      agence: agence,
      content: json['contenu_text'] ?? '',
      imageUrl: _resolveImageUrl(json['image_url']),
      date: json['created_at'] != null ? DateTime.parse(json['created_at']) : DateTime.now(),
      likes: json['likes'] ?? 0,
      isPromo: json['is_promo'] == true || json['is_promo'] == 1,
      actionLabel: json['is_promo'] == true || json['is_promo'] == 1 ? 'Réserver Promo' : null,
    );
  }

  static String? _resolveImageUrl(dynamic raw) {
    if (raw == null) return null;
    final url = raw.toString().trim();
    if (url.isEmpty) return null;

    if (url.startsWith('http')) {
      if (url.contains('localhost')) {
        final serverIp = Uri.parse(ApiClient().baseUrl).host;
        return url.replaceAll('localhost', serverIp);
      }
      return url;
    }

    final base = ApiClient().baseUrl.replaceAll('/api', '');
    final path = url.replaceAll('\\', '/').replaceFirst(RegExp(r'^storage/'), '');
    return '$base/storage/$path';
  }
}

// 📌 Données simulées
final List<AnnonceModel> dummyAnnonces = [
  AnnonceModel(
    id: '1',
    agence: const Agence(
      id: 1,
      name: 'Touristique Express',
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
      id: 2,
      name: 'Finexs Voyages',
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
      id: 3,
      name: 'Buca Voyages',
      color: Colors.red,
      icon: Icons.beach_access,
    ),

    content: '🌴 Nouveau Trajet : Nous desservons désormais la ville de Kribi ! Profitez de nos bus climatisés pour vos week-ends au bord de mer.',
    imageUrl: 'https://images.unsplash.com/photo-1544620347-c4fd4a3d5957?w=800', // Image de plage
    date: DateTime.now().subtract(const Duration(days: 1)),
    isPromo: false,
    actionLabel: 'Détails Trajet',
  ),
];
