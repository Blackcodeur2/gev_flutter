import 'package:dio/dio.dart';

/// Converts API/network errors into user-friendly messages for the UI.
class ApiErrorHandler {
  static const String defaultMessage =
      'Une erreur est survenue. Veuillez réessayer.';

  static String userMessage(
    Object? error, {
    String? fallback,
  }) {
    if (error == null) {
      return fallback ?? defaultMessage;
    }

    if (error is DioException) {
      return _fromDioException(error, fallback: fallback);
    }

    if (error is Exception) {
      final message = error.toString();
      if (message.startsWith('Exception: ')) {
        final inner = message.substring('Exception: '.length).trim();
        if (_isUserFriendly(inner)) {
          return inner;
        }
      }
    }

    final raw = error.toString().trim();
    if (_isUserFriendly(raw)) {
      return raw;
    }

    return fallback ?? defaultMessage;
  }

  static String _fromDioException(
    DioException error, {
    String? fallback,
  }) {
    final serverMessage = _extractServerMessage(error.response?.data);
    if (serverMessage != null) {
      return serverMessage;
    }

    final statusCode = error.response?.statusCode;
    if (statusCode == 401) {
      return 'Session expirée. Veuillez vous reconnecter.';
    }
    if (statusCode == 403) {
      return 'Accès refusé.';
    }
    if (statusCode == 404) {
      return 'Ressource introuvable.';
    }
    if (statusCode == 422) {
      return 'Données invalides.';
    }
    if (statusCode != null && statusCode >= 500) {
      return 'Le serveur est temporairement indisponible.';
    }

    switch (error.type) {
      case DioExceptionType.connectionTimeout:
      case DioExceptionType.sendTimeout:
      case DioExceptionType.receiveTimeout:
        return 'Délai de connexion dépassé. Vérifiez votre connexion internet.';
      case DioExceptionType.connectionError:
        return 'Impossible de se connecter au serveur. Vérifiez votre connexion internet.';
      case DioExceptionType.cancel:
        return 'Requête annulée.';
      case DioExceptionType.badCertificate:
        return 'Connexion sécurisée impossible.';
      case DioExceptionType.badResponse:
      case DioExceptionType.unknown:
        break;
    }

    return fallback ?? defaultMessage;
  }

  static String? _extractServerMessage(dynamic data) {
    if (data == null) {
      return null;
    }

    if (data is Map) {
      final message = data['message'];
      if (message is String && message.trim().isNotEmpty && _isUserFriendly(message)) {
        return message.trim();
      }

      final errors = data['errors'];
      if (errors is Map && errors.isNotEmpty) {
        final firstValue = errors.values.first;
        if (firstValue is List && firstValue.isNotEmpty) {
          final validationMessage = firstValue.first.toString().trim();
          if (validationMessage.isNotEmpty && _isUserFriendly(validationMessage)) {
            return validationMessage;
          }
        }
      }
    }

    if (data is String && data.trim().isNotEmpty && _isUserFriendly(data)) {
      return data.trim();
    }

    return null;
  }

  static bool _isUserFriendly(String message) {
    if (message.isEmpty) {
      return false;
    }

    final lower = message.toLowerCase();
    const technicalPatterns = [
      'dioexception',
      'socketexception',
      'formatexception',
      'failed host lookup',
      'connection refused',
      'connection errored',
      'handshakeexception',
      'clientexception',
      'http status',
      'status code',
      'xmlhttprequest',
      'errno',
      'dart:',
      'package:dio',
      'network is unreachable',
      'software caused connection abort',
    ];

    for (final pattern in technicalPatterns) {
      if (lower.contains(pattern)) {
        return false;
      }
    }

    return true;
  }
}
