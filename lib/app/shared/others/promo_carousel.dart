import 'package:camer_trip/app/models/promo_trip_model.dart';
import 'package:camer_trip/app/shared/cards/promo_card.dart';
import 'package:carousel_slider/carousel_options.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';

class PromoCarousel extends StatelessWidget {
  final List<PromoTrip> promos;
  const PromoCarousel({super.key, required this.promos});

  @override
  Widget build(BuildContext context) {
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
        items: promos.map((promo) {
          return PromoCard(promo: promo);
        }).toList(),
      ),
    );
  }
}
