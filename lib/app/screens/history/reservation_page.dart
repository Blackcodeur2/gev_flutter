import 'package:camer_trip/app/models/reservation_model.dart';
import 'package:camer_trip/app/services/providers.dart';
import 'package:camer_trip/app/shared/others/app_bar.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:camer_trip/l10n/app_localizations.dart';

class ReservationsPages extends ConsumerStatefulWidget {
  const ReservationsPages({super.key});

  @override
  ConsumerState<ReservationsPages> createState() => _ReservationsPagesState();
}

class _ReservationsPagesState extends ConsumerState<ReservationsPages>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;

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
    final reservationsAsync = ref.watch(myReservationsProvider);
    final localizations = AppLocalizations.of(context);

    return Scaffold(
      backgroundColor: colorScheme.surface,
      body: SafeArea(
        child: Column(
          children: [
            MyAppBar(title: localizations?.myReservationsTitle ?? 'Mes Réservations'),
            const SizedBox(height: 16),
            TabBar(
              controller: _tabController,
              labelColor: colorScheme.primary,
              unselectedLabelColor: colorScheme.onSurface.withOpacity(0.5),
              indicatorColor: colorScheme.primary,
              indicatorWeight: 3,
              labelStyle: const TextStyle(fontWeight: FontWeight.bold),
              tabs: [
                Tab(text: localizations?.tabValidated ?? 'Validées'),
                Tab(text: localizations?.tabPending ?? 'En attente'),
                Tab(text: localizations?.tabCancelled ?? 'Annulées'),
              ],
            ),
            Expanded(
              child: reservationsAsync.when(
                data: (reservations) => TabBarView(
                  controller: _tabController,
                  children: [
                    _buildReservationList(reservations, 'validee'),
                    _buildReservationList(reservations, 'en attente'),
                    _buildReservationList(reservations, 'annulee'),
                  ],
                ),
                loading: () => const Center(child: CircularProgressIndicator()),
                error: (e, s) => Center(child: Text('${AppLocalizations.of(context)?.errorPrefix2 ?? 'Erreur: '}$e')),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildReservationList(List<ReservationModel> all, String statusFilter) {
    final filtered = all.where((element) => element.status == statusFilter).toList();

    if (filtered.isEmpty) {
      return RefreshIndicator(
        onRefresh: () => ref.refresh(myReservationsProvider.future),
        child: SingleChildScrollView(
          physics: const AlwaysScrollableScrollPhysics(),
          child: SizedBox(
            height: MediaQuery.of(context).size.height * 0.6,
            child: Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(Icons.history_rounded, size: 64, color: Theme.of(context).colorScheme.onSurface.withOpacity(0.1)),
                  const SizedBox(height: 16),
                  Text(
                    statusFilter == 'validee'
                      ? (AppLocalizations.of(context)?.noReservationValidated ?? 'Aucune réservation validée')
                      : statusFilter == 'annulee'
                        ? (AppLocalizations.of(context)?.noReservationCancelled ?? 'Aucune réservation annulée')
                        : (AppLocalizations.of(context)?.noReservationPending ?? 'Aucune réservation en attente'),
                    style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                      color: Theme.of(context).colorScheme.onSurface.withOpacity(0.6),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      );
    }

    return RefreshIndicator(
      onRefresh: () => ref.refresh(myReservationsProvider.future),
      child: ListView.builder(
        padding: const EdgeInsets.only(left: 16, right: 16, top: 16, bottom: 130),
        physics: const AlwaysScrollableScrollPhysics(),
        itemCount: filtered.length,
        itemBuilder: (context, index) {
          final res = filtered[index];
          return _buildReservationCard(res);
        },
      ),
    );
  }

  Widget _buildReservationCard(ReservationModel res) {
    final theme = Theme.of(context);
    final cs = theme.colorScheme;
    final isDark = theme.brightness == Brightness.dark;

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
      margin: const EdgeInsets.only(bottom: 16.0),
      decoration: BoxDecoration(
        color: isDark ? cs.surfaceContainerHigh : Colors.white,
        borderRadius: BorderRadius.circular(24),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Material(
        color: Colors.transparent,
        borderRadius: BorderRadius.circular(24),
        child: InkWell(
          onTap: () => context.pushNamed('reservationDetails', extra: res),
          borderRadius: BorderRadius.circular(24),
          child: Padding(
            padding: const EdgeInsets.all(20.0),
            child: Column(
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
                          child: Icon(Icons.directions_bus_rounded, color: cs.primary, size: 20),
                        ),
                        const SizedBox(width: 12),
                        Text(
                          res.agenceName ?? 'Agence',
                          style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
                        ),
                      ],
                    ),
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                      decoration: BoxDecoration(
                        color: statusColor.withOpacity(0.1),
                        borderRadius: BorderRadius.circular(30),
                      ),
                      child: Text(
                        statusLabel,
                        style: TextStyle(color: statusColor, fontWeight: FontWeight.bold, fontSize: 12),
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
                          Text(res.route?.split(' ↔ ').first ?? '...', style: const TextStyle(fontWeight: FontWeight.bold)),
                          const SizedBox(height: 4),
                          Text('${res.date} • ${res.time}', style: const TextStyle(color: Colors.grey, fontSize: 12)),
                        ],
                      ),
                    ),
                    Icon(Icons.arrow_forward_rounded, color: cs.primary.withOpacity(0.3), size: 20),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.end,
                        children: [
                          Text(res.route?.split(' ↔ ').last ?? '...', style: const TextStyle(fontWeight: FontWeight.bold)),
                          const SizedBox(height: 4),
                          Text(localizations?.seatLabel(res.place.toString()) ?? 'Siège #${res.place}', style: TextStyle(color: cs.primary, fontWeight: FontWeight.bold, fontSize: 12)),
                        ],
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 20),
                Container(
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: cs.primary.withOpacity(0.05),
                    borderRadius: BorderRadius.circular(16),
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text('Référence: ${res.numReservation}', style: const TextStyle(fontSize: 12, fontWeight: FontWeight.w500)),
                      Text(
                        '${res.prix.toInt()} FCFA',
                        style: TextStyle(color: cs.primary, fontWeight: FontWeight.w900, fontSize: 16),
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