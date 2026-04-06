import 'package:camer_trip/app/models/voyage_model.dart';
import 'package:camer_trip/app/routes/app_routter.dart';
import 'package:camer_trip/app/services/providers.dart';
import 'package:camer_trip/app/shared/others/app_bar.dart';
import 'package:flutter/material.dart';
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

  @override
  void initState() {
    super.initState();
    _loadOccupiedSeats();
  }

  Future<void> _loadOccupiedSeats() async {
    final service = ref.read(reservationServiceProvider);
    final seats = await service.getOccupiedSeats(widget.voyage.id!);
    if (mounted) {
      setState(() {
        occupiedSeats = seats;
        isLoading = false;
      });
    }
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
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                '${widget.voyage.villeSource} → ${widget.voyage.villeDestination}',
                style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
              ),
              Text(
                'Départ: ${widget.voyage.dateDepart.hour}:${widget.voyage.dateDepart.minute.toString().padLeft(2, '0')}',
                style: TextStyle(color: cs.onSurface.withOpacity(0.6), fontSize: 13),
              ),
            ],
          ),
          Text(
            '${widget.voyage.prix.toInt()} FCFA',
            style: TextStyle(fontWeight: FontWeight.w900, color: cs.primary, fontSize: 18),
          ),
        ],
      ),
    );
  }

  Widget _buildBusLayout(ColorScheme cs, bool isDark) {
    return SingleChildScrollView(
      padding: const EdgeInsets.symmetric(vertical: 32, horizontal: 40),
      child: Column(
        children: [
          // Volant / Avant du bus
          Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: cs.onSurface.withOpacity(0.05),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Icon(Icons.settings_input_component_rounded, size: 24, color: cs.onSurface.withOpacity(0.3)),
              ),
            ],
          ),
          const SizedBox(height: 32),
          
          // Grille des sièges (11 rangées de 4 sièges)
          GridView.builder(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 4,
              mainAxisSpacing: 12,
              crossAxisSpacing: 12,
              childAspectRatio: 1,
            ),
            itemCount: 44, // 11 rangées de 4
            itemBuilder: (context, index) {
              // Simuler un couloir au milieu (entre index % 4 == 1 et index % 4 == 2)
              // Mais le GridView 4 colonnes ne gère pas bien les couloirs vides
              // On va juste faire une grille simple pour le moment
              String seatNum = (index + 1).toString();
              bool isOccupied = occupiedSeats.contains(seatNum);
              bool isSelected = selectedSeat == seatNum;

              return InkWell(
                onTap: isOccupied ? null : () {
                  setState(() => selectedSeat = isSelected ? null : seatNum);
                },
                child: Container(
                  decoration: BoxDecoration(
                    color: isOccupied 
                        ? Colors.grey.withOpacity(0.3) 
                        : isSelected 
                            ? cs.primary 
                            : isDark ? cs.surfaceContainerHigh : Colors.white,
                    borderRadius: BorderRadius.circular(10),
                    border: Border.all(
                      color: isSelected ? cs.primary : cs.primary.withOpacity(0.1),
                      width: 2,
                    ),
                  ),
                  child: Center(
                    child: Text(
                      seatNum,
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        color: isSelected ? Colors.white : isOccupied ? Colors.grey : cs.onSurface,
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
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceAround,
      children: [
        _buildLegendItem(cs, 'Libre', Colors.white, cs.primary.withOpacity(0.1)),
        _buildLegendItem(cs, 'Choisi', cs.primary, cs.primary),
        _buildLegendItem(cs, 'Occupé', Colors.grey.withOpacity(0.3), Colors.transparent),
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
