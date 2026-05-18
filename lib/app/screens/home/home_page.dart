import 'package:camer_trip/app/config/colors_config.dart';
import 'package:camer_trip/app/config/const_config.dart';
import 'package:camer_trip/app/models/ag_model.dart';
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
import 'package:camer_trip/app/shared/others/kwc_reminder_banner.dart';
import 'package:camer_trip/app/services/providers.dart';
import 'package:camer_trip/app/services/trip_filter_provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class HomePage extends ConsumerStatefulWidget {
  const HomePage({super.key});

  @override
  ConsumerState<HomePage> createState() => _HomePageState();
}

class _HomePageState extends ConsumerState<HomePage>
    with SingleTickerProviderStateMixin {
  late AnimationController _animController;
  late Animation<double> _fadeAnim;

  // L'état est désormais géré à 100% par des Riverpod FutureProviders.

  @override
  void initState() {
    super.initState();
    _animController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 700),
    );
    _fadeAnim = CurvedAnimation(parent: _animController, curve: Curves.easeOut);
    _animController.forward();
    
    // Synchronisation du statut utilisateur dès l'ouverture
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
    final userAsync = ref.watch(currentUserProvider);
    final promosAsync = ref.watch(promosProvider);
    final agencesAsync = ref.watch(agencesProvider);
    final destinationsAsync = ref.watch(destinationsProvider);

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
              await ref.refresh(syncUserProvider.future);
            },
            displacement: 20,
            color: cs.primary,
            child: CustomScrollView(
              physics: const AlwaysScrollableScrollPhysics(
                parent: BouncingScrollPhysics(),
              ),
              slivers: [
                SliverToBoxAdapter(child: MyAppBar(isHome: true)),
                
                // 🛡️ Bannière KWC si en attente (Commentée)
                // userAsync.when(
                //   data: (user) => user?.statut == "en attente" 
                //       ? const SliverToBoxAdapter(child: KwcReminderBanner())
                //       : const SliverToBoxAdapter(child: SizedBox.shrink()),
                //   loading: () => const SliverToBoxAdapter(child: SizedBox.shrink()),
                //   error: (e, s) => const SliverToBoxAdapter(child: SizedBox.shrink()),
                // ),
  
                promosAsync.when(
                  data: (promos) => promos.isNotEmpty 
                      ? SliverToBoxAdapter(child: PromoCarousel(promos: promos)) 
                      : const SliverToBoxAdapter(child: SizedBox.shrink()),
                  loading: () => const SliverToBoxAdapter(child: Padding(padding: EdgeInsets.all(20), child: Center(child: CircularProgressIndicator()))),
                  error: (e, s) => const SliverToBoxAdapter(child: SizedBox.shrink()),
                ),
  
                // 📅 SECTION VOYAGES ET FILTRES
                SliverToBoxAdapter(
                  child: SectionTitle(
                    title: '📅 Prochains Voyages',
                    action: 'Filtres',
                  ),
                ),
                const SliverToBoxAdapter(child: TripFilterBar()),
                const ScheduledTripsList(),
  
                SliverToBoxAdapter(
                  child: SectionTitle(
                    title: '🏢 Agences partenaires',
                    action: 'Voir tout',
                  ),
                ),
                agencesAsync.when(
                  data: (agences) => SliverToBoxAdapter(child: ListAgenceComponent(agences: agences)),
                  loading: () => const SliverToBoxAdapter(child: Padding(padding: EdgeInsets.all(20), child: Center(child: CircularProgressIndicator()))),
                  error: (e, s) => const SliverToBoxAdapter(child: SizedBox.shrink()),
                ),
  
                SliverToBoxAdapter(
                  child: SectionTitle(
                    title: '📍 Destinations populaires',
                    action: 'Voir tout',
                  ),
                ),
                destinationsAsync.when(
                  data: (destinations) => SliverToBoxAdapter(child: DestinationsList(destinations: destinations)),
                  loading: () => const SliverToBoxAdapter(child: Padding(padding: EdgeInsets.all(20), child: Center(child: CircularProgressIndicator()))),
                  error: (e, s) => const SliverToBoxAdapter(child: SizedBox.shrink()),
                ),
  
                SliverToBoxAdapter(
                  child: SectionTitle(title: '🚌 Types de trajet', action: ''),
                ),
                SliverToBoxAdapter(child: buildCategories(context, cs)),
  
                SliverToBoxAdapter(
                  child: SectionTitle(title: '🎟️ Réservation en cours', action: 'Détails'),
                ),
                const SliverToBoxAdapter(child: SizedBox(height: 120)), 
              ],
            ),
          ),
        ),
      ),
    );
  }
}