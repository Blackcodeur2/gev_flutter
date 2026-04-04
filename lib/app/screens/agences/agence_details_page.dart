import 'package:flutter/material.dart';
import 'package:camer_trip/app/models/ag_model.dart';

class AgenceDetailsPage extends StatefulWidget {
  final Agence agence;
  const AgenceDetailsPage({super.key, required this.agence});

  @override
  State<AgenceDetailsPage> createState() => _AgenceDetailsPageState();
}

class _AgenceDetailsPageState extends State<AgenceDetailsPage> with SingleTickerProviderStateMixin {
  late TabController _tabController;

  final List<Map<String, String>> dummyGares = [
    {'ville': 'Douala', 'nom': 'Gare Akwa', 'adresse': 'Bld de la Liberté, Akwa'},
    {'ville': 'Yaoundé', 'nom': 'Gare Mvan', 'adresse': 'Carrefour Mvan'},
    {'ville': 'Bafoussam', 'nom': 'Gare Routière', 'adresse': 'Marché A'},
    {'ville': 'Kribi', 'nom': 'Gare Principale', 'adresse': 'Centre Ville'},
  ];

  final List<Map<String, dynamic>> dummyVoyages = [
    {'route': 'Douala → Yaoundé', 'date': 'Aujourd\'hui', 'time': '14:00', 'price': '2 500 FCFA', 'places': 12},
    {'route': 'Yaoundé → Douala', 'date': 'Aujourd\'hui', 'time': '16:30', 'price': '2 500 FCFA', 'places': 4},
    {'route': 'Douala → Kribi', 'date': 'Demain', 'time': '08:00', 'price': '2 000 FCFA', 'places': 32},
  ];

  final List<Map<String, String>> dummyTrajets = [
    {'depart': 'Douala', 'arrivee': 'Yaoundé', 'prix': '2 500 FCFA', 'duree': '3h 30m'},
    {'depart': 'Yaoundé', 'arrivee': 'Bafoussam', 'prix': '3 000 FCFA', 'duree': '5h 00m'},
    {'depart': 'Douala', 'arrivee': 'Kribi', 'prix': '2 000 FCFA', 'duree': '2h 30m'},
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
    final cs = theme.colorScheme;
    
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
                    Container(
                      color: widget.agence.color.withOpacity(0.8),
                    ),
                    Center(
                      child: Icon(
                        widget.agence.icon, 
                        size: 100, 
                        color: Colors.white.withOpacity(0.2)
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
                  labelColor: cs.primary,
                  unselectedLabelColor: cs.onSurface.withOpacity(0.5),
                  indicatorColor: widget.agence.color,
                  indicatorWeight: 3,
                  labelStyle: const TextStyle(fontWeight: FontWeight.bold),
                  tabs: const [
                    Tab(text: "Gares"),
                    Tab(text: "Prochains"),
                    Tab(text: "Trajets"),
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
    return ListView.builder(
      padding: const EdgeInsets.all(16),
      itemCount: dummyGares.length,
      itemBuilder: (context, index) {
        final gare = dummyGares[index];
        return Card(
          margin: const EdgeInsets.only(bottom: 12),
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
          elevation: 2,
          shadowColor: cs.shadow.withOpacity(0.1),
          child: Padding(
            padding: const EdgeInsets.symmetric(vertical: 8),
            child: ListTile(
              leading: CircleAvatar(
                backgroundColor: widget.agence.color.withOpacity(0.15),
                child: Icon(Icons.location_city, color: widget.agence.color),
              ),
              title: Text(gare['ville']!, style: const TextStyle(fontWeight: FontWeight.bold)),
              subtitle: Text('${gare['nom']} - ${gare['adresse']}'),
              trailing: IconButton(
                icon: Icon(Icons.map, color: cs.primary),
                onPressed: () {}, // Peut rediriger vers Maps plus tard
              ),
            ),
          ),
        );
      },
    );
  }

  Widget _buildVoyagesList(ColorScheme cs) {
    return ListView.builder(
      padding: const EdgeInsets.all(16),
      itemCount: dummyVoyages.length,
      itemBuilder: (context, index) {
        final voy = dummyVoyages[index];
        return Card(
          margin: const EdgeInsets.only(bottom: 16),
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
          elevation: 3,
          shadowColor: cs.shadow.withOpacity(0.2),
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Expanded(
                      child: Text(voy['route'], style: const TextStyle(fontWeight: FontWeight.w900, fontSize: 16)),
                    ),
                    const SizedBox(width: 8),
                    Text(voy['price'], style: TextStyle(fontWeight: FontWeight.bold, color: widget.agence.color, fontSize: 16)),
                  ],
                ),
                const SizedBox(height: 12),
                Row(
                  children: [
                    Icon(Icons.access_time, size: 18, color: cs.onSurface.withOpacity(0.6)),
                    const SizedBox(width: 6),
                    Expanded(
                      child: Text('${voy['date']} à ${voy['time']}', style: TextStyle(color: cs.onSurface.withOpacity(0.8), fontWeight: FontWeight.w500)),
                    ),
                  ],
                ),
                const SizedBox(height: 16),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Expanded(
                      child: Align(
                        alignment: Alignment.centerLeft,
                        child: Container(
                          padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
                          decoration: BoxDecoration(
                            color: Colors.orange.withOpacity(0.1),
                            borderRadius: BorderRadius.circular(8),
                          ),
                          child: Text('${voy['places']} places restantes', 
                            style: const TextStyle(color: Colors.deepOrange, fontWeight: FontWeight.bold, fontSize: 12),
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(width: 8),
                    ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        minimumSize: Size.zero, 
                        backgroundColor: widget.agence.color,
                        foregroundColor: Colors.white,
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12)
                      ),
                      onPressed: () {},
                      child: const Text('Réserver', style: TextStyle(fontWeight: FontWeight.bold)),
                    )
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
    return ListView.builder(
      padding: const EdgeInsets.all(16),
      itemCount: dummyTrajets.length,
      itemBuilder: (context, index) {
        final traj = dummyTrajets[index];
        return Card(
          margin: const EdgeInsets.only(bottom: 12),
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
          elevation: 2,
          shadowColor: cs.shadow.withOpacity(0.1),
          child: Padding(
            padding: const EdgeInsets.symmetric(vertical: 8),
            child: ListTile(
              leading: Container(
                padding: const EdgeInsets.all(10),
                decoration: BoxDecoration(
                  color: widget.agence.color.withOpacity(0.1),
                  shape: BoxShape.circle,
                ),
                child: Icon(Icons.route, color: widget.agence.color),
              ),
              title: Text('${traj['depart']} ↔ ${traj['arrivee']}', style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 15)),
              subtitle: Padding(
                padding: const EdgeInsets.only(top: 4.0),
                child: Text('Durée estimée: ${traj['duree']}'),
              ),
              trailing: Text(traj['prix']!, style: TextStyle(fontWeight: FontWeight.w900, color: widget.agence.color, fontSize: 15)),
            ),
          ),
        );
      },
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
