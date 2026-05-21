import 'package:flutter/material.dart';
import 'package:qr_flutter/qr_flutter.dart';
import 'package:camer_trip/app/models/reservation_model.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:camer_trip/app/services/providers.dart';
import 'dart:async';
import 'dart:typed_data';
import 'dart:io';
import 'package:file_picker/file_picker.dart';
import 'package:dio/dio.dart' as dio_lib;
import 'package:camer_trip/app/services/api_client_service.dart';
import 'package:printing/printing.dart';
import 'package:go_router/go_router.dart';
import 'package:camer_trip/app/config/const_config.dart';
import 'package:camer_trip/l10n/app_localizations.dart';

class DashedLinePainter extends CustomPainter {
  final Color color;
  DashedLinePainter({required this.color});

  @override
  void paint(Canvas canvas, Size size) {
    double dashWidth = 6, dashSpace = 4, startX = 0;
    final paint = Paint()
      ..color = color
      ..strokeWidth = 1.5;
    while (startX < size.width) {
      canvas.drawLine(Offset(startX, 0), Offset(startX + dashWidth, 0), paint);
      startX += dashWidth + dashSpace;
    }
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) => false;
}

class ReservationDetailsPage extends ConsumerStatefulWidget {
  final ReservationModel reservation;

  const ReservationDetailsPage({super.key, required this.reservation});

  @override
  ConsumerState<ReservationDetailsPage> createState() => _ReservationDetailsPageState();
}

class _ReservationDetailsPageState extends ConsumerState<ReservationDetailsPage> {
  bool isLoading = false;
  bool isDownloading = false;
  String selectedMethod = 'Orange Money';
  final TextEditingController _phoneController = TextEditingController();
  late String currentStatus;
  String? ussdCode;
  String? operator;

  final TextEditingController _incidentLocationController = TextEditingController();
  final TextEditingController _incidentDescriptionController = TextEditingController();
  File? _incidentPhoto;
  String _selectedIncidentType = 'Panne mécanique';
  String _selectedGravity = 'MOYEN';

  @override
  void initState() {
    super.initState();
    currentStatus = widget.reservation.status ?? 'en attente';
    
    // Préremplir le numéro de téléphone de l'utilisateur connecté
    WidgetsBinding.instance.addPostFrameCallback((_) async {
      final user = await ref.read(currentUserProvider.future);
      if (user != null && user.telephone != null) {
        String phone = user.telephone!;
        if (phone.startsWith('237')) {
          phone = phone.substring(3);
        }
        if (mounted) {
          _phoneController.text = phone;
        }
      }
    });
  }

  @override
  void dispose() {
    _phoneController.dispose();
    _incidentLocationController.dispose();
    _incidentDescriptionController.dispose();
    super.dispose();
  }

  void _showPaymentSheet(ColorScheme cs, bool isDark) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) {
        return StatefulBuilder(
          builder: (context, setSheetState) {
            return Padding(
              padding: EdgeInsets.only(
                bottom: MediaQuery.of(context).viewInsets.bottom,
              ),
              child: Container(
                decoration: BoxDecoration(
                  color: isDark ? cs.surfaceContainerHigh : Colors.white,
                  borderRadius: const BorderRadius.only(
                    topLeft: Radius.circular(30),
                    topRight: Radius.circular(30),
                  ),
                ),
                padding: const EdgeInsets.all(28),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Center(
                      child: Container(
                        width: 40, height: 4,
                        decoration: BoxDecoration(
                          color: Colors.grey[300],
                          borderRadius: BorderRadius.circular(2),
                        ),
                      ),
                    ),
                    const SizedBox(height: 24),
                    Text(
                      AppLocalizations.of(context)?.finalizePaymentTitle ?? 'Finaliser le Paiement',
                      style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 20),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      AppLocalizations.of(context)?.finalizePaymentSubtitle ?? 'Complétez votre paiement pour sécuriser définitivement votre place.',
                      style: TextStyle(color: Colors.grey[600], fontSize: 14),
                    ),
                    const SizedBox(height: 24),
                    
                    // Sommaire rapide
                    Container(
                      padding: const EdgeInsets.all(16),
                      decoration: BoxDecoration(
                        color: cs.primary.withOpacity(0.05),
                        borderRadius: BorderRadius.circular(16),
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(widget.reservation.agenceName ?? 'Agence', style: const TextStyle(fontWeight: FontWeight.bold)),
                              const SizedBox(height: 4),
                              Text(
                                AppLocalizations.of(context)?.ticketSeat(widget.reservation.place) ?? 'Siège #${widget.reservation.place}',
                                style: TextStyle(color: cs.primary, fontSize: 13, fontWeight: FontWeight.w600),
                              ),
                            ],
                          ),
                          Text(
                            '${widget.reservation.prix.toInt()} FCFA',
                            style: TextStyle(fontWeight: FontWeight.w900, color: cs.primary, fontSize: 18),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 24),
                    

                    
                    const SizedBox(height: 24),
                    Text(AppLocalizations.of(context)?.paymentPhoneNumber ?? 'Numéro de téléphone', style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 15)),
                    const SizedBox(height: 8),
                    TextField(
                      controller: _phoneController,
                      keyboardType: TextInputType.phone,
                      decoration: InputDecoration(
                        hintText: '6xx xxx xxx',
                        prefixIcon: const Icon(Icons.phone_android),
                        filled: true,
                        fillColor: isDark ? cs.surfaceContainerHigh : Colors.grey[100],
                        border: OutlineInputBorder(borderRadius: BorderRadius.circular(16), borderSide: BorderSide.none),
                      ),
                    ),
                    const SizedBox(height: 28),
                    
                    SizedBox(
                      width: double.infinity,
                      height: 56,
                      child: ElevatedButton(
                        onPressed: () {
                          Navigator.of(context).pop();
                          _handleExistingPayment();
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: cs.primary,
                          foregroundColor: Colors.white,
                          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
                        ),
                        child: Text(AppLocalizations.of(context)?.confirmAndPay ?? 'CONFIRMER & PAYER', style: const TextStyle(fontWeight: FontWeight.bold)),
                      ),
                    ),
                  ],
                ),
              ),
            );
          }
        );
      }
    );
  }



  Future<void> _handleExistingPayment() async {
    String phone = _phoneController.text.trim();
    if (phone.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(AppLocalizations.of(context)?.paymentEnterPhone ?? 'Veuillez entrer votre numéro de paiement')),
      );
      return;
    }

    if (!phone.startsWith('237')) {
      if (phone.length == 9) {
        phone = '237$phone';
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(AppLocalizations.of(context)?.paymentInvalidPhone ?? 'Numéro invalide. Format: 6xx xxx xxx')),
        );
        return;
      }
    }

    setState(() => isLoading = true);

    try {
      final paiementService = ref.read(paiementServiceProvider);

      // Initier le paiement CamPay
      final payResponse = await paiementService.initiatePayment(
        reservationId: widget.reservation.id!,
        phone: phone,
      );

      if (payResponse == null || payResponse['statut'] == false) {
        throw Exception(payResponse?['message'] ?? 'Erreur d\'initialisation du paiement');
      }

      final reference = payResponse['reference'];

      setState(() {
        ussdCode = payResponse['ussd_code'];
        operator = payResponse['operator'];
      });

      // Polling du statut du paiement
      _startExistingPolling(reference);

    } catch (e) {
      if (mounted) {
        setState(() => isLoading = false);
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(AppLocalizations.of(context)?.paymentError(e.toString()) ?? 'Erreur: ${e.toString()}')),
        );
      }
    }
  }

  void _startExistingPolling(String reference) async {
    final paiementService = ref.read(paiementServiceProvider);
    int attempts = 0;
    const maxAttempts = 30; // 5 minutes

    Timer.periodic(const Duration(seconds: 10), (timer) async {
      if (!mounted || !isLoading) {
        timer.cancel();
        return;
      }
      attempts++;
      if (attempts >= maxAttempts) {
        timer.cancel();
        if (mounted) {
          setState(() => isLoading = false);
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text(AppLocalizations.of(context)?.paymentTimeout2 ?? 'Délai de paiement dépassé.')),
          );
        }
        return;
      }

      try {
        final result = await paiementService.checkPaymentStatus(reference);
        final status = result['statut'];
        final reason = result['reason'];
        
        if (status == 'SUCCESSFUL') {
          timer.cancel();
          if (mounted) {
            setState(() {
              isLoading = false;
              currentStatus = 'validee';
            });
            ref.invalidate(myReservationsProvider);
            _showSuccessPaymentDialog();
          }
        } else if (status == 'FAILED' || status == 'ECHOUÉ') {
          timer.cancel();
          if (mounted) {
            setState(() => isLoading = false);
            String message = AppLocalizations.of(context)?.paymentFailedGeneric ?? 'Le paiement a échoué.';
            if (reason != null && reason.toString().isNotEmpty) {
              String cleanReason = reason.toString().toLowerCase();
              if (cleanReason.contains('insufficient balance') || cleanReason.contains('solde insuffisant')) {
                message = AppLocalizations.of(context)?.paymentFailedInsufficientBalance ?? 'Échec : Solde insuffisant sur votre compte.';
              } else if (cleanReason.contains('limit exceeded') || cleanReason.contains('limite dépassée')) {
                message = AppLocalizations.of(context)?.paymentFailedLimitExceeded ?? 'Échec : Limite de transaction dépassée.';
              } else if (cleanReason.contains('refused') || cleanReason.contains('annulé') || cleanReason.contains('refuse')) {
                message = AppLocalizations.of(context)?.paymentFailedRefused ?? 'Échec : Transaction refusée par l\'utilisateur.';
              } else {
                message = AppLocalizations.of(context)?.paymentFailedReason(reason.toString()) ?? 'Échec : ${reason.toString()}';
              }
            }
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text(message),
                backgroundColor: Colors.red[800],
                duration: const Duration(seconds: 5),
              ),
            );
          }
        }
      } catch (e) {
        // Ignorer les erreurs
      }
    });
  }

  void _showSuccessPaymentDialog() {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Icon(Icons.check_circle, color: Colors.green, size: 64),
            const SizedBox(height: 16),
            Text(
              AppLocalizations.of(context)?.paymentDone ?? 'Paiement Effectué !',
              style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 20),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 8),
            Text(
              AppLocalizations.of(context)?.paymentDoneMessage ?? 'Votre place est désormais validée. Le QR code a été activé sur votre billet.',
              textAlign: TextAlign.center,
              style: const TextStyle(color: Colors.grey),
            ),
          ],
        ),
        actions: [
          Padding(
            padding: const EdgeInsets.fromLTRB(12, 0, 12, 12),
            child: SizedBox(
              width: double.infinity,
              height: 50,
              child: ElevatedButton(
                onPressed: () {
                  Navigator.of(context).pop();
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.green,
                  foregroundColor: Colors.white,
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                ),
                child: const Text('OK', style: TextStyle(fontWeight: FontWeight.bold)),
              ),
            ),
          )
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final cs = theme.colorScheme;
    final isDark = theme.brightness == Brightness.dark;
    
    String statusLabel;
    Color statusColor;
    switch (currentStatus) {
      case 'validee':
        statusLabel = AppLocalizations.of(context)?.statusValidated ?? 'Validée';
        statusColor = Colors.green;
        break;
      case 'annulee':
        statusLabel = AppLocalizations.of(context)?.statusCancelled ?? 'Annulée';
        statusColor = cs.error;
        break;
      case 'en attente':
      default:
        statusLabel = AppLocalizations.of(context)?.statusPending ?? 'En attente';
        statusColor = Colors.orange;
        break;
    }

    final hasPaid = currentStatus == 'validee';

    return Scaffold(
      appBar: AppBar(
        title: Text(AppLocalizations.of(context)?.virtualTicketTitle ?? 'Billet Virtuel', style: const TextStyle(fontWeight: FontWeight.bold)),
        centerTitle: true,
        backgroundColor: Colors.transparent,
        elevation: 0,
      ),
      extendBodyBehindAppBar: true,
      body: Stack(
        children: [
          Container(
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: isDark 
                    ? [cs.surface, cs.surfaceContainerHighest] 
                    : [cs.primary.withOpacity(0.05), Colors.white],
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
              ),
            ),
            child: SafeArea(
              child: SingleChildScrollView(
                padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 16.0),
                child: Column(
                  children: [
                    // Ticket Container
                    Container(
                      decoration: BoxDecoration(
                        color: isDark ? cs.surfaceContainerHigh : Colors.white,
                        borderRadius: BorderRadius.circular(24),
                        boxShadow: [
                          BoxShadow(
                            color: isDark ? Colors.black54 : cs.shadow.withOpacity(0.1),
                            blurRadius: 20,
                            offset: const Offset(0, 10),
                          )
                        ],
                      ),
                      child: Column(
                        children: [
                          // En Tête Billet
                          Container(
                            padding: const EdgeInsets.all(24),
                            decoration: BoxDecoration(
                              color: hasPaid ? cs.primary : Colors.orange[800],
                              borderRadius: const BorderRadius.only(
                                topLeft: Radius.circular(24),
                                topRight: Radius.circular(24),
                              ),
                            ),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Expanded(
                                  child: Text(
                                    widget.reservation.agenceName ?? 'Agence',
                                    style: const TextStyle(
                                      color: Colors.white,
                                      fontWeight: FontWeight.w900,
                                      fontSize: 20,
                                    ),
                                    overflow: TextOverflow.ellipsis,
                                    maxLines: 1,
                                  ),
                                ),
                                const SizedBox(width: 12),
                                Container(
                                  padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                                  decoration: BoxDecoration(
                                    color: Colors.white24,
                                    borderRadius: BorderRadius.circular(12),
                                  ),
                                  child: Text(
                                    statusLabel,
                                    style: const TextStyle(
                                      color: Colors.white,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                          
                          // Détails du Billet
                          Padding(
                            padding: const EdgeInsets.all(24.0),
                            child: Column(
                              children: [
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                  children: [
                                    Flexible(child: _buildCityTime(widget.reservation.route?.split(' ↔ ').first ?? '', theme, cs)),
                                    const Padding(
                                      padding: EdgeInsets.symmetric(horizontal: 8.0),
                                      child: Icon(Icons.arrow_forward_rounded, color: Colors.grey, size: 24),
                                    ),
                                    Flexible(child: _buildCityTime(widget.reservation.route?.split(' ↔ ').last ?? '', theme, cs, isEnd: true)),
                                  ],
                                ),
                                const SizedBox(height: 30),
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                  children: [
                                    Flexible(child: _buildInfoBlock(AppLocalizations.of(context)?.ticketDate ?? 'Date', widget.reservation.date ?? 'N/A', theme)),
                                    Flexible(child: _buildInfoBlock(AppLocalizations.of(context)?.ticketTime ?? 'Heure', widget.reservation.time ?? 'N/A', theme)),
                                    Flexible(child: _buildInfoBlock(AppLocalizations.of(context)?.ticketSeatLabel ?? 'Siège', widget.reservation.place, theme, highlight: true)),
                                  ],
                                ),
                                const SizedBox(height: 24),
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                  children: [
                                    Flexible(child: _buildInfoBlock(AppLocalizations.of(context)?.ticketPassenger ?? 'Passager', AppLocalizations.of(context)?.ticketPassengerValue ?? 'Client (Moi)', theme)),
                                    Flexible(child: _buildInfoBlock(AppLocalizations.of(context)?.ticketPricePaid ?? 'Prix payé', '${widget.reservation.prix.toInt()} FCFA', theme, highlight: true)),
                                  ],
                                ),
                              ],
                            ),
                          ),

                          // Ligne de perforation
                          Stack(
                            children: [
                              SizedBox(
                                height: 40,
                                child: Center(
                                  child: CustomPaint(
                                    size: const Size(double.infinity, 1),
                                    painter: DashedLinePainter(
                                      color: isDark ? Colors.white30 : Colors.black26,
                                    ),
                                  ),
                                ),
                              ),
                              Positioned(
                                left: -20,
                                top: 0,
                                bottom: 0,
                                child: Container(
                                  width: 40,
                                  decoration: BoxDecoration(
                                    color: isDark ? cs.surfaceContainerHighest : cs.surface,
                                    shape: BoxShape.circle,
                                  ),
                                ),
                              ),
                              Positioned(
                                right: -20,
                                top: 0,
                                bottom: 0,
                                child: Container(
                                  width: 40,
                                  decoration: BoxDecoration(
                                    color: isDark ? cs.surfaceContainerHighest : cs.surface,
                                    shape: BoxShape.circle,
                                  ),
                                ),
                              ),
                            ],
                          ),

                          // Zone QR Code (Seulement si validée)
                          if (hasPaid)
                            Container(
                              padding: const EdgeInsets.all(32),
                              decoration: const BoxDecoration(
                                borderRadius: BorderRadius.only(
                                  bottomLeft: Radius.circular(24),
                                  bottomRight: Radius.circular(24),
                                ),
                              ),
                              child: Column(
                                children: [
                                  Container(
                                    padding: const EdgeInsets.all(12),
                                    decoration: BoxDecoration(
                                      color: Colors.white,
                                      borderRadius: BorderRadius.circular(16),
                                      border: Border.all(color: Colors.grey.shade300),
                                    ),
                                    child: QrImageView(
                                      data: '${AppConstants.apiBaseUrl.replaceAll('/api', '')}/ticket-public/${widget.reservation.numReservation}',
                                      version: QrVersions.auto,
                                      size: 180.0,
                                      backgroundColor: Colors.white,
                                      foregroundColor: Colors.black,
                                    ),
                                  ),
                                  const SizedBox(height: 16),
                                  Text(
                                    AppLocalizations.of(context)?.ticketReference(widget.reservation.id!) ?? 'Référence: ${widget.reservation.id}',
                                    style: theme.textTheme.bodyMedium?.copyWith(
                                      fontWeight: FontWeight.bold,
                                      letterSpacing: 1.5,
                                      color: cs.onSurface.withOpacity(0.6),
                                    ),
                                  )
                                ],
                              ),
                            )
                          else if (currentStatus == 'en attente')
                            Container(
                              padding: const EdgeInsets.all(24),
                              alignment: Alignment.center,
                              child: Column(
                                children: [
                                  Icon(
                                    widget.reservation.voyageStatus != 'en attente'
                                        ? Icons.error_outline
                                        : Icons.payment_outlined,
                                    size: 48,
                                    color: widget.reservation.voyageStatus != 'en attente'
                                        ? Colors.red[800]
                                        : Colors.orange[800],
                                  ),
                                  const SizedBox(height: 12),
                                  Text(
                                    widget.reservation.voyageStatus != 'en attente'
                                        ? (AppLocalizations.of(context)?.reservationExpired ?? 'Réservation expirée car le voyage a débuté, s\'est terminé ou a été annulé.')
                                        : (AppLocalizations.of(context)?.paymentRequired ?? 'Paiement requis pour générer le QR Code.'),
                                    style: TextStyle(
                                      color: widget.reservation.voyageStatus != 'en attente'
                                          ? Colors.red[700]
                                          : Colors.grey[600],
                                      fontSize: 13,
                                      fontWeight: FontWeight.w500,
                                    ),
                                    textAlign: TextAlign.center,
                                  ),
                                ],
                              ),
                            ),
                        ],
                      ),
                    ),
                    
                    const SizedBox(height: 32),

                    // Actions
                    if (currentStatus == 'en attente') ...[
                      if (widget.reservation.voyageStatus != null && widget.reservation.voyageStatus != 'en attente') ...[
                        Container(
                          width: double.infinity,
                          padding: const EdgeInsets.all(16),
                          decoration: BoxDecoration(
                            color: Colors.red.withOpacity(0.1),
                            borderRadius: BorderRadius.circular(16),
                            border: Border.all(color: Colors.red.withOpacity(0.3)),
                          ),
                          child: Row(
                            children: [
                              const Icon(Icons.warning_amber_rounded, color: Colors.red, size: 28),
                              const SizedBox(width: 12),
                              Expanded(
                                child: Text(
                                  widget.reservation.voyageStatus == 'annule'
                                      ? (AppLocalizations.of(context)?.voyageCancelled ?? 'Le voyage a été annulé. Ce billet ne peut plus être payé.')
                                      : (AppLocalizations.of(context)?.voyageStarted ?? 'Le voyage a déj\u00e0 débuté ou est terminé. Ce billet ne peut plus être payé.'),
                                  style: const TextStyle(
                                    color: Colors.red,
                                    fontWeight: FontWeight.w600,
                                    fontSize: 14,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ] else ...[
                        SizedBox(
                          width: double.infinity,
                          height: 54,
                          child: ElevatedButton.icon(
                            style: ElevatedButton.styleFrom(
                              backgroundColor: Colors.orange[800],
                              foregroundColor: Colors.white,
                              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
                            ),
                            onPressed: () => _showPaymentSheet(cs, isDark),
                            icon: const Icon(Icons.flash_on),
                            label: Text(AppLocalizations.of(context)?.payThisTicket ?? 'PAYER CE BILLET', style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 15)),
                          ),
                        ),
                      ],
                      SizedBox(
                        width: double.infinity,
                        height: 54,
                        child: ElevatedButton.icon(
                          style: ElevatedButton.styleFrom(
                            backgroundColor: const Color(0xFFE53E3E),
                            foregroundColor: Colors.white,
                            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
                          ),
                          onPressed: isDownloading ? null : _downloadTicket,
                          icon: isDownloading
                              ? const SizedBox(
                                  width: 20,
                                  height: 20,
                                  child: CircularProgressIndicator(strokeWidth: 2, color: Colors.white),
                                )
                              : const Icon(Icons.download),
                          label: Text(
                            isDownloading
                                ? (AppLocalizations.of(context)?.downloading ?? 'Téléchargement...')
                                : (AppLocalizations.of(context)?.downloadPdf ?? 'Télécharger le Ticket PDF'),
                            style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 15),
                          ),
                        ),
                      ),
                      if (widget.reservation.voyageStatus == 'en cours') ...[
                        const SizedBox(height: 12),
                        SizedBox(
                          width: double.infinity,
                          height: 54,
                          child: ElevatedButton.icon(
                            style: ElevatedButton.styleFrom(
                              backgroundColor: Colors.orange[800],
                              foregroundColor: Colors.white,
                              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
                            ),
                            onPressed: () => _showReportIncidentDialog(cs, isDark),
                            icon: const Icon(Icons.warning_amber_rounded),
                            label: const Text(
                              'Signaler un incident',
                              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 15),
                            ),
                          ),
                        ),
                      ],
                    ]
                  ],
                ),
              ),
            ),
          ),
          if (isLoading)
            Container(
              color: Colors.black.withOpacity(0.6),
              child: Center(
                child: Card(
                  margin: const EdgeInsets.symmetric(horizontal: 32),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(24)),
                  elevation: 8,
                  child: Padding(
                    padding: const EdgeInsets.all(28),
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        const SizedBox(
                          width: 50,
                          height: 50,
                          child: CircularProgressIndicator(strokeWidth: 4.5),
                        ),
                        const SizedBox(height: 24),
                        Text(
                          AppLocalizations.of(context)?.paymentValidationTitle ?? 'Validation du Paiement',
                          style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
                          textAlign: TextAlign.center,
                        ),
                        const SizedBox(height: 12),
                        Text(
                          AppLocalizations.of(context)?.ussdPromptMessage(_phoneController.text.trim()) ?? 'Un prompt USSD de paiement a été initié vers le numéro :\n${_phoneController.text.trim()}',
                          textAlign: TextAlign.center,
                          style: TextStyle(color: Colors.grey[600], fontSize: 14),
                        ),
                        if (ussdCode != null && ussdCode!.isNotEmpty) ...[
                          const SizedBox(height: 16),
                          Container(
                            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                            decoration: BoxDecoration(
                              color: Colors.orange.withOpacity(0.1),
                              borderRadius: BorderRadius.circular(12),
                              border: Border.all(color: Colors.orange.withOpacity(0.3)),
                            ),
                            child: Column(
                              children: [
                                Text(
                                  AppLocalizations.of(context)?.paymentUssdCode(ussdCode!) ?? 'Code USSD : $ussdCode',
                                  style: const TextStyle(
                                    fontWeight: FontWeight.bold,
                                    fontSize: 18,
                                    color: Colors.orange,
                                  ),
                                  textAlign: TextAlign.center,
                                ),
                                const SizedBox(height: 6),
                                Text(
                                  AppLocalizations.of(context)?.paymentUssdTip ?? 'Composez ce code si le prompt de validation ne s\'affiche pas automatiquement.',
                                  style: TextStyle(
                                    fontSize: 12,
                                    color: isDark ? Colors.grey[300] : Colors.grey[800],
                                  ),
                                  textAlign: TextAlign.center,
                                ),
                              ],
                            ),
                          ),
                        ],
                        const SizedBox(height: 12),
                        Text(
                          AppLocalizations.of(context)?.paymentPinPrompt(widget.reservation.prix.toInt()) ?? 'Saisissez votre code PIN sur votre téléphone pour autoriser le débit de ${widget.reservation.prix.toInt()} FCFA.',
                          textAlign: TextAlign.center,
                          style: const TextStyle(fontWeight: FontWeight.w600, fontSize: 14),
                        ),
                        const SizedBox(height: 24),
                        Container(
                          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                          decoration: BoxDecoration(
                            color: cs.primary.withOpacity(0.08),
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Icon(Icons.sync, color: cs.primary, size: 18),
                              const SizedBox(width: 8),
                              Flexible(
                                child: Text(
                                  AppLocalizations.of(context)?.paymentCheckingStatus ?? 'Vérification du statut du paiement...',
                                  style: TextStyle(color: cs.primary, fontWeight: FontWeight.bold, fontSize: 13),
                                  overflow: TextOverflow.ellipsis,
                                ),
                              ),
                            ],
                          ),
                        ),
                        const SizedBox(height: 24),
                        TextButton.icon(
                          onPressed: () {
                            setState(() => isLoading = false);
                          },
                          icon: const Icon(Icons.close, size: 16),
                          label: Text(AppLocalizations.of(context)?.paymentCloseRetry ?? 'Fermer / Recommencer', style: const TextStyle(fontSize: 14)),
                          style: TextButton.styleFrom(
                            foregroundColor: Colors.grey[700],
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
        ],
      ),
    );
  }

  void _downloadTicket() async {
    if (isDownloading) return;
    setState(() => isDownloading = true);

    try {
      final reservationService = ref.read(reservationServiceProvider);
      final pdfBytes = await reservationService.downloadTicketPdf(widget.reservation.id!);
      
      await Printing.sharePdf(
        bytes: Uint8List.fromList(pdfBytes),
        filename: 'ticket_${widget.reservation.numReservation ?? widget.reservation.id}.pdf',
      );
      
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(AppLocalizations.of(context)?.ticketPdfReady ?? 'Ticket PDF prêt ! 📄'),
            backgroundColor: Colors.green,
            behavior: SnackBarBehavior.floating,
          ),
        );
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(AppLocalizations.of(context)?.downloadError(e.toString()) ?? 'Erreur lors du téléchargement : ${e.toString()}'),
            backgroundColor: Colors.red,
            behavior: SnackBarBehavior.floating,
          ),
        );
      }
    } finally {
      if (mounted) {
        setState(() => isDownloading = false);
      }
    }
  }

  Widget _buildCityTime(String city, ThemeData theme, ColorScheme cs, {bool isEnd = false}) {
    return Column(
      crossAxisAlignment: isEnd ? CrossAxisAlignment.end : CrossAxisAlignment.start,
      children: [
        Text(
          city.length >= 3 ? city.substring(0, 3).toUpperCase() : city.toUpperCase(),
          style: theme.textTheme.headlineMedium?.copyWith(
            fontWeight: FontWeight.w900,
            color: cs.primary,
            letterSpacing: 1.5,
          ),
        ),
        const SizedBox(height: 4),
        Text(
          city,
          style: theme.textTheme.titleSmall?.copyWith(
            color: cs.onSurface.withOpacity(0.7),
          ),
          overflow: TextOverflow.ellipsis,
          maxLines: 1,
        ),
      ],
    );
  }

  Widget _buildInfoBlock(String title, String value, ThemeData theme, {bool highlight = false}) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          title.toUpperCase(),
          style: theme.textTheme.labelSmall?.copyWith(
            color: theme.colorScheme.onSurface.withOpacity(0.5),
            letterSpacing: 1,
            fontWeight: FontWeight.w600,
          ),
        ),
        const SizedBox(height: 4),
        Text(
          value,
          style: theme.textTheme.titleMedium?.copyWith(
            fontWeight: FontWeight.bold,
            color: highlight ? theme.colorScheme.primary : theme.colorScheme.onSurface,
          ),
          overflow: TextOverflow.ellipsis,
          maxLines: 1,
        ),
      ],
    );
  }

  void _showReportIncidentDialog(ColorScheme cs, bool isDark) {
    _incidentLocationController.clear();
    _incidentDescriptionController.clear();
    _incidentPhoto = null;
    _selectedIncidentType = 'Panne mécanique';
    _selectedGravity = 'MOYEN';

    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) {
        return StatefulBuilder(
          builder: (context, setDialogState) {
            return AlertDialog(
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(24)),
              title: Row(
                children: [
                  Icon(Icons.warning_amber_rounded, color: cs.error, size: 28),
                  const SizedBox(width: 8),
                  const Text('Signaler un incident', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18)),
                ],
              ),
              content: SingleChildScrollView(
                child: SizedBox(
                  width: MediaQuery.of(context).size.width * 0.9,
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        'Aidez-nous à améliorer le voyage en signalant tout incident rencontré.',
                        style: TextStyle(fontSize: 13, color: Colors.grey),
                      ),
                      const SizedBox(height: 16),
                      
                      const Text('Type d\'incident', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 14)),
                      const SizedBox(height: 6),
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 12),
                        decoration: BoxDecoration(
                          border: Border.all(color: cs.outline.withOpacity(0.3)),
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: DropdownButtonHideUnderline(
                          child: DropdownButton<String>(
                            value: _selectedIncidentType,
                            isExpanded: true,
                            items: <String>[
                              'Panne mécanique',
                              'Accident',
                              'Problème de climatisation',
                              'Comportement du chauffeur',
                              'Retard important',
                              'Autre'
                            ].map<DropdownMenuItem<String>>((String value) {
                              return DropdownMenuItem<String>(
                                value: value,
                                child: Text(value, style: const TextStyle(fontSize: 14)),
                              );
                            }).toList(),
                            onChanged: (String? newValue) {
                              if (newValue != null) {
                                setDialogState(() {
                                  _selectedIncidentType = newValue;
                                });
                              }
                            },
                          ),
                        ),
                      ),
                      const SizedBox(height: 16),

                      const Text('Niveau de gravité', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 14)),
                      const SizedBox(height: 6),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          _buildGravityOption(setDialogState, 'FAIBLE', Colors.green),
                          _buildGravityOption(setDialogState, 'MOYEN', Colors.orange),
                          _buildGravityOption(setDialogState, 'CRITIQUE', Colors.red),
                        ],
                      ),
                      const SizedBox(height: 16),

                      const Text('Lieu de l\'incident (Optionnel)', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 14)),
                      const SizedBox(height: 6),
                      TextField(
                        controller: _incidentLocationController,
                        decoration: InputDecoration(
                          hintText: 'Ex: Entrée de la ville de Boumnyebel',
                          hintStyle: const TextStyle(fontSize: 13),
                          border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
                          contentPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                        ),
                      ),
                      const SizedBox(height: 16),

                      const Text('Description de l\'incident', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 14)),
                      const SizedBox(height: 6),
                      TextField(
                        controller: _incidentDescriptionController,
                        maxLines: 3,
                        decoration: InputDecoration(
                          hintText: 'Décrivez brièvement ce qui s\'est passé...',
                          hintStyle: const TextStyle(fontSize: 13),
                          border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
                          contentPadding: const EdgeInsets.all(12),
                        ),
                      ),
                      const SizedBox(height: 16),

                      const Text('Photo de l\'incident', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 14)),
                      const SizedBox(height: 6),
                      GestureDetector(
                        onTap: () => _pickIncidentPhoto(setDialogState),
                        child: Container(
                          width: double.infinity,
                          height: 100,
                          decoration: BoxDecoration(
                            border: Border.all(color: cs.outline.withOpacity(0.3)),
                            borderRadius: BorderRadius.circular(12),
                            color: cs.primary.withOpacity(0.05),
                          ),
                          child: _incidentPhoto != null
                              ? ClipRRect(
                                  borderRadius: BorderRadius.circular(12),
                                  child: Image.file(_incidentPhoto!, fit: BoxFit.cover),
                                )
                              : Column(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Icon(Icons.add_a_photo_rounded, color: cs.primary, size: 28),
                                    const SizedBox(height: 4),
                                    Text('Ajouter une photo', style: TextStyle(color: cs.primary, fontSize: 12, fontWeight: FontWeight.bold)),
                                  ],
                                ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              actions: [
                TextButton(
                  onPressed: () => Navigator.of(context).pop(),
                  child: const Text('Annuler', style: TextStyle(color: Colors.grey)),
                ),
                ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: cs.error,
                    foregroundColor: Colors.white,
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                  ),
                  onPressed: () => _submitIncident(cs),
                  child: const Text('Signaler', style: TextStyle(fontWeight: FontWeight.bold)),
                ),
              ],
            );
          },
        );
      },
    );
  }

  Widget _buildGravityOption(StateSetter setDialogState, String gravity, Color color) {
    final isSelected = _selectedGravity == gravity;
    return GestureDetector(
      onTap: () {
        setDialogState(() {
          _selectedGravity = gravity;
        });
      },
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
        decoration: BoxDecoration(
          color: isSelected ? color.withOpacity(0.2) : Colors.transparent,
          border: Border.all(color: isSelected ? color : Colors.grey.withOpacity(0.3), width: 1.5),
          borderRadius: BorderRadius.circular(8),
        ),
        child: Text(
          gravity,
          style: TextStyle(
            color: isSelected ? color : Colors.grey,
            fontWeight: FontWeight.bold,
            fontSize: 12,
          ),
        ),
      ),
    );
  }

  Future<void> _pickIncidentPhoto(StateSetter setDialogState) async {
    try {
      final result = await FilePicker.platform.pickFiles(
        type: FileType.image,
      );
      if (result != null && result.files.single.path != null) {
        setDialogState(() {
          _incidentPhoto = File(result.files.single.path!);
        });
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Erreur lors de la sélection de la photo : $e')),
      );
    }
  }

  Future<void> _submitIncident(ColorScheme cs) async {
    if (_incidentDescriptionController.text.trim().isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Veuillez saisir une description de l\'incident.')),
      );
      return;
    }
    if (_incidentPhoto == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Veuillez sélectionner une photo pour illustrer l\'incident.')),
      );
      return;
    }

    setState(() {
      isLoading = true;
    });

    try {
      final dio = ApiClient().dio;
      final fileName = _incidentPhoto!.path.split('/').last;
      
      final multipartFile = await dio_lib.MultipartFile.fromFile(
        _incidentPhoto!.path,
        filename: fileName,
      );

      final formData = dio_lib.FormData.fromMap({
        'voyage_id': widget.reservation.voyageId,
        'type': _selectedIncidentType,
        'description': _incidentDescriptionController.text.trim(),
        'niveau_gravite': _selectedGravity,
        'lieu': _incidentLocationController.text.trim(),
        'photo': multipartFile,
      });

      final response = await dio.post('/client/incidents', data: formData);

      if (mounted) {
        setState(() {
          isLoading = false;
        });

        if (response.statusCode == 201) {
          Navigator.of(context).pop(); // Fermer le formulaire
          showDialog(
            context: context,
            builder: (context) => AlertDialog(
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
              title: const Row(
                children: [
                  Icon(Icons.check_circle, color: Colors.green, size: 28),
                  SizedBox(width: 8),
                  Text('Signalement envoyé'),
                ],
              ),
              content: const Text(
                'L\'incident a été signalé avec succès au gestionnaire de l\'agence. Merci pour votre signalement.',
              ),
              actions: [
                TextButton(
                  onPressed: () => Navigator.of(context).pop(),
                  child: const Text('OK'),
                ),
              ],
            ),
          );
        } else {
          throw Exception(response.data['message'] ?? 'Erreur lors du signalement');
        }
      }
    } catch (e) {
      if (mounted) {
        setState(() {
          isLoading = false;
        });
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Erreur : $e')),
        );
      }
    }
  }
}
