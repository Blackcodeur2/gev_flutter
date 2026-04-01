import 'package:camer_trip/app/config/colors_config.dart';
import 'package:camer_trip/app/config/const_config.dart';
import 'package:camer_trip/app/config/theme_provider.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';

// ══════════════════════════════════════════════════════════════════════════════
// Données fictives (à remplacer par ton API)
// ══════════════════════════════════════════════════════════════════════════════
class _Destination {
  final String name;
  final String from;
  final String price;
  final String duration;
  final String emoji;
  const _Destination({
    required this.name,
    required this.from,
    required this.price,
    required this.duration,
    required this.emoji,
  });
}

class _Agence {
  final String name;
  final String route;
  final String rating;
  final Color color;
  final IconData icon;
  const _Agence({
    required this.name,
    required this.route,
    required this.rating,
    required this.color,
    required this.icon,
  });
}

class _PromoTrip {
  final String title;
  final String subtitle;
  final String badge;
  final List<Color> colors;
  const _PromoTrip({
    required this.title,
    required this.subtitle,
    required this.badge,
    required this.colors,
  });
}

// ══════════════════════════════════════════════════════════════════════════════
// HomePage
// ══════════════════════════════════════════════════════════════════════════════
class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage>
    with SingleTickerProviderStateMixin {
  late AnimationController _animController;
  late Animation<double> _fadeAnim;

  final List<_PromoTrip> _promos = const [
    _PromoTrip(
      title: 'Douala → Yaoundé',
      subtitle: 'Dès 2 500 FCFA · 3h de trajet',
      badge: '🔥 Populaire',
      colors: [Color(0xFF38A169), Color(0xFF48BB78)],
    ),
    _PromoTrip(
      title: 'Yaoundé → Bafoussam',
      subtitle: 'Dès 3 000 FCFA · 4h de trajet',
      badge: '⚡ Rapide',
      colors: [Color(0xFF2E3192), Color(0xFF4C51BF)],
    ),
    _PromoTrip(
      title: 'Douala → Limbé',
      subtitle: 'Dès 1 500 FCFA · 1h30 de trajet',
      badge: '🌊 Détente',
      colors: [Color(0xFF319795), Color(0xFF4FD1C5)],
    ),
  ];

  final List<_Destination> _destinations = const [
    _Destination(
      name: 'Yaoundé',
      from: 'Douala',
      price: '2 500',
      duration: '3h',
      emoji: '🏙️',
    ),
    _Destination(
      name: 'Bafoussam',
      from: 'Yaoundé',
      price: '3 000',
      duration: '4h',
      emoji: '🏔️',
    ),
    _Destination(
      name: 'Limbé',
      from: 'Douala',
      price: '1 500',
      duration: '1h30',
      emoji: '🌊',
    ),
    _Destination(
      name: 'Garoua',
      from: 'Yaoundé',
      price: '8 000',
      duration: '8h',
      emoji: '🌅',
    ),
    _Destination(
      name: 'Kribi',
      from: 'Douala',
      price: '2 000',
      duration: '2h',
      emoji: '🏖️',
    ),
  ];

  final List<_Agence> _agences = const [
    _Agence(
      name: 'General Express',
      route: 'Douala ↔ Yaoundé',
      rating: '4.8',
      color: AppColors.primaryGreen,
      icon: Icons.directions_bus_rounded,
    ),
    _Agence(
      name: 'Touristique Express',
      route: 'Toutes destinations',
      rating: '4.6',
      color: AppColors.primaryBlue,
      icon: Icons.airport_shuttle_rounded,
    ),
    _Agence(
      name: 'Finexs Voyages',
      route: 'Nord-Sud Cameroun',
      rating: '4.5',
      color: Color(0xFF319795),
      icon: Icons.directions_bus_filled_rounded,
    ),
    _Agence(
      name: 'Vatican Express',
      route: 'Ouest Cameroun',
      rating: '4.4',
      color: AppColors.primaryRed,
      icon: Icons.directions_bus_rounded,
    ),
  ];

  @override
  void initState() {
    super.initState();
    _animController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 700),
    );
    _fadeAnim = CurvedAnimation(
      parent: _animController,
      curve: Curves.easeOut,
    );
    _animController.forward();
  }

  @override
  void dispose() {
    _animController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;
    final cs = theme.colorScheme;

    return Scaffold(
      backgroundColor: cs.surface,
      body: FadeTransition(
        opacity: _fadeAnim,
        child: SafeArea(
          child: CustomScrollView(
            physics: const BouncingScrollPhysics(),
            slivers: [
              // ── AppBar ─────────────────────────────────────────────────
              SliverToBoxAdapter(child: _buildAppBar(context, isDark, cs)),

              // ── Barre de recherche ──────────────────────────────────────
              SliverToBoxAdapter(child: _buildSearchBar(context, cs, isDark)),

              // ── Carousel promos ────────────────────────────────────────
              SliverToBoxAdapter(child: _buildPromoCarousel(context, isDark)),

              // ── Catégories ─────────────────────────────────────────────
              SliverToBoxAdapter(
                child: _buildSectionTitle(context, '🚌 Catégories'),
              ),
              SliverToBoxAdapter(child: _buildCategories(context, cs)),

              // ── Destinations populaires ────────────────────────────────
              SliverToBoxAdapter(
                child: _buildSectionTitle(
                  context,
                  '📍 Destinations populaires',
                  action: 'Voir tout',
                ),
              ),
              SliverToBoxAdapter(
                child: _buildDestinations(context, isDark, cs),
              ),

              // ── Agences partenaires ────────────────────────────────────
              SliverToBoxAdapter(
                child: _buildSectionTitle(
                  context,
                  '🏢 Agences partenaires',
                  action: 'Voir tout',
                ),
              ),
              SliverToBoxAdapter(
                child: _buildAgences(context, isDark, cs),
              ),

              // ── Prochain voyage ────────────────────────────────────────
              SliverToBoxAdapter(
                child: _buildSectionTitle(context, '🎟️ Prochain voyage'),
              ),
              SliverToBoxAdapter(
                child: _buildProchainVoyage(context, isDark, cs),
              ),

              const SliverToBoxAdapter(child: SizedBox(height: 24)),
            ],
          ),
        ),
      ),
    );
  }

  // ─── AppBar ───────────────────────────────────────────────────────────────
  Widget _buildAppBar(
    BuildContext context,
    bool isDark,
    ColorScheme cs,
  ) {
    final themeProvider = context.watch<ThemeProvider>();

    return Padding(
      padding: const EdgeInsets.fromLTRB(20, 16, 16, 8),
      child: Row(
        children: [
          // Avatar + salutation
          Expanded(
            child: Row(
              children: [
                // Avatar
                Container(
                  width: 44,
                  height: 44,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    gradient: LinearGradient(
                      colors: isDark
                          ? [AppColors.darkGreen, AppColors.primaryGreen]
                          : [AppColors.primaryGreen, AppColors.lightGreen],
                    ),
                  ),
                  child: const Icon(
                    Icons.person_rounded,
                    color: Colors.white,
                    size: 24,
                  ),
                ),
                const SizedBox(width: 12),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Bonjour 👋',
                      style: Theme.of(context).textTheme.bodySmall?.copyWith(
                            color: cs.onSurface.withOpacity(0.55),
                          ),
                    ),
                    Text(
                      'Voyageur',
                      style: Theme.of(context).textTheme.titleMedium?.copyWith(
                            fontWeight: FontWeight.w700,
                            color: cs.onSurface,
                          ),
                    ),
                  ],
                ),
              ],
            ),
          ),

          // Toggle thème
          _ThemeToggleButton(
            isDark: isDark,
            onTap: () => themeProvider.toggleTheme(),
          ),

          const SizedBox(width: 4),

          // Notifications
          IconButton(
            onPressed: () {},
            icon: Stack(
              children: [
                Icon(
                  Icons.notifications_outlined,
                  color: cs.onSurface,
                  size: 26,
                ),
                Positioned(
                  top: 0,
                  right: 0,
                  child: Container(
                    width: 8,
                    height: 8,
                    decoration: const BoxDecoration(
                      color: AppColors.primaryRed,
                      shape: BoxShape.circle,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  // ─── Barre de recherche ───────────────────────────────────────────────────
  Widget _buildSearchBar(
    BuildContext context,
    ColorScheme cs,
    bool isDark,
  ) {
    return Padding(
      padding: const EdgeInsets.symmetric(
        horizontal: AppConstants.largePadding,
        vertical: 8,
      ),
      child: Container(
        height: 50,
        decoration: BoxDecoration(
          color: isDark
              ? AppColors.darkCard
              : AppColors.primaryGreen.withOpacity(0.06),
          borderRadius: BorderRadius.circular(AppConstants.defaultBorderRadius),
          border: Border.all(
            color: isDark
                ? AppColors.textDisabledDark.withOpacity(0.2)
                : AppColors.primaryGreen.withOpacity(0.2),
          ),
        ),
        child: Row(
          children: [
            const SizedBox(width: 14),
            Icon(
              Icons.search_rounded,
              color: cs.primary,
              size: 22,
            ),
            const SizedBox(width: 10),
            Expanded(
              child: Text(
                'Chercher une destination...',
                style: TextStyle(
                  color: cs.onSurface.withOpacity(0.4),
                  fontSize: 14,
                ),
              ),
            ),
            Container(
              margin: const EdgeInsets.all(6),
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
              decoration: BoxDecoration(
                color: cs.primary,
                borderRadius: BorderRadius.circular(8),
              ),
              child: const Text(
                'Rechercher',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 12,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  // ─── Carousel Promos ──────────────────────────────────────────────────────
  Widget _buildPromoCarousel(BuildContext context, bool isDark) {
    return Padding(
      padding: const EdgeInsets.only(top: 8, bottom: 4),
      child: CarouselSlider(
        options: CarouselOptions(
          height: 160,
          autoPlay: true,
          autoPlayInterval: const Duration(seconds: 4),
          autoPlayCurve: Curves.easeInOut,
          enlargeCenterPage: true,
          viewportFraction: 0.88,
        ),
        items: _promos.map((promo) {
          return _PromoCard(promo: promo);
        }).toList(),
      ),
    );
  }

  // ─── Catégories ───────────────────────────────────────────────────────────
  Widget _buildCategories(BuildContext context, ColorScheme cs) {
    final categories = [
      {'icon': Icons.directions_bus_rounded, 'label': 'Bus'},
      {'icon': Icons.airline_seat_recline_extra_rounded, 'label': 'VIP'},
      {'icon': Icons.local_taxi_rounded, 'label': 'Taxi'},
      {'icon': Icons.train_rounded, 'label': 'Train'},
      {'icon': Icons.more_horiz_rounded, 'label': 'Plus'},
    ];

    return SizedBox(
      height: 90,
      child: ListView.separated(
        padding: const EdgeInsets.symmetric(
          horizontal: AppConstants.largePadding,
        ),
        scrollDirection: Axis.horizontal,
        itemCount: categories.length,
        separatorBuilder: (_, __) => const SizedBox(width: 14),
        itemBuilder: (_, i) {
          final cat = categories[i];
          return _CategoryItem(
            icon: cat['icon'] as IconData,
            label: cat['label'] as String,
            cs: cs,
          );
        },
      ),
    );
  }

  // ─── Destinations ─────────────────────────────────────────────────────────
  Widget _buildDestinations(
    BuildContext context,
    bool isDark,
    ColorScheme cs,
  ) {
    return SizedBox(
      height: 150,
      child: ListView.separated(
        padding: const EdgeInsets.symmetric(
          horizontal: AppConstants.largePadding,
        ),
        scrollDirection: Axis.horizontal,
        itemCount: _destinations.length,
        separatorBuilder: (_, __) => const SizedBox(width: 14),
        itemBuilder: (_, i) {
          return _DestinationCard(dest: _destinations[i], isDark: isDark, cs: cs);
        },
      ),
    );
  }

  // ─── Agences ──────────────────────────────────────────────────────────────
  Widget _buildAgences(BuildContext context, bool isDark, ColorScheme cs) {
    return Padding(
      padding: const EdgeInsets.symmetric(
        horizontal: AppConstants.largePadding,
      ),
      child: Column(
        children: _agences.map((a) {
          return _AgenceListItem(agence: a, isDark: isDark, cs: cs);
        }).toList(),
      ),
    );
  }

  // ─── Prochain Voyage ──────────────────────────────────────────────────────
  Widget _buildProchainVoyage(
    BuildContext context,
    bool isDark,
    ColorScheme cs,
  ) {
    return Padding(
      padding: const EdgeInsets.symmetric(
        horizontal: AppConstants.largePadding,
      ),
      child: Container(
        padding: const EdgeInsets.all(18),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(AppConstants.largeBorderRadius),
          gradient: LinearGradient(
            colors: isDark
                ? [const Color(0xFF1A2E25), AppColors.darkGreen]
                : [AppColors.primaryGreen, AppColors.lightGreen],
          ),
          boxShadow: [
            BoxShadow(
              color: AppColors.primaryGreen.withOpacity(0.3),
              blurRadius: 16,
              offset: const Offset(0, 6),
            )
          ],
        ),
        child: Row(
          children: [
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: Colors.white.withOpacity(0.2),
                borderRadius: BorderRadius.circular(12),
              ),
              child: const Icon(
                Icons.confirmation_number_rounded,
                color: Colors.white,
                size: 28,
              ),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'Douala → Yaoundé',
                    style: TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.w700,
                      fontSize: 15,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    '📅 Demain · 07h00  •  🚌 General Express',
                    style: TextStyle(
                      color: Colors.white.withOpacity(0.85),
                      fontSize: 12,
                    ),
                  ),
                ],
              ),
            ),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(10),
              ),
              child: Text(
                'Voir',
                style: TextStyle(
                  color: isDark ? AppColors.darkGreen : AppColors.primaryGreen,
                  fontWeight: FontWeight.w700,
                  fontSize: 13,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  // ─── Section title ────────────────────────────────────────────────────────
  Widget _buildSectionTitle(
    BuildContext context,
    String title, {
    String? action,
  }) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(
        AppConstants.largePadding,
        20,
        AppConstants.largePadding,
        10,
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            title,
            style: Theme.of(context).textTheme.titleMedium?.copyWith(
                  fontWeight: FontWeight.w700,
                ),
          ),
          if (action != null)
            GestureDetector(
              onTap: () {},
              child: Text(
                action,
                style: TextStyle(
                  color: Theme.of(context).colorScheme.primary,
                  fontSize: 13,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
        ],
      ),
    );
  }
}

// ══════════════════════════════════════════════════════════════════════════════
// Bouton Toggle Thème
// ══════════════════════════════════════════════════════════════════════════════
class _ThemeToggleButton extends StatelessWidget {
  final bool isDark;
  final VoidCallback onTap;
  const _ThemeToggleButton({required this.isDark, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 300),
        width: 54,
        height: 30,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(15),
          color: isDark ? AppColors.primaryGreen : Colors.grey.shade300,
        ),
        child: Stack(
          children: [
            AnimatedAlign(
              duration: const Duration(milliseconds: 300),
              curve: Curves.easeInOut,
              alignment:
                  isDark ? Alignment.centerRight : Alignment.centerLeft,
              child: Padding(
                padding: const EdgeInsets.all(3),
                child: Container(
                  width: 24,
                  height: 24,
                  decoration: const BoxDecoration(
                    color: Colors.white,
                    shape: BoxShape.circle,
                  ),
                  child: Icon(
                    isDark ? Icons.dark_mode_rounded : Icons.light_mode_rounded,
                    size: 14,
                    color: isDark
                        ? AppColors.primaryGreen
                        : Colors.orange.shade600,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// ══════════════════════════════════════════════════════════════════════════════
// Carte Promo Carousel
// ══════════════════════════════════════════════════════════════════════════════
class _PromoCard extends StatelessWidget {
  final _PromoTrip promo;
  const _PromoCard({required this.promo});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(vertical: 6),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: promo.colors,
        ),
        borderRadius: BorderRadius.circular(AppConstants.largeBorderRadius),
        boxShadow: [
          BoxShadow(
            color: promo.colors.first.withOpacity(0.35),
            blurRadius: 12,
            offset: const Offset(0, 5),
          ),
        ],
      ),
      child: Stack(
        children: [
          // Cercle déco
          Positioned(
            right: -20,
            bottom: -20,
            child: Container(
              width: 100,
              height: 100,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: Colors.white.withOpacity(0.1),
              ),
            ),
          ),
          Positioned(
            right: 30,
            top: -10,
            child: Container(
              width: 60,
              height: 60,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: Colors.white.withOpacity(0.08),
              ),
            ),
          ),

          Padding(
            padding: const EdgeInsets.all(20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                // Badge
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 10,
                    vertical: 4,
                  ),
                  decoration: BoxDecoration(
                    color: Colors.white.withOpacity(0.2),
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: Text(
                    promo.badge,
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 11,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),

                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      promo.title,
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 18,
                        fontWeight: FontWeight.w800,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      promo.subtitle,
                      style: TextStyle(
                        color: Colors.white.withOpacity(0.85),
                        fontSize: 13,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

// ══════════════════════════════════════════════════════════════════════════════
// Catégorie Item
// ══════════════════════════════════════════════════════════════════════════════
class _CategoryItem extends StatelessWidget {
  final IconData icon;
  final String label;
  final ColorScheme cs;
  const _CategoryItem({
    required this.icon,
    required this.label,
    required this.cs,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Container(
          width: 54,
          height: 54,
          decoration: BoxDecoration(
            color: cs.primary.withOpacity(0.12),
            borderRadius: BorderRadius.circular(14),
          ),
          child: Icon(icon, color: cs.primary, size: 26),
        ),
        const SizedBox(height: 6),
        Text(
          label,
          style: TextStyle(
            fontSize: 11,
            fontWeight: FontWeight.w600,
            color: cs.onSurface.withOpacity(0.75),
          ),
        ),
      ],
    );
  }
}

// ══════════════════════════════════════════════════════════════════════════════
// Destination Card
// ══════════════════════════════════════════════════════════════════════════════
class _DestinationCard extends StatelessWidget {
  final _Destination dest;
  final bool isDark;
  final ColorScheme cs;
  const _DestinationCard({
    required this.dest,
    required this.isDark,
    required this.cs,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 130,
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: isDark ? AppColors.darkCard : AppColors.lightCard,
        borderRadius: BorderRadius.circular(AppConstants.defaultBorderRadius),
        boxShadow: [
          BoxShadow(
            color: isDark
                ? AppColors.shadowDark
                : AppColors.shadow,
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
        border: Border.all(
          color: isDark
              ? AppColors.textDisabledDark.withOpacity(0.12)
              : AppColors.primaryGreen.withOpacity(0.1),
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(dest.emoji, style: const TextStyle(fontSize: 28)),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                dest.name,
                style: TextStyle(
                  fontWeight: FontWeight.w700,
                  fontSize: 14,
                  color: cs.onSurface,
                ),
              ),
              Text(
                'depuis ${dest.from}',
                style: TextStyle(
                  fontSize: 10,
                  color: cs.onSurface.withOpacity(0.5),
                ),
              ),
            ],
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                '${dest.price} F',
                style: TextStyle(
                  fontWeight: FontWeight.w800,
                  fontSize: 13,
                  color: cs.primary,
                ),
              ),
              Text(
                dest.duration,
                style: TextStyle(
                  fontSize: 10,
                  color: cs.onSurface.withOpacity(0.5),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

// ══════════════════════════════════════════════════════════════════════════════
// Agence List Item
// ══════════════════════════════════════════════════════════════════════════════
class _AgenceListItem extends StatelessWidget {
  final _Agence agence;
  final bool isDark;
  final ColorScheme cs;
  const _AgenceListItem({
    required this.agence,
    required this.isDark,
    required this.cs,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 10),
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
      decoration: BoxDecoration(
        color: isDark ? AppColors.darkCard : AppColors.lightCard,
        borderRadius: BorderRadius.circular(AppConstants.defaultBorderRadius),
        boxShadow: [
          BoxShadow(
            color: isDark ? AppColors.shadowDark : AppColors.shadow,
            blurRadius: 8,
            offset: const Offset(0, 3),
          ),
        ],
        border: Border.all(
          color: isDark
              ? AppColors.textDisabledDark.withOpacity(0.12)
              : AppColors.primaryGreen.withOpacity(0.1),
        ),
      ),
      child: Row(
        children: [
          // Icône agence
          Container(
            width: 46,
            height: 46,
            decoration: BoxDecoration(
              color: agence.color.withOpacity(0.15),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Icon(agence.icon, color: agence.color, size: 22),
          ),
          const SizedBox(width: 14),

          // Infos
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  agence.name,
                  style: TextStyle(
                    fontWeight: FontWeight.w700,
                    fontSize: 14,
                    color: cs.onSurface,
                  ),
                ),
                const SizedBox(height: 2),
                Text(
                  agence.route,
                  style: TextStyle(
                    fontSize: 12,
                    color: cs.onSurface.withOpacity(0.5),
                  ),
                ),
              ],
            ),
          ),

          // Rating
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
            decoration: BoxDecoration(
              color: AppColors.primaryGreen.withOpacity(0.12),
              borderRadius: BorderRadius.circular(8),
            ),
            child: Row(
              children: [
                const Icon(
                  Icons.star_rounded,
                  color: AppColors.primaryGreen,
                  size: 14,
                ),
                const SizedBox(width: 3),
                Text(
                  agence.rating,
                  style: const TextStyle(
                    fontSize: 12,
                    fontWeight: FontWeight.w700,
                    color: AppColors.primaryGreen,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
