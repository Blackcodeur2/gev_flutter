import 'package:camer_trip/app/models/voyage_model.dart';
import 'package:camer_trip/app/routes/app_routter.dart';
import 'package:camer_trip/app/services/providers.dart';
import 'package:camer_trip/app/shared/others/app_bar.dart';
import 'package:flutter/material.dart';
import 'dart:async';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

class BookingPage extends ConsumerStatefulWidget {
  final VoyageModel voyage;
  const BookingPage({super.key, required this.voyage});

  @override
  ConsumerState<BookingPage> createState() => _BookingPageState();
}

class _BookingPageState extends ConsumerState<BookingPage> {
  String? selectedSeat;
  List<String> occupiedSeats = [];
  bool isLoading = true;
  Timer? _refreshTimer;

  @override
  void initState() {
    super.initState();
    _loadOccupiedSeats();
    // Rafraîchissement automatique toutes les 10 secondes
    _refreshTimer = Timer.periodic(const Duration(seconds: 10), (_) => _loadOccupiedSeats());
  }

  Future<void> _loadOccupiedSeats() async {
    final service = ref.read(reservationServiceProvider);
    final seats = await service.getOccupiedSeats(widget.voyage.id!);
    if (mounted) {
      setState(() {
        occupiedSeats = seats;
        // Les places 1 et 2 sont réservées au chauffeur et motorboy
        if (!occupiedSeats.contains("1")) {
          occupiedSeats.add("1");
        }
        if (!occupiedSeats.contains("2")) {
          occupiedSeats.add("2");
        }
        isLoading = false;
      });
    }
  }

  @override
  void dispose() {
    _refreshTimer?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final cs = theme.colorScheme;
    final isDark = theme.brightness == Brightness.dark;

    return Scaffold(
      backgroundColor: cs.surface,
      body: SafeArea(
        child: Column(
          children: [
            MyAppBar(title: 'Choix du siège'),
            _buildTripHeader(cs),
            Expanded(
              child: isLoading
                  ? const Center(child: CircularProgressIndicator())
                  : _buildBusLayout(cs, isDark),
            ),
            _buildFooter(cs),
          ],
        ),
      ),
    );
  }

  Widget _buildTripHeader(ColorScheme cs) {
    return Container(
      padding: const EdgeInsets.all(16),
      color: cs.primary.withOpacity(0.05),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  '${widget.voyage.villeSource} → ${widget.voyage.villeDestination}',
                  style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
                  overflow: TextOverflow.ellipsis,
                  maxLines: 2,
                ),
                Text(
                  'Départ: ${widget.voyage.fullDepartureDate.hour}:${widget.voyage.fullDepartureDate.minute.toString().padLeft(2, '0')}',
                  style: TextStyle(color: cs.onSurface.withOpacity(0.6), fontSize: 13),
                ),
              ],
            ),
          ),
          const SizedBox(width: 8),
          Text(
            '${widget.voyage.prix.toInt()} FCFA',
            style: TextStyle(fontWeight: FontWeight.w900, color: cs.primary, fontSize: 18),
          ),
        ],
      ),
    );
  }

  Widget _buildBusLayout(ColorScheme cs, bool isDark) {
    final int s = widget.voyage.nbPlaces ?? 44;
    final int numDoors = s <= 35 ? 1 : 2;
    // Les portes + 1 espace vide d'accès par porte (à côté de la porte)
    final int totalNonSeats = numDoors * 2;
    final int totalItems = ((s + totalNonSeats) / 5).ceil() * 5;

    final int door1 = 9; // Deuxième ligne, à droite (1 * 5 + 4)
    final int emptySpace1Next = 8; // Deuxième ligne, à côté de la porte 1 (index 8, colonne 3)

    final int? door2 = s <= 35 ? null : (totalItems - 16); // 3 lignes de la fin, à droite
    final int? emptySpace2Next = door2 != null ? (door2 - 1) : null; // À côté de la porte 2

    final List<GridItem> gridItems = [];
    int seatCount = 0;

    for (int i = 0; i < totalItems; i++) {
      if (i == door1 || (door2 != null && i == door2)) {
        gridItems.add(GridItem(type: GridItemType.door));
      } else if (i == emptySpace1Next || (emptySpace2Next != null && i == emptySpace2Next)) {
        gridItems.add(GridItem(type: GridItemType.empty));
      } else {
        if (seatCount < s) {
          seatCount++;
          gridItems.add(GridItem(type: GridItemType.seat, seatNumber: seatCount.toString()));
        } else {
          gridItems.add(GridItem(type: GridItemType.empty));
        }
      }
    }

    return SingleChildScrollView(
      padding: const EdgeInsets.symmetric(vertical: 24, horizontal: 36),
      child: Column(
        children: [
          // Volant / Avant du bus
          Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              Container(
                padding: const EdgeInsets.all(6),
                decoration: BoxDecoration(
                  color: cs.onSurface.withOpacity(0.05),
                  borderRadius: BorderRadius.circular(6),
                ),
                child: Icon(Icons.settings_input_component_rounded, size: 20, color: cs.onSurface.withOpacity(0.3)),
              ),
            ],
          ),
          const SizedBox(height: 24),
          
          // Grille des sièges (5 colonnes: 3 à gauche, 2 à droite)
          GridView.builder(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 5,
              mainAxisSpacing: 10,
              crossAxisSpacing: 10,
              childAspectRatio: 1,
            ),
            itemCount: totalItems,

            itemBuilder: (context, index) {
              final item = gridItems[index];

              final colIndex = index % 5;
              EdgeInsetsGeometry? margin;
              if (colIndex == 2) {
                // Allée de séparation après la 3e colonne
                margin = const EdgeInsets.only(right: 12);
              } else if (colIndex == 3) {
                // Allée de séparation avant la 4e colonne
                margin = const EdgeInsets.only(left: 12);
              }

              if (item.type == GridItemType.door) {
                return Container(
                  margin: margin,
                  decoration: BoxDecoration(
                    color: cs.primary.withOpacity(0.05),
                    borderRadius: BorderRadius.circular(8),
                    border: Border.all(
                      color: cs.primary.withOpacity(0.15),
                      width: 1,
                    ),
                  ),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(
                        Icons.sensor_door_rounded, 
                        color: cs.primary.withOpacity(0.6), 
                        size: 14
                      ),
                      const SizedBox(height: 2),
                      Text(
                        'Porte',
                        style: TextStyle(
                          fontSize: 8,
                          fontWeight: FontWeight.bold,
                          color: cs.primary.withOpacity(0.6),
                        ),
                      ),
                    ],
                  ),
                );
              }

              if (item.type == GridItemType.empty) {
                return const SizedBox.shrink();
              }

              String seatNum = item.seatNumber!;
              bool isOccupied = occupiedSeats.contains(seatNum);
              bool isDriver = seatNum == "1";
              bool isMotorboy = seatNum == "2";
              bool isSelected = selectedSeat == seatNum;

              return InkWell(
                onTap: (isOccupied || isDriver || isMotorboy) ? null : () {
                  setState(() => selectedSeat = isSelected ? null : seatNum);
                },
                child: Container(
                  margin: margin,
                  decoration: BoxDecoration(
                    color: isDriver 
                        ? Colors.blueGrey 
                        : isMotorboy 
                            ? Colors.blueGrey.withOpacity(0.75)
                            : isOccupied 
                                ? Colors.grey.withOpacity(0.3) 
                                : isSelected 
                                    ? cs.primary 
                                    : isDark ? cs.surfaceContainerHigh : Colors.white,
                    borderRadius: BorderRadius.circular(8),
                    border: Border.all(
                      color: isSelected ? cs.primary : cs.primary.withOpacity(0.1),
                      width: 1.5,
                    ),
                  ),
                  child: Center(
                    child: isDriver 
                    ? const Icon(Icons.settings_input_component_rounded, color: Colors.white, size: 14)
                    : isMotorboy 
                        ? const Icon(Icons.engineering_rounded, color: Colors.white, size: 14)
                        : Text(
                            seatNum,
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 11,
                              color: isSelected ? Colors.white : (isOccupied || isDriver || isMotorboy) ? Colors.grey : cs.onSurface,
                            ),
                          ),
                  ),
                ),
              );
            },
          ),
          
          const SizedBox(height: 32),
          _buildLegend(cs),
        ],
      ),
    );
  }

  Widget _buildLegend(ColorScheme cs) {
    return Column(
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            _buildLegendItem(cs, 'Libre', Colors.white, cs.primary.withOpacity(0.1)),
            _buildLegendItem(cs, 'Choisi', cs.primary, cs.primary),
            _buildLegendItem(cs, 'Occupé', Colors.grey.withOpacity(0.3), Colors.transparent),
          ],
        ),
        const SizedBox(height: 12),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            _buildLegendItem(cs, 'Personnel', Colors.blueGrey, Colors.transparent),
            const SizedBox(width: 24),
            _buildLegendItem(cs, 'Porte', cs.primary.withOpacity(0.05), cs.primary.withOpacity(0.15)),
          ],
        ),
      ],
    );
  }

  Widget _buildLegendItem(ColorScheme cs, String label, Color color, Color border) {
    return Row(
      children: [
        Container(
          width: 16,
          height: 16,
          decoration: BoxDecoration(
            color: color,
            borderRadius: BorderRadius.circular(4),
            border: Border.all(color: border),
          ),
        ),
        const SizedBox(width: 8),
        Text(label, style: const TextStyle(fontSize: 12)),
      ],
    );
  }

  Widget _buildFooter(ColorScheme cs) {
    return Container(
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: cs.surface,
        boxShadow: [
          BoxShadow(color: Colors.black.withOpacity(0.05), blurRadius: 10, offset: const Offset(0, -5))
        ],
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text('Siège sélectionné:', style: TextStyle(color: cs.onSurface.withOpacity(0.6))),
              Text(
                selectedSeat != null ? 'Siège #$selectedSeat' : 'Aucun',
                style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
              ),
            ],
          ),
          const SizedBox(height: 16),
          SizedBox(
            width: double.infinity,
            height: 56,
            child: ElevatedButton(
              onPressed: selectedSeat == null ? null : () {
                context.pushNamed(AppRouter.payment, extra: {
                  'voyage': widget.voyage,
                  'seat': selectedSeat,
                });
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: cs.primary,
                foregroundColor: Colors.white,
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
              ),
              child: const Text('CONTINUER VERS LE PAIEMENT', style: TextStyle(fontWeight: FontWeight.bold)),
            ),
          ),
        ],
      ),
    );
  }
}

enum GridItemType { seat, door, empty }

class GridItem {
  final GridItemType type;
  final String? seatNumber;

  GridItem({required this.type, this.seatNumber});
}
