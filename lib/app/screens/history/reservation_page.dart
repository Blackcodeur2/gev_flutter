import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:camer_trip/app/models/reservation_model.dart';
import 'package:camer_trip/app/shared/others/app_bar.dart';

class ReservationsPages extends StatefulWidget {
  const ReservationsPages({super.key});

  @override
  State<ReservationsPages> createState() => _ReservationsPagesState();
}

class _ReservationsPagesState extends State<ReservationsPages>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;

  final List<ReservationModel> dummyReservations = [
    ReservationModel(
      id: 1,
      numReservation: 'RES-001',
      agenceName: 'General Express',
      route: 'Douala ↔ Yaoundé',
      date: '12 Avril 2026',
      time: '08:00',
      status: 'À venir',
      prix: 2500,
      place: '12A',
      userId: 1,
      gareId: 1,
      voyageId: 1,
    ),
    ReservationModel(
      id: 2,
      numReservation: 'RES-002',
      agenceName: 'Touristique Express',
      route: 'Yaoundé ↔ Bafoussam',
      date: '05 Avril 2026',
      time: '14:30',
      status: 'Passé',
      prix: 3000,
      place: '05B',
      userId: 1,
      gareId: 2,
      voyageId: 2,
    ),
    ReservationModel(
      id: 3,
      numReservation: 'RES-003',
      agenceName: 'Finexs Voyages',
      route: 'Douala ↔ Kribi',
      date: '20 Mars 2026',
      time: '09:00',
      status: 'Passé',
      prix: 2000,
      place: '15C',
      userId: 1,
      gareId: 1,
      voyageId: 3,
    ),
    ReservationModel(
      id: 4,
      numReservation: 'RES-004',
      agenceName: 'Vatican Express',
      route: 'Douala ↔ Yaoundé',
      date: '10 Mars 2026',
      time: '07:00',
      status: 'Annulé',
      prix: 2500,
      place: '02A',
      userId: 1,
      gareId: 1,
      voyageId: 1,
    ),
  ];

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
    final colorScheme = theme.colorScheme;

    return Scaffold(
      backgroundColor: colorScheme.surface,
      body: SafeArea(
        child: Column(
          children: [
            const MyAppBar(title: 'Mes Réservations'),
            const SizedBox(height: 16),
            TabBar(
              controller: _tabController,
              labelColor: colorScheme.primary,
              unselectedLabelColor: colorScheme.onSurface.withOpacity(0.5),
              indicatorColor: colorScheme.primary,
              tabs: const [
                Tab(text: 'À venir'),
                Tab(text: 'Passés'),
                Tab(text: 'Annulés'),
              ],
            ),
            Expanded(
              child: TabBarView(
                controller: _tabController,
                children: [
                  _buildReservationList('À venir'),
                  _buildReservationList('Passé'),
                  _buildReservationList('Annulé'),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildReservationList(String statusFilter) {
    final filtered = dummyReservations
        .where((element) => element.status == statusFilter)
        .toList();

    if (filtered.isEmpty) {
      return Center(
        child: Text(
          'Aucune réservation',
          style: Theme.of(context).textTheme.bodyMedium?.copyWith(
            color: Theme.of(context).colorScheme.onSurface.withOpacity(0.6),
          ),
        ),
      );
    }

    return ListView.builder(
      padding: const EdgeInsets.all(16.0),
      itemCount: filtered.length,
      itemBuilder: (context, index) {
        final res = filtered[index];
        return _buildReservationCard(res);
      },
    );
  }

  Widget _buildReservationCard(ReservationModel res) {
    final theme = Theme.of(context);
    final cs = theme.colorScheme;
    final isDark = theme.brightness == Brightness.dark;

    Color statusColor;
    switch (res.status ?? 'en attente') {
      case 'en attente':
        statusColor = cs.primary;
        break;
      case 'annulee':
        statusColor = cs.error;
        break;
      case 'validee':
      default:
        statusColor = Colors.grey;
        break;
    }

    return Container(
      margin: const EdgeInsets.only(bottom: 16.0),
      decoration: BoxDecoration(
        color: isDark ? cs.surface.withOpacity(0.8) : Colors.white,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: isDark ? Colors.black.withOpacity(0.4) : cs.shadow.withOpacity(0.08),
            blurRadius: 15,
            offset: const Offset(0, 5),
          ),
        ],
        border: Border.all(
          color: isDark ? Colors.white10 : cs.primary.withOpacity(0.1),
        ),
      ),
      child: Material(
        color: Colors.transparent,
        borderRadius: BorderRadius.circular(20),
        child: InkWell(
          borderRadius: BorderRadius.circular(20),
          onTap: () {
            context.pushNamed('reservationDetails', extra: res);
          },
          child: Padding(
            padding: const EdgeInsets.all(20.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Row(
                      children: [
                        Container(
                          padding: const EdgeInsets.all(8),
                          decoration: BoxDecoration(
                            color: cs.primary.withOpacity(0.1),
                            shape: BoxShape.circle,
                          ),
                          child: Icon(Icons.directions_bus, color: cs.primary, size: 18),
                        ),
                        const SizedBox(width: 12),
                        Text(
                          res.agenceName ?? 'Agence',
                          style: theme.textTheme.titleMedium?.copyWith(
                            fontWeight: FontWeight.w900,
                            color: cs.onSurface,
                            letterSpacing: -0.3,
                          ),
                        ),
                      ],
                    ),
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
                      decoration: BoxDecoration(
                        color: statusColor.withOpacity(0.15),
                        borderRadius: BorderRadius.circular(12),
                        border: Border.all(color: statusColor.withOpacity(0.3)),
                      ),
                      child: Text(
                        res.status ?? 'À venir',
                        style: theme.textTheme.labelSmall?.copyWith(
                          color: statusColor,
                          fontWeight: FontWeight.bold,
                          letterSpacing: 0.5,
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 20),
                Row(
                  children: [
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            res.route?.split(' ↔ ').first ?? '',
                            style: theme.textTheme.titleMedium?.copyWith(
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          const SizedBox(height: 4),
                          Text(
                            '${res.date} • ${res.time}',
                            style: theme.textTheme.bodySmall?.copyWith(
                              color: cs.onSurface.withOpacity(0.6),
                            ),
                          ),
                        ],
                      ),
                    ),
                    Icon(Icons.arrow_forward_rounded, color: cs.primary.withOpacity(0.5)),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.end,
                        children: [
                          Text(
                            res.route?.split(' ↔ ').last ?? '',
                            style: theme.textTheme.titleMedium?.copyWith(
                              fontWeight: FontWeight.bold,
                            ),
                            textAlign: TextAlign.right,
                          ),
                          const SizedBox(height: 4),
                          Text(
                            'Siège: ${res.place}',
                            style: theme.textTheme.bodySmall?.copyWith(
                              color: cs.primary,
                              fontWeight: FontWeight.bold,
                            ),
                            textAlign: TextAlign.right,
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 16),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                  decoration: BoxDecoration(
                    color: isDark ? Colors.black26 : const Color(0xFFF8F9FA),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        'Total payé',
                        style: theme.textTheme.bodyMedium?.copyWith(
                          color: cs.onSurface.withOpacity(0.7),
                        ),
                      ),
                      Text(
                        '${res.prix.toInt()} FCFA',
                        style: theme.textTheme.titleMedium?.copyWith(
                          color: cs.primary,
                          fontWeight: FontWeight.w900,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}