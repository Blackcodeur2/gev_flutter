// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for English (`en`).
class AppLocalizationsEn extends AppLocalizations {
  AppLocalizationsEn([String locale = 'en']) : super(locale);

  @override
  String get appName => 'CamerTrip';

  @override
  String get settingsTitle => 'Settings';

  @override
  String get language => 'Language';

  @override
  String get french => 'French';

  @override
  String get english => 'English';

  @override
  String get home => 'Home';

  @override
  String get profile => 'Profile';

  @override
  String get onboardingTitle1 => 'Welcome to CamerTrip';

  @override
  String get onboardingDesc1 => 'Discover the best places in Cameroon';

  @override
  String get onboardingTitle2 => 'Travel easily';

  @override
  String get onboardingDesc2 => 'Plan your trips in a few clicks';

  @override
  String get onboardingTitle3 => 'Start now';

  @override
  String get onboardingDesc3 => 'A new adventure awaits 🚀';

  @override
  String get skip => 'Skip';

  @override
  String get start => 'Start';

  @override
  String get next => 'Next';

  @override
  String get loginTitle => 'Login';

  @override
  String get loginSubtitle => 'Welcome back 👋 Good to see you again.';

  @override
  String get emailLabel => 'Email address';

  @override
  String get emailHint => 'example@email.com';

  @override
  String get emailRequired => 'Please enter your email';

  @override
  String get emailInvalid => 'Invalid email';

  @override
  String get passwordLabel => 'Password';

  @override
  String get forgotPassword => 'Forgot password?';

  @override
  String get passwordRequired => 'Please enter your password';

  @override
  String get passwordMinLength => 'Minimum 6 characters';

  @override
  String get rememberMe => 'Remember me';

  @override
  String get loginButton => 'LOGIN';

  @override
  String get orContinueWith => 'OR CONTINUE WITH';

  @override
  String get noAccount => 'Don\'t have an account yet? ';

  @override
  String get registerLink => 'Sign up';

  @override
  String get heroSubtitle => 'Travel smart in Cameroon 🌍';

  @override
  String get registerTitle => 'Sign up';

  @override
  String get registerSubtitle => 'Complete your details 🚀';

  @override
  String get orRegisterWith => 'OR SIGN UP WITH';

  @override
  String get continueWithGoogle => 'CONTINUE WITH GOOGLE';

  @override
  String get identitySection => 'Identity';

  @override
  String get lastName => 'Last Name';

  @override
  String get firstName => 'First Name';

  @override
  String get requiredField => 'Required';

  @override
  String get genderSection => 'Gender';

  @override
  String get male => 'Male';

  @override
  String get female => 'Female';

  @override
  String get birthDate => 'Date of birth';

  @override
  String get dateRequired => 'Date required';

  @override
  String get contactSection => 'Contact';

  @override
  String get emailPlaceholder => 'Email';

  @override
  String get invalidFormat => 'Invalid format';

  @override
  String get phonePlaceholder => 'Phone number';

  @override
  String get phoneRequired => 'Phone required';

  @override
  String get securitySection => 'Security';

  @override
  String get min8Chars => 'Min. 8 characters';

  @override
  String get confirmPassword => 'Confirm password';

  @override
  String get notIdentical => 'Passwords do not match';

  @override
  String get veryWeak => 'Very weak';

  @override
  String get weak => 'Weak';

  @override
  String get medium => 'Medium';

  @override
  String get strong => 'Strong';

  @override
  String get acceptTerms => 'I accept the terms of use and the privacy policy.';

  @override
  String get createAccountBtn => 'CREATE MY ACCOUNT';

  @override
  String get alreadyHaveAccount => 'Already have an account? ';

  @override
  String get loginLink => 'Log in';

  @override
  String get createAccountHeader => 'CREATE AN ACCOUNT';

  @override
  String get splashSlogan => '🌍 Travel easily in Cameroon';

  @override
  String get loading => 'Loading...';

  @override
  String get termsRequired => 'Please accept the terms of use';

  @override
  String get registerSuccess =>
      'Registration successful. Please check your email.';

  @override
  String get errorPrefix => 'Error: ';

  @override
  String get unknownError => 'Unknown error';

  @override
  String get googleError => 'Google Error';

  @override
  String get success => 'Success';

  @override
  String get ok => 'OK';

  @override
  String get changePasswordTitle => 'Change password';

  @override
  String get currentPassword => 'Current password';

  @override
  String get noPasswordSet =>
      'You have not set a password yet. Please create one to secure your account.';

  @override
  String get newPassword => 'New password';

  @override
  String get confirmNewPassword => 'Confirm new password';

  @override
  String get passwordsDoNotMatch => 'Passwords do not match';

  @override
  String get updateBtn => 'UPDATE';

  @override
  String get passwordSecurityInfo =>
      'For security reasons, choose a strong password of at least 8 characters.';

  @override
  String get passwordChangedSuccess => 'Password successfully changed!';

  @override
  String get passwordChangeError => 'Error while changing password';

  @override
  String get codeSentSuccess => 'Code sent successfully';

  @override
  String get sendCodeError => 'Error sending code';

  @override
  String get resetError => 'Reset error';

  @override
  String get resetSuccessMessage =>
      'Your password has been successfully reset. You can now log in.';

  @override
  String get loginBtn => 'LOG IN';

  @override
  String get resetTitle => 'Reset';

  @override
  String get forgotPasswordTitle => 'Forgot password';

  @override
  String get enterCodeAndNewPassword =>
      'Enter the code received and your new password.';

  @override
  String get enterEmailForCode => 'Enter your email to receive the reset code.';

  @override
  String get yourEmailAddress => 'Your email address';

  @override
  String get sendCodeBtn => 'SEND CODE';

  @override
  String get sixDigitCode => '6-digit code';

  @override
  String get resetBtn => 'RESET';

  @override
  String get changeEmail => 'Change email';

  @override
  String get emailVerifiedViaLink => 'Email successfully verified via link!';

  @override
  String get invalidLink => 'Invalid link';

  @override
  String get emailVerifiedSuccess => 'Email successfully verified!';

  @override
  String get invalidCode => 'Invalid code';

  @override
  String get codeResent => 'Code resent';

  @override
  String get verificationTitle => 'Verification';

  @override
  String get checkYourInbox => 'Check your inbox';

  @override
  String codeSentMessage(String email) {
    return 'We sent a verification code to $email. Please enter it below.';
  }

  @override
  String get verificationCodeLabel => 'Verification code';

  @override
  String get verifyBtn => 'Verify';

  @override
  String get resendCodeInstructions => 'I didn\'t receive a code. Resend.';

  @override
  String get upcomingTripsTitle => '📅 Upcoming Trips';

  @override
  String get partnerAgenciesTitle => '🏢 Partner Agencies';

  @override
  String get currentReservationsTitle => '🎟️ Current Reservation';

  @override
  String filterTypeTripComingSoon(String label) {
    return 'Filter by trip type \"$label\" coming soon! 🚌';
  }

  @override
  String stationsCountNational(int count) {
    return '$count stations • National Network';
  }

  @override
  String get sectionAppearance => 'Appearance & System';

  @override
  String get darkMode => 'Dark Mode';

  @override
  String get darkModeEnabled => 'Enabled';

  @override
  String get darkModeDisabled => 'Disabled';

  @override
  String get notifications => 'Notifications';

  @override
  String get notificationsSubtitle => 'Alerts and Push';

  @override
  String get sectionSecurity => 'Security';

  @override
  String get password => 'Password';

  @override
  String get changePasswordSubtitle => 'Change my password';

  @override
  String get sectionActivities => 'My Activities';

  @override
  String get myParcels => 'My Parcels';

  @override
  String get myParcelsSubtitle => 'Track my shipments and receipts';

  @override
  String get sectionSupport => 'Support';

  @override
  String get helpCenter => 'Help Center';

  @override
  String get helpCenterSubtitle => 'Frequently asked questions';

  @override
  String get about => 'About';

  @override
  String get logout => 'Log out';

  @override
  String get notConnected => 'Not connected';

  @override
  String get sessionExpired => 'Session expired';

  @override
  String get noInternetTitle => 'No connection';

  @override
  String get noInternetMessage =>
      'Check your Wi-Fi or mobile data connection and try again.';

  @override
  String get retryBtn => 'Retry';

  @override
  String get notificationsTitle => 'Notifications';

  @override
  String get markAllRead => 'Mark all read';

  @override
  String get allNotificationsRead => 'All notifications marked as read';

  @override
  String get notificationDeleted => 'Notification deleted';

  @override
  String get noNotifications => 'No Notifications';

  @override
  String get noNotificationsDesc =>
      'You\'re all caught up! Your trip alerts, reminders and incident reports will appear here.';

  @override
  String loadingError(String error) {
    return 'Loading error: $error';
  }

  @override
  String get myReservationsTitle => 'My Reservations';

  @override
  String get tabValidated => 'Validated';

  @override
  String get tabPending => 'Pending';

  @override
  String get tabCancelled => 'Cancelled';

  @override
  String get statusValidated => 'Validated';

  @override
  String get statusCancelled => 'Cancelled';

  @override
  String get statusPending => 'Pending';

  @override
  String get noReservationValidated => 'No validated reservation';

  @override
  String get noReservationCancelled => 'No cancelled reservation';

  @override
  String get noReservationPending => 'No pending reservation';

  @override
  String get errorPrefix2 => 'Error: ';

  @override
  String seatLabel(String place) {
    return 'Seat #$place';
  }

  @override
  String referenceLabel(String ref) {
    return 'Reference: $ref';
  }

  @override
  String get newsTitle => 'News';

  @override
  String get newsHeaderTitle => 'The Traveller\'s Journal';

  @override
  String get newsHeaderSubtitle =>
      'Latest updates from your favourite agencies';

  @override
  String get justNow => 'Just now';

  @override
  String minutesAgo(int count) {
    return '$count min ago';
  }

  @override
  String hoursAgo(int count) {
    return '$count h ago';
  }

  @override
  String daysAgo(int count) {
    return '$count d ago';
  }

  @override
  String get myColisTitle => 'My Parcels';

  @override
  String get tabSent => 'Sent';

  @override
  String get tabToReceive => 'To receive';

  @override
  String get pleaseLogin => 'Please log in';

  @override
  String get noColisSent => 'No parcel sent';

  @override
  String get noColisToReceive => 'No parcel to receive';

  @override
  String colisRef(int id) {
    return 'Ref: #C-$id';
  }

  @override
  String get colisOrigin => 'Origin';

  @override
  String get colisDestination => 'Destination';

  @override
  String colisRecipient(String name) {
    return 'Recipient: $name';
  }

  @override
  String colisSender(String name) {
    return 'Sender: $name';
  }

  @override
  String get colisStatusPending => 'Pending';

  @override
  String get colisStatusDelivered => 'Delivered';

  @override
  String get colisStatusInTransit => 'In transit';

  @override
  String get chatbotTitle => 'AI Assistant';

  @override
  String get chatbotGreeting =>
      'Hello! I am your CamerTrip assistant powered by advanced AI. How can I help you today?';

  @override
  String get chatbotTyping => 'AI is thinking...';

  @override
  String get chatbotHint => 'Ask your question...';

  @override
  String get chatbotQ1 => 'What trips are available tomorrow?';

  @override
  String get chatbotQ2 => 'What are my reservations?';

  @override
  String get chatbotQ3 => 'Where are your agencies?';

  @override
  String get tabStations => 'Stations';

  @override
  String get tabUpcoming => 'Upcoming';

  @override
  String get tabRoutes => 'Routes';

  @override
  String get noStationFound => 'No station found';

  @override
  String get noUpcomingTrip => 'No upcoming trip';

  @override
  String get noRouteAvailable => 'No route available';

  @override
  String seatsAvailable(int count) {
    return '$count seats available';
  }

  @override
  String get tripFull => 'Trip Full';

  @override
  String get book => 'Book';

  @override
  String get full => 'Full';

  @override
  String get gevNetwork => 'CamerTrip Network';

  @override
  String get chooseSeatTitle => 'Seat selection';

  @override
  String departure(String time) {
    return 'Departure: $time';
  }

  @override
  String get door => 'Door';

  @override
  String get legendFree => 'Free';

  @override
  String get legendSelected => 'Selected';

  @override
  String get legendOccupied => 'Occupied';

  @override
  String get legendStaff => 'Staff';

  @override
  String get legendDoor => 'Door';

  @override
  String get selectedSeat => 'Selected seat:';

  @override
  String get noSeat => 'None';

  @override
  String selectedSeatValue(String seat) {
    return 'Seat #$seat';
  }

  @override
  String get continueToPayment => 'CONTINUE TO PAYMENT';

  @override
  String get paymentTitle => 'Payment';

  @override
  String get paymentPhoneLabel => 'Payment phone number';

  @override
  String get paymentPhoneHint => '6xx xxx xxx';

  @override
  String get paymentEnterPhone => 'Please enter your payment number';

  @override
  String get paymentInvalidPhone => 'Invalid number. Format: 6xx xxx xxx';

  @override
  String get paymentValidationTitle => 'Payment Validation';

  @override
  String paymentUssdMessage(String phone) {
    return 'A USSD payment prompt has been sent to:\n$phone';
  }

  @override
  String paymentUssdCode(String code) {
    return 'USSD Code: $code';
  }

  @override
  String get paymentUssdTip =>
      'Dial this code if the payment prompt does not appear automatically.';

  @override
  String paymentPinPrompt(int amount) {
    return 'Enter your PIN on your phone to authorise a debit of $amount FCFA.';
  }

  @override
  String get paymentCheckingStatus => 'Checking payment status...';

  @override
  String get paymentCloseRetry => 'Close / Retry';

  @override
  String get paymentTimeout => 'Payment timed out. Please check your tickets.';

  @override
  String paymentError(String message) {
    return 'Error: $message';
  }

  @override
  String get paymentFailedGeneric => 'The payment failed.';

  @override
  String get paymentFailedInsufficientBalance =>
      'Failed: Insufficient balance.';

  @override
  String get paymentFailedLimitExceeded =>
      'Failed: Transaction limit exceeded.';

  @override
  String get paymentFailedRefused => 'Failed: Transaction refused by user.';

  @override
  String paymentFailedReason(String reason) {
    return 'Failed: $reason';
  }

  @override
  String get summaryRoute => 'Route';

  @override
  String get summarySeat => 'Selected seat';

  @override
  String get summaryTotal => 'Total Amount';

  @override
  String get bookingSuccess => 'Booking Successful!';

  @override
  String bookingSuccessMessage(String seat) {
    return 'Your ticket for seat #$seat is awaiting final payment. Check your tickets for more details.';
  }

  @override
  String get backToHome => 'BACK TO HOME';

  @override
  String get confirmPayment => 'CONFIRM PAYMENT';

  @override
  String get virtualTicketTitle => 'Virtual Ticket';

  @override
  String get finalizePaymentTitle => 'Finalize Payment';

  @override
  String get finalizePaymentSubtitle =>
      'Complete your payment to permanently secure your seat.';

  @override
  String get paymentPhoneNumber => 'Phone number';

  @override
  String get confirmAndPay => 'CONFIRM & PAY';

  @override
  String ticketSeat(String seat) {
    return 'Seat #$seat';
  }

  @override
  String get ticketDate => 'Date';

  @override
  String get ticketTime => 'Time';

  @override
  String get ticketSeatLabel => 'Seat';

  @override
  String get ticketPassenger => 'Passenger';

  @override
  String get ticketPassengerValue => 'Client (Me)';

  @override
  String get ticketPricePaid => 'Price paid';

  @override
  String ticketReference(int id) {
    return 'Reference: $id';
  }

  @override
  String get payThisTicket => 'PAY THIS TICKET';

  @override
  String get downloadPdf => 'Download PDF Ticket';

  @override
  String get downloading => 'Downloading...';

  @override
  String get rebookTrip => 'Book this trip again';

  @override
  String get ticketPdfReady => 'PDF ticket ready! 📄';

  @override
  String downloadError(String error) {
    return 'Download error: $error';
  }

  @override
  String get paymentDone => 'Payment Complete!';

  @override
  String get paymentDoneMessage =>
      'Your seat is now validated. The QR code has been activated on your ticket.';

  @override
  String get paymentRequired => 'Payment required to generate the QR Code.';

  @override
  String get reservationExpired =>
      'Reservation expired because the trip has started, ended or was cancelled.';

  @override
  String get voyageCancelled =>
      'The trip has been cancelled. This ticket can no longer be paid.';

  @override
  String get voyageStarted =>
      'The trip has already started or ended. This ticket can no longer be paid.';

  @override
  String get paymentTimeout2 => 'Payment timed out.';

  @override
  String ussdPromptMessage(String phone) {
    return 'A USSD payment prompt has been sent to:\n$phone';
  }

  @override
  String get editProfileTitle => 'Edit Profile';

  @override
  String get profileUpdatedSuccess => 'Profile updated successfully';

  @override
  String get profileUpdatedError => 'Failed to update profile';

  @override
  String get editProfileNote =>
      'Note: Some information such as your registration number or your role cannot be modified manually.';

  @override
  String get fieldRequired => 'This field is required';

  @override
  String get dobFormatHint => 'YYYY-MM-DD';

  @override
  String get faqTitle => 'Frequently Asked Questions 🤔';

  @override
  String get faqSubtitle => 'Everything you need to know about CamerTrip.';

  @override
  String get contactSupport => 'Contact Support';

  @override
  String get contactSupportDesc =>
      'Our customer service is available 24/7. Click on a contact method to copy it.';

  @override
  String get directCall => 'Direct Call';

  @override
  String get whatsappSupport => 'WhatsApp Support';

  @override
  String get emailAddressLabel => 'Email Address';

  @override
  String get aiAssistantLabel => 'AI Assistant';

  @override
  String get aiAssistantDesc => 'Available via the Assistant tab';

  @override
  String get closeBtn => 'CLOSE';

  @override
  String copiedToClipboard(String label) {
    return '$label copied to clipboard!';
  }

  @override
  String get stillNeedHelp => 'Still need help?';

  @override
  String get supportAvailabilityDesc =>
      'Our customer support team is available 24/7 to assist you at any time.';

  @override
  String get contactSupportBtn => 'CONTACT SUPPORT';

  @override
  String get faqQ1 => 'How do I make a booking?';

  @override
  String get faqA1 =>
      'Search for a trip on the home page, select the journey that suits you, choose your seat and proceed with payment via Orange Money or MTN Mobile Money.';

  @override
  String get faqQ2 => 'What payment methods are accepted?';

  @override
  String get faqA2 =>
      'We accept Orange Money (OM) and MTN Mobile Money (MoMo). Payments are fully secure, encrypted, and processed instantly.';

  @override
  String get faqQ3 => 'No USSD code received during payment?';

  @override
  String get faqA3 =>
      'If the USSD confirmation prompt does not display automatically, don\'t worry! Manually dial your operator\'s backup code (*126# for MTN or #150*4*4# for Orange) to authorize the transaction within a few minutes.';

  @override
  String get faqQ4 =>
      'How long before departure should I arrive at the station?';

  @override
  String get faqA4 =>
      'We strongly advise arriving at the boarding station at least 45 minutes before departure to check-in baggage and validate your digital ticket.';

  @override
  String get faqQ5 => 'How do I get my ticket after purchase?';

  @override
  String get faqA5 =>
      'Your digital ticket is generated instantly after payment validation. You can find it under the \"Tickets\" tab in the form of a QR Code to present at the boarding gate.';

  @override
  String get faqQ6 => 'Can I cancel or reschedule a trip?';

  @override
  String get faqA6 =>
      'You can cancel or request a reschedule up to 24 hours before departure from your reservation details under the \"Tickets\" tab. A small cancellation fee may be charged by the agency.';

  @override
  String appVersionString(String version) {
    return 'Version $version';
  }

  @override
  String get ourMissionTitle => 'Our Mission 🚀';

  @override
  String get ourMissionContent =>
      'Simplify the life of travelers in Cameroon by providing an intuitive, secure, and fast bus booking platform. No more queuing for hours!';

  @override
  String get ourVisionTitle => 'Our Vision 🌍';

  @override
  String get ourVisionContent =>
      'Become the leader in digital mobility in Cameroon and Central Africa by connecting all transport agencies through a unique and premium interface.';

  @override
  String get copyrightText =>
      '©2026 CamerTrip - All rights reserved\nMade with ❤️ in Cameroon';
}
