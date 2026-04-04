import 'package:flutter/material.dart';
import 'package:qr_flutter/qr_flutter.dart';
import 'package:camer_trip/app/models/reservation_model.dart';

class DashedLinePainter extends CustomPainter {
  final Color color;
  DashedLinePainter({required this.color});

  @override
  void paint(Canvas canvas, Size size) {
    double dashWidth = 6, dashSpace = 4, startX = 0;
    final paint = Paint()
      ..color = color
      ..strokeWidth = 1.5;
    while (startX < size.width) {
      canvas.drawLine(Offset(startX, 0), Offset(startX + dashWidth, 0), paint);
      startX += dashWidth + dashSpace;
    }
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) => false;
}

class ReservationDetailsPage extends StatelessWidget {
  final ReservationModel reservation;

  const ReservationDetailsPage({super.key, required this.reservation});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final cs = theme.colorScheme;
    final isDark = theme.brightness == Brightness.dark;
    final isUpcoming = reservation.status == 'À venir';

    return Scaffold(
      appBar: AppBar(
        title: const Text('Billet Virtuel', style: TextStyle(fontWeight: FontWeight.bold)),
        centerTitle: true,
        backgroundColor: Colors.transparent,
        elevation: 0,
      ),
      extendBodyBehindAppBar: true,
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: isDark 
                ? [cs.surface, cs.surfaceContainerHighest] 
                : [cs.primary.withOpacity(0.05), Colors.white],
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
          ),
        ),
        child: SafeArea(
          child: SingleChildScrollView(
            padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 16.0),
            child: Column(
              children: [
                // Ticket Container
                Container(
                  decoration: BoxDecoration(
                    color: isDark ? cs.surfaceContainerHigh : Colors.white,
                    borderRadius: BorderRadius.circular(24),
                    boxShadow: [
                      BoxShadow(
                        color: isDark ? Colors.black54 : cs.shadow.withOpacity(0.1),
                        blurRadius: 20,
                        offset: const Offset(0, 10),
                      )
                    ],
                  ),
                  child: Column(
                    children: [
                      // En Tête Billet
                      Container(
                        padding: const EdgeInsets.all(24),
                        decoration: BoxDecoration(
                          color: cs.primary,
                          borderRadius: const BorderRadius.only(
                            topLeft: Radius.circular(24),
                            topRight: Radius.circular(24),
                          ),
                        ),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              reservation.agenceName,
                              style: const TextStyle(
                                color: Colors.white,
                                fontWeight: FontWeight.w900,
                                fontSize: 20,
                              ),
                            ),
                            Container(
                              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                              decoration: BoxDecoration(
                                color: Colors.white24,
                                borderRadius: BorderRadius.circular(12),
                              ),
                              child: Text(
                                reservation.status,
                                style: const TextStyle(
                                  color: Colors.white,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                      
                      // Détails du Billet
                      Padding(
                        padding: const EdgeInsets.all(24.0),
                        child: Column(
                          children: [
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                _buildCityTime(reservation.route.split(' ↔ ').first, theme, cs),
                                Icon(Icons.arrow_forward_rounded, color: cs.primary.withOpacity(0.5), size: 30),
                                _buildCityTime(reservation.route.split(' ↔ ').last, theme, cs, isEnd: true),
                              ],
                            ),
                            const SizedBox(height: 30),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                _buildInfoBlock('Date', reservation.date, theme),
                                _buildInfoBlock('Heure', reservation.time, theme),
                                _buildInfoBlock('Siège', reservation.seatNumber, theme, highlight: true),
                              ],
                            ),
                            const SizedBox(height: 24),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                _buildInfoBlock('Passager', 'Client (Moi)', theme),
                                _buildInfoBlock('Prix payé', reservation.price, theme, highlight: true),
                              ],
                            ),
                          ],
                        ),
                      ),

                      // Ligne de perforation
                      Stack(
                        children: [
                          SizedBox(
                            height: 40,
                            child: Center(
                              child: CustomPaint(
                                size: const Size(double.infinity, 1),
                                painter: DashedLinePainter(
                                  color: isDark ? Colors.white30 : Colors.black26,
                                ),
                              ),
                            ),
                          ),
                          Positioned(
                            left: -20,
                            top: 0,
                            bottom: 0,
                            child: Container(
                              width: 40,
                              decoration: BoxDecoration(
                                color: isDark ? cs.surfaceContainerHighest : cs.surface,
                                shape: BoxShape.circle,
                              ),
                            ),
                          ),
                          Positioned(
                            right: -20,
                            top: 0,
                            bottom: 0,
                            child: Container(
                              width: 40,
                              decoration: BoxDecoration(
                                color: isDark ? cs.surfaceContainerHighest : cs.surface,
                                shape: BoxShape.circle,
                              ),
                            ),
                          ),
                        ],
                      ),

                      // Zone QR Code
                      if (isUpcoming)
                        Container(
                          padding: const EdgeInsets.all(32),
                          decoration: const BoxDecoration(
                            borderRadius: BorderRadius.only(
                              bottomLeft: Radius.circular(24),
                              bottomRight: Radius.circular(24),
                            ),
                          ),
                          child: Column(
                            children: [
                              Container(
                                padding: const EdgeInsets.all(12),
                                decoration: BoxDecoration(
                                  color: Colors.white,
                                  borderRadius: BorderRadius.circular(16),
                                  border: Border.all(color: Colors.grey.shade300),
                                ),
                                child: QrImageView(
                                  data: reservation.qrCodeId,
                                  version: QrVersions.auto,
                                  size: 180.0,
                                  backgroundColor: Colors.white,
                                  foregroundColor: Colors.black,
                                ),
                              ),
                              const SizedBox(height: 16),
                              Text(
                                'Référence: ${reservation.id}',
                                style: theme.textTheme.bodyMedium?.copyWith(
                                  fontWeight: FontWeight.bold,
                                  letterSpacing: 1.5,
                                  color: cs.onSurface.withOpacity(0.6),
                                ),
                              )
                            ],
                          ),
                        ),
                    ],
                  ),
                ),
                
                const SizedBox(height: 32),

                // Actions
                if (isUpcoming) ...[
                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton.icon(
                      style: ElevatedButton.styleFrom(
                        padding: const EdgeInsets.symmetric(vertical: 16),
                      ),
                      onPressed: () {},
                      icon: const Icon(Icons.download),
                      label: const Text('Sauvegarder le ticket (PDF)'),
                    ),
                  ),
                  const SizedBox(height: 16),
                  SizedBox(
                    width: double.infinity,
                    child: TextButton(
                      style: TextButton.styleFrom(
                        foregroundColor: cs.error,
                      ),
                      onPressed: () {},
                      child: const Text('Demander une annulation'),
                    ),
                  ),
                ] else ...[
                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton.icon(
                      style: ElevatedButton.styleFrom(
                        padding: const EdgeInsets.symmetric(vertical: 16),
                      ),
                      onPressed: () {},
                      icon: const Icon(Icons.replay),
                      label: const Text('Réserver ce trajet à nouveau'),
                    ),
                  ),
                ]
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildCityTime(String city, ThemeData theme, ColorScheme cs, {bool isEnd = false}) {
    return Column(
      crossAxisAlignment: isEnd ? CrossAxisAlignment.end : CrossAxisAlignment.start,
      children: [
        Text(
          city.substring(0, 3).toUpperCase(),
          style: theme.textTheme.headlineMedium?.copyWith(
            fontWeight: FontWeight.w900,
            color: cs.primary,
            letterSpacing: 1.5,
          ),
        ),
        const SizedBox(height: 4),
        Text(
          city,
          style: theme.textTheme.titleSmall?.copyWith(
            color: cs.onSurface.withOpacity(0.7),
          ),
        ),
      ],
    );
  }

  Widget _buildInfoBlock(String title, String value, ThemeData theme, {bool highlight = false}) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          title.toUpperCase(),
          style: theme.textTheme.labelSmall?.copyWith(
            color: theme.colorScheme.onSurface.withOpacity(0.5),
            letterSpacing: 1,
            fontWeight: FontWeight.w600,
          ),
        ),
        const SizedBox(height: 4),
        Text(
          value,
          style: theme.textTheme.titleMedium?.copyWith(
            fontWeight: FontWeight.bold,
            color: highlight ? theme.colorScheme.primary : theme.colorScheme.onSurface,
          ),
        ),
      ],
    );
  }
}
