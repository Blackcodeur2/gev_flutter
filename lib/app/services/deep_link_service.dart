import 'dart:async';
import 'package:app_links/app_links.dart';
import 'package:flutter/material.dart';

class DeepLinkService {
  static final DeepLinkService _instance = DeepLinkService._internal();
  factory DeepLinkService() => _instance;
  DeepLinkService._internal();

  final _appLinks = AppLinks();
  StreamSubscription? _linkSubscription;

  void initialize(BuildContext context) {
    // Handle links when the app is already open
    _linkSubscription = _appLinks.uriLinkStream.listen((uri) {
      _handleDeepLink(context, uri);
    }, onError: (err) {
      print('Deep Link Error: $err');
    });

    // Handle link that opened the app
    _appLinks.getInitialLink().then((uri) {
      if (uri != null) {
        _handleDeepLink(context, uri);
      }
    });
  }

  void _handleDeepLink(BuildContext context, Uri uri) {
    print('Handling Deep Link: $uri');
    
    // Exemple d'URL : https://camertrip.com/verify-email?id=1&hash=abc
    if (uri.path == '/verify-email') {
      final id = uri.queryParameters['id'];
      final hash = uri.queryParameters['hash'];
      
      if (id != null && hash != null) {
        // Naviguer vers l'écran de vérification ou traiter directement
        // Pour l'instant, on affiche juste une info, à adapter selon ton système de navigation (GoRouter, etc.)
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text("Lien de vérification détecté : ID $id")),
        );
      }
    } 
    
    // Exemple d'URL : https://camertrip.com/reset-password?token=abc&email=test@test.com
    else if (uri.path == '/reset-password') {
      final token = uri.queryParameters['token'];
      final email = uri.queryParameters['email'];
      
      if (token != null && email != null) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text("Lien de réinitialisation détecté pour $email")),
        );
      }
    }
  }

  void dispose() {
    _linkSubscription?.cancel();
  }
}
