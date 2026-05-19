import 'package:camer_trip/app/config/colors_config.dart';
import 'package:camer_trip/app/config/const_config.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:camer_trip/l10n/app_localizations.dart';
import 'package:provider/provider.dart';
import 'package:camer_trip/app/config/locale_provider.dart';

class OnboardingScreen extends StatefulWidget {
  const OnboardingScreen({super.key});

  @override
  State<OnboardingScreen> createState() => _OnboardingScreenState();
}

class _OnboardingScreenState extends State<OnboardingScreen> {
  final PageController _controller = PageController();
  int currentPage = 0;



  void finishOnboarding() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool('isFirstOpen', false);

    if (!mounted) return;
    context.go('/main');
  }

  void nextPage(int totalPages) {
    if (currentPage == totalPages - 1) {
      finishOnboarding();
    } else {
      _controller.nextPage(
        duration: const Duration(milliseconds: 400),
        curve: Curves.easeInOut,
      );
    }
  }

  Widget buildDot(int index) {
    return AnimatedContainer(
      duration: const Duration(milliseconds: 300),
      margin: const EdgeInsets.symmetric(horizontal: 4),
      width: currentPage == index ? 20 : 8,
      height: 8,
      decoration: BoxDecoration(
        color: currentPage == index
            ? AppColors.primaryGreen
            : AppColors.lightGreen,
        borderRadius: BorderRadius.circular(10),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final localizations = AppLocalizations.of(context);
    final localeProvider = context.watch<LocaleProvider>();
    final isEnglish = localeProvider.locale.languageCode == 'en';

    final pages = [
      {
        "title": localizations?.onboardingTitle1 ?? "Bienvenue sur CamerTrip",
        "desc": localizations?.onboardingDesc1 ?? "Découvre les meilleurs endroits au Cameroun",
        "image": "images/ico.png",
      },
      {
        "title": localizations?.onboardingTitle2 ?? "Voyage facilement",
        "desc": localizations?.onboardingDesc2 ?? "Planifie tes déplacements en quelques clics",
        "image": "images/ico.png",
      },
      {
        "title": localizations?.onboardingTitle3 ?? "Commence maintenant",
        "desc": localizations?.onboardingDesc3 ?? "Une nouvelle aventure t’attend 🚀",
        "image": "images/ico.png",
      },
    ];

    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.surface,
      body: SafeArea(
        child: Column(
          children: [
            // 🔹 Header (Language Toggle & Skip button)
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  TextButton.icon(
                    onPressed: () {
                      if (isEnglish) {
                        localeProvider.setLocale(const Locale('fr'));
                      } else {
                        localeProvider.setLocale(const Locale('en'));
                      }
                    },
                    icon: const Icon(Icons.language_rounded, size: 20),
                    label: Text(
                      isEnglish ? 'EN' : 'FR',
                      style: const TextStyle(fontWeight: FontWeight.bold),
                    ),
                    style: TextButton.styleFrom(
                      foregroundColor: Theme.of(context).colorScheme.primary,
                    ),
                  ),
                  TextButton(
                    onPressed: finishOnboarding,
                    child: Text(localizations?.skip ?? "Passer"),
                  ),
                ],
              ),
            ),

            // 🔹 Pages
            Expanded(
              child: PageView.builder(
                controller: _controller,
                itemCount: pages.length,
                onPageChanged: (index) {
                  setState(() => currentPage = index);
                },
                itemBuilder: (context, index) {
                  return Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 24),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        // Image
                        Image.asset(
                          pages[index]['image']!,
                          height: 250,
                        ),

                        const SizedBox(height: 40),

                        // Title
                        Text(
                          pages[index]['title']!,
                          style: Theme.of(context)
                              .textTheme
                              .headlineMedium
                              ?.copyWith(
                                fontWeight: FontWeight.bold,
                                color: AppColors.primaryGreen,
                              ),
                          textAlign: TextAlign.center,
                        ),

                        const SizedBox(height: 16),

                        // Description
                        Text(
                          pages[index]['desc']!,
                          style: Theme.of(context)
                              .textTheme
                              .bodyMedium
                              ?.copyWith(
                                color: Colors.grey[600],
                              ),
                          textAlign: TextAlign.center,
                        ),
                      ],
                    ),
                  );
                },
              ),
            ),

            // 🔹 Dots indicator
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: List.generate(
                pages.length,
                (index) => buildDot(index),
              ),
            ),

            const SizedBox(height: 30),

            // 🔹 Button
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 24),
              child: SizedBox(
                width: double.infinity,
                height: 55,
                child: ElevatedButton(
                  onPressed: () => nextPage(pages.length),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColors.primaryGreen,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(15),
                    ),
                  ),
                  child: Text(
                    currentPage == pages.length - 1
                        ? (localizations?.start ?? "Commencer")
                        : (localizations?.next ?? "Suivant"),
                    style: const TextStyle(fontSize: 16),
                  ),
                ),
              ),
            ),

            const SizedBox(height: 30),
          ],
        ),
      ),
    );
  }
}