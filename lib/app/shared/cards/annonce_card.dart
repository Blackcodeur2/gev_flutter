import 'package:camer_trip/app/models/annonce_model.dart';
import 'package:flutter/material.dart';

class AnnonceCard extends StatelessWidget {
  final AnnonceModel annonce;
  const AnnonceCard({super.key, required this.annonce});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final cs = theme.colorScheme;
    final isDark = theme.brightness == Brightness.dark;

    return Container(
      margin: const EdgeInsets.only(bottom: 24),
      decoration: BoxDecoration(
        color: isDark ? cs.surfaceContainerHigh : Colors.white,
        borderRadius: BorderRadius.circular(24),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 15,
            offset: const Offset(0, 8),
          )
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // 🏷️ Header (Agence Info)
          Padding(
            padding: const EdgeInsets.all(16),
            child: Row(
              children: [
                CircleAvatar(
                  backgroundColor: annonce.agence.color.withOpacity(0.1),
                  radius: 20,
                  child: Icon(annonce.agence.icon, color: annonce.agence.color, size: 20),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        annonce.agence.name,
                        style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 15),
                      ),
                      Text(
                        _formatSimplifiedDate(annonce.date),
                        style: TextStyle(fontSize: 12, color: cs.onSurface.withOpacity(0.5)),
                      ),
                    ],
                  ),
                ),
                if (annonce.isPromo)
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                    decoration: BoxDecoration(
                      color: Colors.red.withOpacity(0.1),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: const Text(
                      'PROMO',
                      style: TextStyle(color: Colors.red, fontWeight: FontWeight.bold, fontSize: 10),
                    ),
                  ),
                IconButton(onPressed: () {}, icon: const Icon(Icons.more_vert_rounded, size: 20)),
              ],
            ),
          ),
          // 📝 Contenu Texte
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: Text(
              annonce.content,
              style: const TextStyle(fontSize: 14, height: 1.5),
            ),
          ),
          const SizedBox(height: 12),

          // 🖼️ Image (si présente)
          if (annonce.imageUrl != null)
            Padding(
              padding: const EdgeInsets.all(12),
              child: ClipRRect(
                borderRadius: BorderRadius.circular(16),
                child: Image.network(
                  annonce.imageUrl!,
                  height: 200,
                  width: double.infinity,
                  fit: BoxFit.cover,
                  errorBuilder: (_, __, ___) => Container(
                    height: 150,
                    color: cs.surfaceContainerLowest,
                    child: const Icon(Icons.image_not_supported),
                  ),
                ),
              ),
            ),

          // ⚡ Action & Likes
          Padding(
            padding: const EdgeInsets.fromLTRB(16, 4, 16, 16),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    _buildActionButton(Icons.favorite_border_rounded, '24', cs),
                    const SizedBox(width: 16),
                    _buildActionButton(Icons.map_outlined, 'Trajet', cs),
                  ],
                ),
                if (annonce.actionLabel != null)
                  ElevatedButton(
                    onPressed: () {},
                    style: ElevatedButton.styleFrom(
                      backgroundColor: annonce.agence.color,
                      foregroundColor: Colors.white,
                      minimumSize: Size.zero, // Important pour éviter l'infinite width
                      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                      elevation: 0,
                    ),
                    child: Text(
                      annonce.actionLabel!,
                      style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 12),
                    ),
                  ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildActionButton(IconData icon, String label, ColorScheme cs) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Icon(icon, size: 20, color: cs.onSurface.withOpacity(0.6)),
        const SizedBox(width: 4),
        Text(label, style: TextStyle(fontSize: 12, color: cs.onSurface.withOpacity(0.6))),
      ],
    );
  }

  String _formatSimplifiedDate(DateTime date) {
    final now = DateTime.now();
    final difference = now.difference(date);
    if (difference.inMinutes < 60) {
      return 'Il y a ${difference.inMinutes} min';
    } else if (difference.inHours < 24) {
      return 'Il y a ${difference.inHours}h';
    } else {
      return '${date.day}/${date.month}';
    }
  }
}
