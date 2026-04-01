import 'package:flutter/material.dart';

class Agence {
  final String name;
  final String route;
  final String rating;
  final Color color;
  final IconData icon;
  const Agence({
    required this.name,
    required this.route,
    required this.rating,
    required this.color,
    required this.icon,
  });
}