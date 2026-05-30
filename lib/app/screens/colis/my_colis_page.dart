import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';
import '../../services/providers.dart';
import '../../models/colis_model.dart';
import '../../shared/others/app_bar.dart';
import '../../utils/api_error_handler.dart';
import 'package:camer_trip/l10n/app_localizations.dart';

class MyColisPage extends ConsumerStatefulWidget {
  const MyColisPage({super.key});

  @override
  ConsumerState<MyColisPage> createState() => _MyColisPageState();
}

class _MyColisPageState extends ConsumerState<MyColisPage> with SingleTickerProviderStateMixin {
  late TabController _tabController;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
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
    final colisAsync = ref.watch(myColisProvider);
    final userAsync = ref.watch(currentUserProvider);
    final localizations = AppLocalizations.of(context);

    return Scaffold(
      backgroundColor: cs.surface,
      body: SafeArea(
        child: Column(
          children: [
            MyAppBar(title: localizations?.myColisTitle ?? 'Mes Colis'),
            Container(
              margin: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
              decoration: BoxDecoration(
                color: cs.surfaceContainerHigh,
                borderRadius: BorderRadius.circular(16),
              ),
              child: TabBar(
                controller: _tabController,
                indicator: BoxDecoration(
                  borderRadius: BorderRadius.circular(12),
                  color: cs.primary,
                ),
                indicatorSize: TabBarIndicatorSize.tab,
                labelColor: Colors.white,
                unselectedLabelColor: cs.onSurface.withOpacity(0.6),
                labelStyle: const TextStyle(fontWeight: FontWeight.bold),
                tabs: [
                  Tab(text: localizations?.tabSent ?? 'Expédiés'),
                  Tab(text: localizations?.tabToReceive ?? 'À recevoir'),
                ],
              ),
            ),
            Expanded(
              child: userAsync.when(
                data: (user) {
                  if (user == null) return Center(child: Text(localizations?.pleaseLogin ?? 'Veuillez vous connecter'));
                  
                  return colisAsync.when(
                    data: (allColis) {
                      final sentColis = allColis.where((ColisModel c) => 
                        c.userId == user.id || c.telExpediteur == user.telephone
                      ).toList();
                      
                      final receivedColis = allColis.where((ColisModel c) => 
                        c.telDestinataire == user.telephone && c.userId != user.id
                      ).toList();


                      return TabBarView(
                        controller: _tabController,
                        children: [
                          _buildColisList(sentColis, cs, true),
                          _buildColisList(receivedColis, cs, false),
                        ],
                      );
                    },
                    loading: () => const Center(child: CircularProgressIndicator()),
                    error: (e, s) => Center(
                      child: Text(
                        '${AppLocalizations.of(context)?.errorPrefix2 ?? 'Erreur: '}${ApiErrorHandler.userMessage(
                          e,
                          fallback: AppLocalizations.of(context)?.unknownError ?? 'Erreur inconnue',
                        )}',
                      ),
                    ),
                  );
                },
                loading: () => const Center(child: CircularProgressIndicator()),
                error: (e, s) => Center(
                  child: Text(
                    '${AppLocalizations.of(context)?.errorPrefix2 ?? 'Erreur: '}${ApiErrorHandler.userMessage(
                      e,
                      fallback: AppLocalizations.of(context)?.unknownError ?? 'Erreur inconnue',
                    )}',
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildColisList(List<ColisModel> list, ColorScheme cs, bool isSent) {
    if (list.isEmpty) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.inventory_2_outlined, size: 64, color: cs.onSurface.withOpacity(0.2)),
            const SizedBox(height: 16),
            Text(
              isSent
                ? (AppLocalizations.of(context)?.noColisSent ?? 'Aucun colis envoyé')
                : (AppLocalizations.of(context)?.noColisToReceive ?? 'Aucun colis à recevoir'),
              style: TextStyle(color: cs.onSurface.withOpacity(0.5), fontSize: 16),
            ),
          ],
        ),
      );
    }

    return ListView.builder(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
      itemCount: list.length,
      itemBuilder: (context, index) {
        final colis = list[index];
        return _buildColisCard(colis, cs, isSent);
      },
    );
  }

  Widget _buildColisCard(ColisModel colis, ColorScheme cs, bool isSent) {
    final dateFormat = DateFormat('dd MMM yyyy');
    
    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      decoration: BoxDecoration(
        color: cs.surfaceContainerHigh,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: cs.primary.withOpacity(0.05)),
      ),
      child: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(16),
            child: Row(
              children: [
                Container(
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: cs.primary.withOpacity(0.1),
                    shape: BoxShape.circle,
                  ),
                  child: Icon(Icons.local_shipping_rounded, color: cs.primary, size: 24),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        colis.nomColis,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
                      ),
                      Text(
                        AppLocalizations.of(context)?.colisRef(colis.id) ?? 'Réf: #C-${colis.id}',
                        style: TextStyle(color: cs.onSurface.withOpacity(0.5), fontSize: 12),
                      ),
                    ],
                  ),
                ),
                _buildStatusBadge(colis.statut, cs),
              ],
            ),
          ),
          const Divider(height: 1),
          Padding(
            padding: const EdgeInsets.all(16),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                _buildInfoColumn(AppLocalizations.of(context)?.colisOrigin ?? 'Origine', colis.villeSource ?? '...', cs),
                Icon(Icons.arrow_forward, size: 16, color: cs.primary.withOpacity(0.3)),
                _buildInfoColumn(AppLocalizations.of(context)?.colisDestination ?? 'Destination', colis.destination, cs),
              ],
            ),
          ),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
            decoration: BoxDecoration(
              color: cs.primary.withOpacity(0.05),
              borderRadius: const BorderRadius.only(
                bottomLeft: Radius.circular(20),
                bottomRight: Radius.circular(20),
              ),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Expanded(
                  child: Text(
                    isSent
                      ? (AppLocalizations.of(context)?.colisRecipient(colis.nomDestinataire) ?? 'Destinataire: ${colis.nomDestinataire}')
                      : (AppLocalizations.of(context)?.colisSender(colis.nomExpediteur) ?? 'Expéditeur: ${colis.nomExpediteur}'),
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                    style: const TextStyle(fontSize: 12, fontWeight: FontWeight.w500),
                  ),
                ),
                const SizedBox(width: 12),
                Text(
                  dateFormat.format(colis.createdAt),
                  style: TextStyle(fontSize: 11, color: cs.onSurface.withOpacity(0.6)),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildInfoColumn(String label, String value, ColorScheme cs) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(label, style: TextStyle(color: cs.onSurface.withOpacity(0.5), fontSize: 10)),
        Text(value, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 14)),
      ],
    );
  }

  Widget _buildStatusBadge(String status, ColorScheme cs) {
    Color color = Colors.orange;
    String label = AppLocalizations.of(context)?.colisStatusPending ?? 'En attente';
    
    if (status == 'retire') {
      color = Colors.green;
      label = AppLocalizations.of(context)?.colisStatusDelivered ?? 'Livré';
    } else if (status == 'en cours') {
      color = Colors.blue;
      label = AppLocalizations.of(context)?.colisStatusInTransit ?? 'En transit';
    }

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(
        color: color.withOpacity(0.1),
        borderRadius: BorderRadius.circular(8),
      ),
      child: Text(
        label.toUpperCase(),
        style: TextStyle(color: color, fontSize: 10, fontWeight: FontWeight.bold),
      ),
    );
  }
}
