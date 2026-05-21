import 'package:camer_trip/app/config/colors_config.dart';
import 'package:camer_trip/app/config/const_config.dart';
import 'package:camer_trip/app/models/ag_model.dart';
import 'package:camer_trip/app/models/reservation_model.dart';
import 'package:camer_trip/app/models/destination_model.dart';
import 'package:camer_trip/app/models/promo_trip_model.dart';
import 'package:camer_trip/app/shared/cards/voyage_card.dart';
import 'package:camer_trip/app/shared/others/app_bar.dart';
import 'package:camer_trip/app/shared/others/categorie_bloc.dart';
import 'package:camer_trip/app/shared/others/destinations_list.dart';
import 'package:camer_trip/app/shared/others/list_agence.dart';
import 'package:camer_trip/app/shared/others/promo_carousel.dart';
import 'package:camer_trip/app/shared/others/section_title.dart';
import 'package:camer_trip/app/shared/others/scheduled_trips_list.dart';
import 'package:camer_trip/app/shared/others/trip_filter_bar.dart';
import 'package:camer_trip/app/services/providers.dart';
import 'package:camer_trip/app/services/trip_filter_provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:camer_trip/l10n/app_localizations.dart';
import 'package:go_router/go_router.dart';

class HomePage extends ConsumerStatefulWidget {
  const HomePage({super.key});

  @override
  ConsumerState<HomePage> createState() => _HomePageState();
}

class _HomePageState extends ConsumerState<HomePage>
    with SingleTickerProviderStateMixin {
  late AnimationController _animController;
  late Animation<double> _fadeAnim;

  @override
  void initState() {
    super.initState();
    _animController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 700),
    );
    _fadeAnim = CurvedAnimation(parent: _animController, curve: Curves.easeOut);
    _animController.forward();
    
    WidgetsBinding.instance.addPostFrameCallback((_) {
      ref.read(syncUserProvider);
    });
  }

  @override
  void dispose() {
    _animController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final cs = theme.colorScheme;
    final isDark = theme.brightness == Brightness.dark;
    final localizations = AppLocalizations.of(context);
    final promosAsync = ref.watch(promosProvider);
    final agencesAsync = ref.watch(agencesProvider);
    final isLoggedIn = ref.watch(isLoggedInProvider).value ?? false;
    final reservationsAsync = isLoggedIn ? ref.watch(myReservationsProvider) : null;

    return Scaffold(
      backgroundColor: cs.surface,
      body: FadeTransition(
        opacity: _fadeAnim,
        child: SafeArea(
          child: RefreshIndicator(
            onRefresh: () async {
              ref.invalidate(promosProvider);
              ref.invalidate(agencesProvider);
              ref.invalidate(destinationsProvider);
              ref.invalidate(allScheduledTripsProvider);
              ref.invalidate(myReservationsProvider);
              final _ = await ref.refresh(syncUserProvider.future);
            },
            displacement: 20,
            color: cs.primary,
            child: CustomScrollView(
              physics: const AlwaysScrollableScrollPhysics(
                parent: BouncingScrollPhysics(),
              ),
              slivers: [
                SliverToBoxAdapter(child: MyAppBar(isHome: true)),
                
                promosAsync.when(
                  data: (promos) => promos.isNotEmpty 
                      ? SliverToBoxAdapter(child: PromoCarousel(promos: promos)) 
                      : const SliverToBoxAdapter(child: SizedBox.shrink()),
                  loading: () => const SliverToBoxAdapter(child: Padding(padding: EdgeInsets.all(20), child: Center(child: CircularProgressIndicator()))),
                  error: (e, s) => const SliverToBoxAdapter(child: SizedBox.shrink()),
                ),
  
                SliverToBoxAdapter(
                  child: SectionTitle(
                    title: localizations?.upcomingTripsTitle ?? '📅 Prochains Voyages',
                    action: '', 
                  ),
                ),
                const SliverToBoxAdapter(child: TripFilterBar()),
                const ScheduledTripsList(),
  
                SliverToBoxAdapter(
                  child: SectionTitle(
                    title: localizations?.partnerAgenciesTitle ?? '🏢 Agences partenaires',
                    action: '', 
                  ),
                ),
                agencesAsync.when(
                  data: (agences) => SliverToBoxAdapter(child: ListAgenceComponent(agences: agences)),
                  loading: () => const SliverToBoxAdapter(child: Padding(padding: EdgeInsets.all(20), child: Center(child: CircularProgressIndicator()))),
                  error: (e, s) => SliverToBoxAdapter(child: Padding(padding: const EdgeInsets.all(20), child: Center(child: Text('Erreur: $e')))),
                ),
  
                SliverToBoxAdapter(
                  child: SectionTitle(
                    title: localizations?.currentReservationsTitle ?? '🎟️ Réservation en cours',
                    action: '', 
                  ),
                ),
                if (isLoggedIn && reservationsAsync != null)
                  reservationsAsync.when(
                    data: (reservations) {
                      final currentRes = reservations.where((r) => 
                        r.status != 'annulee' && r.voyageStatus == 'en attente'
                      ).toList();

                      if (currentRes.isEmpty) {
                        return SliverToBoxAdapter(
                          child: Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 20),
                            child: Center(
                              child: Text(
                                localizations?.noReservationPending ?? 'Aucune réservation en cours',
                                style: const TextStyle(color: Colors.grey),
                              ),
                            ),
                          ),
                        );
                      }

                      return SliverList(
                        delegate: SliverChildBuilderDelegate(
                          (context, index) {
                            final res = currentRes[index];
                            return _buildHomeReservationCard(context, res, cs, theme, isDark);
                          },
                          childCount: currentRes.length,
                        ),
                      );
                    },
                    loading: () => const SliverToBoxAdapter(
                      child: Padding(
                        padding: EdgeInsets.all(20),
                        child: Center(child: CircularProgressIndicator()),
                      ),
                    ),
                    error: (e, s) => SliverToBoxAdapter(
                      child: Padding(
                        padding: const EdgeInsets.all(20),
                        child: Center(child: Text('Erreur: $e')),
                      ),
                    ),
                  )
                else
                  SliverToBoxAdapter(
                    child: Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 20),
                      child: Center(
                        child: Text(
                          localizations?.noReservationPending ?? 'Connectez-vous pour voir vos réservations',
                          style: const TextStyle(color: Colors.grey),
                        ),
                      ),
                    ),
                  ),
                const SliverToBoxAdapter(child: SizedBox(height: 120)), 
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildHomeReservationCard(
      BuildContext context, ReservationModel res, ColorScheme cs, ThemeData theme, bool isDark) {
    Color statusColor;
    String statusLabel;
    final localizations = AppLocalizations.of(context);
    
    switch (res.status) {
      case 'validee':
        statusColor = Colors.green;
        statusLabel = localizations?.statusValidated ?? 'Validée';
        break;
      case 'annulee':
        statusColor = cs.error;
        statusLabel = localizations?.statusCancelled ?? 'Annulée';
        break;
      case 'en attente':
      default:
        statusColor = Colors.orange;
        statusLabel = localizations?.statusPending ?? 'En attente';
        break;
    }

    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 8.0),
      decoration: BoxDecoration(
        color: isDark ? cs.surfaceContainerHigh : Colors.white,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.04),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
        border: Border.all(
          color: cs.outline.withOpacity(0.08),
        ),
      ),
      child: Material(
        color: Colors.transparent,
        borderRadius: BorderRadius.circular(20),
        child: InkWell(
          onTap: () => context.pushNamed('reservationDetails', extra: res),
          borderRadius: BorderRadius.circular(20),
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Row(
              children: [
                // Icon block
                Container(
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: cs.primary.withOpacity(0.1),
                    shape: BoxShape.circle,
                  ),
                  child: Icon(Icons.confirmation_number_rounded, color: cs.primary, size: 24),
                ),
                const SizedBox(width: 16),
                
                // Details
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        res.route ?? '...',
                        style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 15),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        '${res.date} • ${res.time}',
                        style: TextStyle(color: cs.onSurface.withOpacity(0.6), fontSize: 12),
                      ),
                      const SizedBox(height: 2),
                      Text(
                        res.agenceName ?? 'Agence',
                        style: TextStyle(color: cs.primary, fontSize: 12, fontWeight: FontWeight.w600),
                      ),
                    ],
                  ),
                ),
                
                // Status badge
                Column(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                      decoration: BoxDecoration(
                        color: statusColor.withOpacity(0.1),
                        borderRadius: BorderRadius.circular(30),
                      ),
                      child: Text(
                        statusLabel,
                        style: TextStyle(color: statusColor, fontWeight: FontWeight.bold, fontSize: 11),
                      ),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      '${res.prix.toInt()} FCFA',
                      style: TextStyle(fontWeight: FontWeight.w900, color: cs.primary, fontSize: 14),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}