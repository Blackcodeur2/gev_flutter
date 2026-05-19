import 'package:camer_trip/app/models/ag_model.dart';
import 'package:camer_trip/app/models/voyage_model.dart';
import 'package:camer_trip/app/routes/app_routter.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';
import 'dart:math';
import 'package:camer_trip/l10n/app_localizations.dart';

class AgenceDetailsPage extends StatefulWidget {
  final Agence agence;
  const AgenceDetailsPage({super.key, required this.agence});

  @override
  State<AgenceDetailsPage> createState() => _AgenceDetailsPageState();
}

class _AgenceDetailsPageState extends State<AgenceDetailsPage> with SingleTickerProviderStateMixin {
  late TabController _tabController;

  List<VoyageModel> get upcomingVoyages => widget.agence.allVoyages
      .where((v) => v.statut == 'en attente')
      .toList();

  List<Map<String, dynamic>> get uniqueTrajets {
    final trajets = <String, Map<String, dynamic>>{};
    for (var v in widget.agence.allVoyages) {
      final key = '${v.villeSource}-${v.villeDestination}';
      if (!trajets.containsKey(key)) {
        trajets[key] = {
          'depart': v.villeSource,
          'arrivee': v.villeDestination,
          'prix': '${v.prix.toInt()} FCFA',
          'duree': '...', // Info non dispo dans VoyageModel direct
        };
      }
    }
    return trajets.values.toList();
  }

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 3, vsync: this);
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }


  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final cs = theme.colorScheme;
    final isDark = theme.brightness == Brightness.dark;
    
    return Scaffold(
      backgroundColor: cs.surface,
      body: NestedScrollView(
        headerSliverBuilder: (context, innerBoxIsScrolled) {
          return [
            SliverAppBar(
              expandedHeight: 220.0,
              pinned: true,
              backgroundColor: widget.agence.color,
              flexibleSpace: FlexibleSpaceBar(
                title: Text(
                  widget.agence.name,
                  style: const TextStyle(
                    fontWeight: FontWeight.bold, 
                    color: Colors.white, 
                    shadows: [Shadow(blurRadius: 4, color: Colors.black45)]
                  ),
                ),
                background: Stack(
                  fit: StackFit.expand,
                  children: [
                    // Arrière-plan coloré principal de l'agence
                    Container(
                      color: widget.agence.color,
                    ),
                    
                    // Icône d'agence en filigrane en arrière-plan
                    Positioned.fill(
                      child: Opacity(
                        opacity: 0.12,
                        child: Icon(
                          widget.agence.icon,
                          size: 160,
                          color: Colors.white,
                        ),
                      ),
                    ),

                    // Carte du logo au centre, garantissant sa lisibilité sur fond blanc
                    if (widget.agence.logoUrl != null)
                      Center(
                        child: Container(
                          width: 110,
                          height: 110,
                          padding: const EdgeInsets.all(8),
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(24),
                            boxShadow: [
                              BoxShadow(
                                color: Colors.black.withOpacity(0.25),
                                blurRadius: 15,
                                offset: const Offset(0, 5),
                              ),
                            ],
                          ),
                          child: ClipRRect(
                            borderRadius: BorderRadius.circular(16),
                            child: Image.network(
                              widget.agence.logoUrl!,
                              fit: BoxFit.contain,
                              errorBuilder: (context, error, stackTrace) => Icon(
                                widget.agence.icon,
                                size: 48,
                                color: widget.agence.color,
                              ),
                            ),
                          ),
                        ),
                      )
                    else
                      Center(
                        child: CircleAvatar(
                          radius: 45,
                          backgroundColor: Colors.white.withOpacity(0.2),
                          child: Icon(
                            widget.agence.icon,
                            size: 50,
                            color: Colors.white,
                          ),
                        ),
                      ),

                      // Dégradé au bas pour améliorer la lisibilité du titre
                      Positioned(
                        bottom: 0,
                        left: 0,
                        right: 0,
                        height: 80,
                        child: Container(
                          decoration: BoxDecoration(
                            gradient: LinearGradient(
                              begin: Alignment.bottomCenter,
                              end: Alignment.topCenter,
                              colors: [
                                Colors.black.withOpacity(0.6),
                                Colors.transparent,
                              ],
                            ),
                          ),
                        ),
                      )
                  ],
                ),
              ),
              leading: IconButton(
                icon: const Icon(Icons.arrow_back, color: Colors.white),
                onPressed: () => Navigator.of(context).pop(),
              ),
            ),
            SliverPersistentHeader(
              pinned: true,
              delegate: _SliverAppBarDelegate(
                TabBar(
                  controller: _tabController,
                  labelColor: widget.agence.color,
                  unselectedLabelColor: cs.onSurface.withOpacity(0.5),
                  indicatorColor: widget.agence.color,
                  indicatorWeight: 3,
                  labelStyle: const TextStyle(fontWeight: FontWeight.bold),
                  tabs: [
                    Tab(text: AppLocalizations.of(context)?.tabStations ?? "Gares"),
                    Tab(text: AppLocalizations.of(context)?.tabUpcoming ?? "Prochains"),
                    Tab(text: AppLocalizations.of(context)?.tabRoutes ?? "Trajets"),
                  ],
                ),
                cs.surface,
              ),
            ),
          ];
        },
        body: TabBarView(
          controller: _tabController,
          children: [
            _buildGaresList(cs),
            _buildVoyagesList(cs),
            _buildTrajetsList(cs),
          ],
        ),
      ),
    );
  }

  Widget _buildGaresList(ColorScheme cs) {
    final stations = widget.agence.stations;
    if (stations.isEmpty) {
      return _buildEmptyState(cs, AppLocalizations.of(context)?.noStationFound ?? 'Aucune station trouvée', Icons.location_off);
    }
    final isDark = Theme.of(context).brightness == Brightness.dark;
    
    return ListView.builder(
      padding: const EdgeInsets.all(16),
      itemCount: stations.length,
      itemBuilder: (context, index) {
        final station = stations[index];
        return Container(
          margin: const EdgeInsets.only(bottom: 12),
          decoration: BoxDecoration(
            color: isDark ? cs.surfaceContainerHigh : Colors.white,
            borderRadius: BorderRadius.circular(16),
            border: Border.all(
              color: isDark ? Colors.white.withOpacity(0.05) : Colors.black.withOpacity(0.05),
            ),
            boxShadow: [
              BoxShadow(
                color: isDark ? Colors.black26 : cs.shadow.withOpacity(0.04),
                blurRadius: 10,
                offset: const Offset(0, 4),
              ),
            ],
          ),
          child: Padding(
            padding: const EdgeInsets.symmetric(vertical: 4),
            child: ListTile(
              contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
              leading: Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: widget.agence.color.withOpacity(0.15),
                  shape: BoxShape.circle,
                ),
                child: Icon(Icons.location_on_outlined, color: widget.agence.color, size: 22),
              ),
              title: Text(
                station['ville'] ?? 'Station', 
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  color: cs.onSurface,
                ),
              ),
              subtitle: Padding(
                padding: const EdgeInsets.only(top: 4.0),
                child: Text(
                  '${station['nom']} - ${station['adresse'] ?? ''}',
                  style: TextStyle(
                    color: cs.onSurface.withOpacity(0.6),
                    fontSize: 13,
                  ),
                ),
              ),
              trailing: Container(
                decoration: BoxDecoration(
                  color: widget.agence.color.withOpacity(0.1),
                  shape: BoxShape.circle,
                ),
                child: IconButton(
                  icon: Icon(Icons.map_outlined, color: widget.agence.color, size: 20),
                  onPressed: () {}, 
                ),
              ),
            ),
          ),
        );
      },
    );
  }

  Widget _buildVoyagesList(ColorScheme cs) {
    final voyages = upcomingVoyages;
    if (voyages.isEmpty) {
      return _buildEmptyState(cs, AppLocalizations.of(context)?.noUpcomingTrip ?? 'Aucun voyage en attente', Icons.event_busy);
    }
    final isDark = Theme.of(context).brightness == Brightness.dark;
    
    return ListView.builder(
      padding: const EdgeInsets.all(16),
      itemCount: voyages.length,
      itemBuilder: (context, index) {
        final voy = voyages[index];
        final totalSeats = voy.nbPlaces != null ? (voy.nbPlaces! - 2) : 68;
        final reservationsCount = voy.reservationsCount ?? 0;
        final available = max(0, totalSeats - reservationsCount);
        
        return Container(
          margin: const EdgeInsets.only(bottom: 16),
          decoration: BoxDecoration(
            color: isDark ? cs.surfaceContainerHigh : Colors.white,
            borderRadius: BorderRadius.circular(20),
            border: Border.all(
              color: isDark ? Colors.white.withOpacity(0.05) : Colors.black.withOpacity(0.05),
            ),
            boxShadow: [
              BoxShadow(
                color: isDark ? Colors.black26 : cs.shadow.withOpacity(0.05),
                blurRadius: 10,
                offset: const Offset(0, 4),
              ),
            ],
          ),
          child: Padding(
            padding: const EdgeInsets.all(18),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Expanded(
                      child: Text(
                        '${voy.villeSource} → ${voy.villeDestination}', 
                        style: TextStyle(
                          fontWeight: FontWeight.w800, 
                          fontSize: 16,
                          color: cs.onSurface,
                        ),
                      ),
                    ),
                    const SizedBox(width: 8),
                    Text(
                      '${voy.prix.toInt()} FCFA', 
                      style: TextStyle(
                        fontWeight: FontWeight.w900, 
                        color: widget.agence.color, 
                        fontSize: 16,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 14),
                Row(
                  children: [
                    Icon(Icons.calendar_today_outlined, size: 15, color: cs.onSurface.withOpacity(0.5)),
                    const SizedBox(width: 8),
                    Text(
                      voy.dateStr, 
                      style: TextStyle(
                        color: cs.onSurface.withOpacity(0.7), 
                        fontWeight: FontWeight.w600,
                        fontSize: 13,
                      ),
                    ),
                    const SizedBox(width: 16),
                    Icon(Icons.access_time_outlined, size: 15, color: cs.onSurface.withOpacity(0.5)),
                    const SizedBox(width: 8),
                    Text(
                      voy.timeStr, 
                      style: TextStyle(
                        color: cs.onSurface.withOpacity(0.7), 
                        fontWeight: FontWeight.w600,
                        fontSize: 13,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 18),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                      decoration: BoxDecoration(
                        color: available > 0 
                            ? (isDark ? Colors.green.withOpacity(0.15) : Colors.green.withOpacity(0.1))
                            : (isDark ? Colors.red.withOpacity(0.15) : Colors.red.withOpacity(0.1)),
                        borderRadius: BorderRadius.circular(10),
                        border: Border.all(
                          color: available > 0 
                              ? (isDark ? Colors.green.withOpacity(0.3) : Colors.green.withOpacity(0.2))
                              : (isDark ? Colors.red.withOpacity(0.3) : Colors.red.withOpacity(0.2)),
                        ),
                      ),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Icon(
                            available > 0 ? Icons.event_seat : Icons.block,
                            size: 16,
                            color: available > 0 
                                ? (isDark ? Colors.green[300] : Colors.green[800])
                                : (isDark ? Colors.red[300] : Colors.red[800]),
                          ),
                          const SizedBox(width: 6),
                          Text(
                            available > 0
                                ? (AppLocalizations.of(context)?.seatsAvailable(available) ?? '$available places dispo')
                                : (AppLocalizations.of(context)?.tripFull ?? 'Voyage Complet'), 
                            style: TextStyle(
                              color: available > 0 
                                  ? (isDark ? Colors.green[300] : Colors.green[800])
                                  : (isDark ? Colors.red[300] : Colors.red[800]), 
                              fontWeight: FontWeight.bold, 
                              fontSize: 12,
                            ),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(width: 8),
                    ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        minimumSize: Size.zero, 
                        backgroundColor: widget.agence.color,
                        foregroundColor: Colors.white,
                        elevation: 0,
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                        padding: const EdgeInsets.symmetric(horizontal: 22, vertical: 12),
                      ),
                      onPressed: available > 0
                          ? () => context.pushNamed(AppRouter.booking, extra: voy)
                          : null, 
                      child: Text(
                        available > 0
                          ? (AppLocalizations.of(context)?.book ?? 'Réserver')
                          : (AppLocalizations.of(context)?.full ?? 'Complet'),
                        style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 13),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  Widget _buildTrajetsList(ColorScheme cs) {
    final trajets = uniqueTrajets;
    if (trajets.isEmpty) {
      return _buildEmptyState(cs, AppLocalizations.of(context)?.noRouteAvailable ?? 'Aucun trajet disponible', Icons.alt_route);
    }
    final isDark = Theme.of(context).brightness == Brightness.dark;
    
    return ListView.builder(
      padding: const EdgeInsets.all(16),
      itemCount: trajets.length,
      itemBuilder: (context, index) {
        final traj = trajets[index];
        return Container(
          margin: const EdgeInsets.only(bottom: 12),
          decoration: BoxDecoration(
            color: isDark ? cs.surfaceContainerHigh : Colors.white,
            borderRadius: BorderRadius.circular(16),
            border: Border.all(
              color: isDark ? Colors.white.withOpacity(0.05) : Colors.black.withOpacity(0.05),
            ),
            boxShadow: [
              BoxShadow(
                color: isDark ? Colors.black26 : cs.shadow.withOpacity(0.04),
                blurRadius: 10,
                offset: const Offset(0, 4),
              ),
            ],
          ),
          child: Padding(
            padding: const EdgeInsets.symmetric(vertical: 4),
            child: ListTile(
              contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
              leading: Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: widget.agence.color.withOpacity(0.15),
                  shape: BoxShape.circle,
                ),
                child: Icon(Icons.alt_route_outlined, color: widget.agence.color, size: 22),
              ),
              title: Text(
                '${traj['depart']} ↔ ${traj['arrivee']}', 
                style: TextStyle(
                  fontWeight: FontWeight.bold, 
                  fontSize: 15,
                  color: cs.onSurface,
                ),
              ),
              subtitle: Padding(
                padding: const EdgeInsets.only(top: 4.0),
                child: Text(
                  AppLocalizations.of(context)?.gevNetwork ?? 'Réseau Camertrip',
                  style: TextStyle(
                    color: cs.onSurface.withOpacity(0.5),
                    fontSize: 13,
                  ),
                ),
              ),
              trailing: Text(
                traj['prix']!, 
                style: TextStyle(
                  fontWeight: FontWeight.w900, 
                  color: widget.agence.color, 
                  fontSize: 15,
                ),
              ),
            ),
          ),
        );
      },
    );
  }

  Widget _buildEmptyState(ColorScheme cs, String message, IconData icon) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(icon, size: 64, color: cs.onSurface.withOpacity(0.1)),
          const SizedBox(height: 16),
          Text(message, style: TextStyle(color: cs.onSurface.withOpacity(0.4), fontWeight: FontWeight.bold)),
        ],
      ),
    );
  }
}

class _SliverAppBarDelegate extends SliverPersistentHeaderDelegate {
  _SliverAppBarDelegate(this._tabBar, this._color);

  final TabBar _tabBar;
  final Color _color;

  @override
  double get minExtent => _tabBar.preferredSize.height;
  @override
  double get maxExtent => _tabBar.preferredSize.height;

  @override
  Widget build(BuildContext context, double shrinkOffset, bool overlapsContent) {
    return Container(
      color: _color,
      child: _tabBar,
    );
  }

  @override
  bool shouldRebuild(_SliverAppBarDelegate oldDelegate) {
    return false;
  }
}
