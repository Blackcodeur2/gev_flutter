import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:intl/intl.dart' as intl;

import 'app_localizations_en.dart';
import 'app_localizations_fr.dart';

// ignore_for_file: type=lint

/// Callers can lookup localized strings with an instance of AppLocalizations
/// returned by `AppLocalizations.of(context)`.
///
/// Applications need to include `AppLocalizations.delegate()` in their app's
/// `localizationDelegates` list, and the locales they support in the app's
/// `supportedLocales` list. For example:
///
/// ```dart
/// import 'l10n/app_localizations.dart';
///
/// return MaterialApp(
///   localizationsDelegates: AppLocalizations.localizationsDelegates,
///   supportedLocales: AppLocalizations.supportedLocales,
///   home: MyApplicationHome(),
/// );
/// ```
///
/// ## Update pubspec.yaml
///
/// Please make sure to update your pubspec.yaml to include the following
/// packages:
///
/// ```yaml
/// dependencies:
///   # Internationalization support.
///   flutter_localizations:
///     sdk: flutter
///   intl: any # Use the pinned version from flutter_localizations
///
///   # Rest of dependencies
/// ```
///
/// ## iOS Applications
///
/// iOS applications define key application metadata, including supported
/// locales, in an Info.plist file that is built into the application bundle.
/// To configure the locales supported by your app, you’ll need to edit this
/// file.
///
/// First, open your project’s ios/Runner.xcworkspace Xcode workspace file.
/// Then, in the Project Navigator, open the Info.plist file under the Runner
/// project’s Runner folder.
///
/// Next, select the Information Property List item, select Add Item from the
/// Editor menu, then select Localizations from the pop-up menu.
///
/// Select and expand the newly-created Localizations item then, for each
/// locale your application supports, add a new item and select the locale
/// you wish to add from the pop-up menu in the Value field. This list should
/// be consistent with the languages listed in the AppLocalizations.supportedLocales
/// property.
abstract class AppLocalizations {
  AppLocalizations(String locale)
    : localeName = intl.Intl.canonicalizedLocale(locale.toString());

  final String localeName;

  static AppLocalizations? of(BuildContext context) {
    return Localizations.of<AppLocalizations>(context, AppLocalizations);
  }

  static const LocalizationsDelegate<AppLocalizations> delegate =
      _AppLocalizationsDelegate();

  /// A list of this localizations delegate along with the default localizations
  /// delegates.
  ///
  /// Returns a list of localizations delegates containing this delegate along with
  /// GlobalMaterialLocalizations.delegate, GlobalCupertinoLocalizations.delegate,
  /// and GlobalWidgetsLocalizations.delegate.
  ///
  /// Additional delegates can be added by appending to this list in
  /// MaterialApp. This list does not have to be used at all if a custom list
  /// of delegates is preferred or required.
  static const List<LocalizationsDelegate<dynamic>> localizationsDelegates =
      <LocalizationsDelegate<dynamic>>[
        delegate,
        GlobalMaterialLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
      ];

  /// A list of this localizations delegate's supported locales.
  static const List<Locale> supportedLocales = <Locale>[
    Locale('en'),
    Locale('fr'),
  ];

  /// No description provided for @appName.
  ///
  /// In en, this message translates to:
  /// **'CamerTrip'**
  String get appName;

  /// No description provided for @settingsTitle.
  ///
  /// In en, this message translates to:
  /// **'Settings'**
  String get settingsTitle;

  /// No description provided for @language.
  ///
  /// In en, this message translates to:
  /// **'Language'**
  String get language;

  /// No description provided for @french.
  ///
  /// In en, this message translates to:
  /// **'French'**
  String get french;

  /// No description provided for @english.
  ///
  /// In en, this message translates to:
  /// **'English'**
  String get english;

  /// No description provided for @home.
  ///
  /// In en, this message translates to:
  /// **'Home'**
  String get home;

  /// No description provided for @profile.
  ///
  /// In en, this message translates to:
  /// **'Profile'**
  String get profile;

  /// No description provided for @onboardingTitle1.
  ///
  /// In en, this message translates to:
  /// **'Welcome to CamerTrip'**
  String get onboardingTitle1;

  /// No description provided for @onboardingDesc1.
  ///
  /// In en, this message translates to:
  /// **'Discover the best places in Cameroon'**
  String get onboardingDesc1;

  /// No description provided for @onboardingTitle2.
  ///
  /// In en, this message translates to:
  /// **'Travel easily'**
  String get onboardingTitle2;

  /// No description provided for @onboardingDesc2.
  ///
  /// In en, this message translates to:
  /// **'Plan your trips in a few clicks'**
  String get onboardingDesc2;

  /// No description provided for @onboardingTitle3.
  ///
  /// In en, this message translates to:
  /// **'Start now'**
  String get onboardingTitle3;

  /// No description provided for @onboardingDesc3.
  ///
  /// In en, this message translates to:
  /// **'A new adventure awaits 🚀'**
  String get onboardingDesc3;

  /// No description provided for @skip.
  ///
  /// In en, this message translates to:
  /// **'Skip'**
  String get skip;

  /// No description provided for @start.
  ///
  /// In en, this message translates to:
  /// **'Start'**
  String get start;

  /// No description provided for @next.
  ///
  /// In en, this message translates to:
  /// **'Next'**
  String get next;

  /// No description provided for @loginTitle.
  ///
  /// In en, this message translates to:
  /// **'Login'**
  String get loginTitle;

  /// No description provided for @loginSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Welcome back 👋 Good to see you again.'**
  String get loginSubtitle;

  /// No description provided for @emailLabel.
  ///
  /// In en, this message translates to:
  /// **'Email address'**
  String get emailLabel;

  /// No description provided for @emailHint.
  ///
  /// In en, this message translates to:
  /// **'example@email.com'**
  String get emailHint;

  /// No description provided for @emailRequired.
  ///
  /// In en, this message translates to:
  /// **'Please enter your email'**
  String get emailRequired;

  /// No description provided for @emailInvalid.
  ///
  /// In en, this message translates to:
  /// **'Invalid email'**
  String get emailInvalid;

  /// No description provided for @passwordLabel.
  ///
  /// In en, this message translates to:
  /// **'Password'**
  String get passwordLabel;

  /// No description provided for @forgotPassword.
  ///
  /// In en, this message translates to:
  /// **'Forgot password?'**
  String get forgotPassword;

  /// No description provided for @passwordRequired.
  ///
  /// In en, this message translates to:
  /// **'Please enter your password'**
  String get passwordRequired;

  /// No description provided for @passwordMinLength.
  ///
  /// In en, this message translates to:
  /// **'Minimum 6 characters'**
  String get passwordMinLength;

  /// No description provided for @rememberMe.
  ///
  /// In en, this message translates to:
  /// **'Remember me'**
  String get rememberMe;

  /// No description provided for @loginButton.
  ///
  /// In en, this message translates to:
  /// **'LOGIN'**
  String get loginButton;

  /// No description provided for @orContinueWith.
  ///
  /// In en, this message translates to:
  /// **'OR CONTINUE WITH'**
  String get orContinueWith;

  /// No description provided for @noAccount.
  ///
  /// In en, this message translates to:
  /// **'Don\'t have an account yet? '**
  String get noAccount;

  /// No description provided for @registerLink.
  ///
  /// In en, this message translates to:
  /// **'Sign up'**
  String get registerLink;

  /// No description provided for @heroSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Travel smart in Cameroon 🌍'**
  String get heroSubtitle;

  /// No description provided for @registerTitle.
  ///
  /// In en, this message translates to:
  /// **'Sign up'**
  String get registerTitle;

  /// No description provided for @registerSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Complete your details 🚀'**
  String get registerSubtitle;

  /// No description provided for @orRegisterWith.
  ///
  /// In en, this message translates to:
  /// **'OR SIGN UP WITH'**
  String get orRegisterWith;

  /// No description provided for @continueWithGoogle.
  ///
  /// In en, this message translates to:
  /// **'CONTINUE WITH GOOGLE'**
  String get continueWithGoogle;

  /// No description provided for @identitySection.
  ///
  /// In en, this message translates to:
  /// **'Identity'**
  String get identitySection;

  /// No description provided for @lastName.
  ///
  /// In en, this message translates to:
  /// **'Last Name'**
  String get lastName;

  /// No description provided for @firstName.
  ///
  /// In en, this message translates to:
  /// **'First Name'**
  String get firstName;

  /// No description provided for @requiredField.
  ///
  /// In en, this message translates to:
  /// **'Required'**
  String get requiredField;

  /// No description provided for @genderSection.
  ///
  /// In en, this message translates to:
  /// **'Gender'**
  String get genderSection;

  /// No description provided for @male.
  ///
  /// In en, this message translates to:
  /// **'Male'**
  String get male;

  /// No description provided for @female.
  ///
  /// In en, this message translates to:
  /// **'Female'**
  String get female;

  /// No description provided for @birthDate.
  ///
  /// In en, this message translates to:
  /// **'Date of birth'**
  String get birthDate;

  /// No description provided for @dateRequired.
  ///
  /// In en, this message translates to:
  /// **'Date required'**
  String get dateRequired;

  /// No description provided for @contactSection.
  ///
  /// In en, this message translates to:
  /// **'Contact'**
  String get contactSection;

  /// No description provided for @emailPlaceholder.
  ///
  /// In en, this message translates to:
  /// **'Email'**
  String get emailPlaceholder;

  /// No description provided for @invalidFormat.
  ///
  /// In en, this message translates to:
  /// **'Invalid format'**
  String get invalidFormat;

  /// No description provided for @phonePlaceholder.
  ///
  /// In en, this message translates to:
  /// **'Phone number'**
  String get phonePlaceholder;

  /// No description provided for @phoneRequired.
  ///
  /// In en, this message translates to:
  /// **'Phone required'**
  String get phoneRequired;

  /// No description provided for @securitySection.
  ///
  /// In en, this message translates to:
  /// **'Security'**
  String get securitySection;

  /// No description provided for @min8Chars.
  ///
  /// In en, this message translates to:
  /// **'Min. 8 characters'**
  String get min8Chars;

  /// No description provided for @confirmPassword.
  ///
  /// In en, this message translates to:
  /// **'Confirm password'**
  String get confirmPassword;

  /// No description provided for @notIdentical.
  ///
  /// In en, this message translates to:
  /// **'Passwords do not match'**
  String get notIdentical;

  /// No description provided for @veryWeak.
  ///
  /// In en, this message translates to:
  /// **'Very weak'**
  String get veryWeak;

  /// No description provided for @weak.
  ///
  /// In en, this message translates to:
  /// **'Weak'**
  String get weak;

  /// No description provided for @medium.
  ///
  /// In en, this message translates to:
  /// **'Medium'**
  String get medium;

  /// No description provided for @strong.
  ///
  /// In en, this message translates to:
  /// **'Strong'**
  String get strong;

  /// No description provided for @acceptTerms.
  ///
  /// In en, this message translates to:
  /// **'I accept the terms of use and the privacy policy.'**
  String get acceptTerms;

  /// No description provided for @createAccountBtn.
  ///
  /// In en, this message translates to:
  /// **'CREATE MY ACCOUNT'**
  String get createAccountBtn;

  /// No description provided for @alreadyHaveAccount.
  ///
  /// In en, this message translates to:
  /// **'Already have an account? '**
  String get alreadyHaveAccount;

  /// No description provided for @loginLink.
  ///
  /// In en, this message translates to:
  /// **'Log in'**
  String get loginLink;

  /// No description provided for @createAccountHeader.
  ///
  /// In en, this message translates to:
  /// **'CREATE AN ACCOUNT'**
  String get createAccountHeader;

  /// No description provided for @splashSlogan.
  ///
  /// In en, this message translates to:
  /// **'🌍 Travel easily in Cameroon'**
  String get splashSlogan;

  /// No description provided for @loading.
  ///
  /// In en, this message translates to:
  /// **'Loading...'**
  String get loading;

  /// No description provided for @termsRequired.
  ///
  /// In en, this message translates to:
  /// **'Please accept the terms of use'**
  String get termsRequired;

  /// No description provided for @registerSuccess.
  ///
  /// In en, this message translates to:
  /// **'Registration successful. Please check your email.'**
  String get registerSuccess;

  /// No description provided for @errorPrefix.
  ///
  /// In en, this message translates to:
  /// **'Error: '**
  String get errorPrefix;

  /// No description provided for @unknownError.
  ///
  /// In en, this message translates to:
  /// **'Unknown error'**
  String get unknownError;

  /// No description provided for @googleError.
  ///
  /// In en, this message translates to:
  /// **'Google Error'**
  String get googleError;

  /// No description provided for @success.
  ///
  /// In en, this message translates to:
  /// **'Success'**
  String get success;

  /// No description provided for @ok.
  ///
  /// In en, this message translates to:
  /// **'OK'**
  String get ok;

  /// No description provided for @changePasswordTitle.
  ///
  /// In en, this message translates to:
  /// **'Change password'**
  String get changePasswordTitle;

  /// No description provided for @currentPassword.
  ///
  /// In en, this message translates to:
  /// **'Current password'**
  String get currentPassword;

  /// No description provided for @noPasswordSet.
  ///
  /// In en, this message translates to:
  /// **'You have not set a password yet. Please create one to secure your account.'**
  String get noPasswordSet;

  /// No description provided for @newPassword.
  ///
  /// In en, this message translates to:
  /// **'New password'**
  String get newPassword;

  /// No description provided for @confirmNewPassword.
  ///
  /// In en, this message translates to:
  /// **'Confirm new password'**
  String get confirmNewPassword;

  /// No description provided for @passwordsDoNotMatch.
  ///
  /// In en, this message translates to:
  /// **'Passwords do not match'**
  String get passwordsDoNotMatch;

  /// No description provided for @updateBtn.
  ///
  /// In en, this message translates to:
  /// **'UPDATE'**
  String get updateBtn;

  /// No description provided for @passwordSecurityInfo.
  ///
  /// In en, this message translates to:
  /// **'For security reasons, choose a strong password of at least 8 characters.'**
  String get passwordSecurityInfo;

  /// No description provided for @passwordChangedSuccess.
  ///
  /// In en, this message translates to:
  /// **'Password successfully changed!'**
  String get passwordChangedSuccess;

  /// No description provided for @passwordChangeError.
  ///
  /// In en, this message translates to:
  /// **'Error while changing password'**
  String get passwordChangeError;

  /// No description provided for @codeSentSuccess.
  ///
  /// In en, this message translates to:
  /// **'Code sent successfully'**
  String get codeSentSuccess;

  /// No description provided for @sendCodeError.
  ///
  /// In en, this message translates to:
  /// **'Error sending code'**
  String get sendCodeError;

  /// No description provided for @resetError.
  ///
  /// In en, this message translates to:
  /// **'Reset error'**
  String get resetError;

  /// No description provided for @resetSuccessMessage.
  ///
  /// In en, this message translates to:
  /// **'Your password has been successfully reset. You can now log in.'**
  String get resetSuccessMessage;

  /// No description provided for @loginBtn.
  ///
  /// In en, this message translates to:
  /// **'LOG IN'**
  String get loginBtn;

  /// No description provided for @resetTitle.
  ///
  /// In en, this message translates to:
  /// **'Reset'**
  String get resetTitle;

  /// No description provided for @forgotPasswordTitle.
  ///
  /// In en, this message translates to:
  /// **'Forgot password'**
  String get forgotPasswordTitle;

  /// No description provided for @enterCodeAndNewPassword.
  ///
  /// In en, this message translates to:
  /// **'Enter the code received and your new password.'**
  String get enterCodeAndNewPassword;

  /// No description provided for @enterEmailForCode.
  ///
  /// In en, this message translates to:
  /// **'Enter your email to receive the reset code.'**
  String get enterEmailForCode;

  /// No description provided for @yourEmailAddress.
  ///
  /// In en, this message translates to:
  /// **'Your email address'**
  String get yourEmailAddress;

  /// No description provided for @sendCodeBtn.
  ///
  /// In en, this message translates to:
  /// **'SEND CODE'**
  String get sendCodeBtn;

  /// No description provided for @sixDigitCode.
  ///
  /// In en, this message translates to:
  /// **'6-digit code'**
  String get sixDigitCode;

  /// No description provided for @resetBtn.
  ///
  /// In en, this message translates to:
  /// **'RESET'**
  String get resetBtn;

  /// No description provided for @changeEmail.
  ///
  /// In en, this message translates to:
  /// **'Change email'**
  String get changeEmail;

  /// No description provided for @emailVerifiedViaLink.
  ///
  /// In en, this message translates to:
  /// **'Email successfully verified via link!'**
  String get emailVerifiedViaLink;

  /// No description provided for @invalidLink.
  ///
  /// In en, this message translates to:
  /// **'Invalid link'**
  String get invalidLink;

  /// No description provided for @emailVerifiedSuccess.
  ///
  /// In en, this message translates to:
  /// **'Email successfully verified!'**
  String get emailVerifiedSuccess;

  /// No description provided for @invalidCode.
  ///
  /// In en, this message translates to:
  /// **'Invalid code'**
  String get invalidCode;

  /// No description provided for @codeResent.
  ///
  /// In en, this message translates to:
  /// **'Code resent'**
  String get codeResent;

  /// No description provided for @verificationTitle.
  ///
  /// In en, this message translates to:
  /// **'Verification'**
  String get verificationTitle;

  /// No description provided for @checkYourInbox.
  ///
  /// In en, this message translates to:
  /// **'Check your inbox'**
  String get checkYourInbox;

  /// No description provided for @codeSentMessage.
  ///
  /// In en, this message translates to:
  /// **'We sent a verification code to {email}. Please enter it below.'**
  String codeSentMessage(String email);

  /// No description provided for @verificationCodeLabel.
  ///
  /// In en, this message translates to:
  /// **'Verification code'**
  String get verificationCodeLabel;

  /// No description provided for @verifyBtn.
  ///
  /// In en, this message translates to:
  /// **'Verify'**
  String get verifyBtn;

  /// No description provided for @resendCodeInstructions.
  ///
  /// In en, this message translates to:
  /// **'I didn\'t receive a code. Resend.'**
  String get resendCodeInstructions;

  /// No description provided for @upcomingTripsTitle.
  ///
  /// In en, this message translates to:
  /// **'📅 Upcoming Trips'**
  String get upcomingTripsTitle;

  /// No description provided for @partnerAgenciesTitle.
  ///
  /// In en, this message translates to:
  /// **'🏢 Partner Agencies'**
  String get partnerAgenciesTitle;

  /// No description provided for @currentReservationsTitle.
  ///
  /// In en, this message translates to:
  /// **'🎟️ Current Reservation'**
  String get currentReservationsTitle;

  /// No description provided for @filterTypeTripComingSoon.
  ///
  /// In en, this message translates to:
  /// **'Filter by trip type \"{label}\" coming soon! 🚌'**
  String filterTypeTripComingSoon(String label);

  /// No description provided for @stationsCountNational.
  ///
  /// In en, this message translates to:
  /// **'{count} stations • National Network'**
  String stationsCountNational(int count);

  /// No description provided for @sectionAppearance.
  ///
  /// In en, this message translates to:
  /// **'Appearance & System'**
  String get sectionAppearance;

  /// No description provided for @darkMode.
  ///
  /// In en, this message translates to:
  /// **'Dark Mode'**
  String get darkMode;

  /// No description provided for @darkModeEnabled.
  ///
  /// In en, this message translates to:
  /// **'Enabled'**
  String get darkModeEnabled;

  /// No description provided for @darkModeDisabled.
  ///
  /// In en, this message translates to:
  /// **'Disabled'**
  String get darkModeDisabled;

  /// No description provided for @notifications.
  ///
  /// In en, this message translates to:
  /// **'Notifications'**
  String get notifications;

  /// No description provided for @notificationsSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Alerts and Push'**
  String get notificationsSubtitle;

  /// No description provided for @sectionSecurity.
  ///
  /// In en, this message translates to:
  /// **'Security'**
  String get sectionSecurity;

  /// No description provided for @password.
  ///
  /// In en, this message translates to:
  /// **'Password'**
  String get password;

  /// No description provided for @changePasswordSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Change my password'**
  String get changePasswordSubtitle;

  /// No description provided for @sectionActivities.
  ///
  /// In en, this message translates to:
  /// **'My Activities'**
  String get sectionActivities;

  /// No description provided for @myParcels.
  ///
  /// In en, this message translates to:
  /// **'My Parcels'**
  String get myParcels;

  /// No description provided for @myParcelsSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Track my shipments and receipts'**
  String get myParcelsSubtitle;

  /// No description provided for @sectionSupport.
  ///
  /// In en, this message translates to:
  /// **'Support'**
  String get sectionSupport;

  /// No description provided for @helpCenter.
  ///
  /// In en, this message translates to:
  /// **'Help Center'**
  String get helpCenter;

  /// No description provided for @helpCenterSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Frequently asked questions'**
  String get helpCenterSubtitle;

  /// No description provided for @about.
  ///
  /// In en, this message translates to:
  /// **'About'**
  String get about;

  /// No description provided for @logout.
  ///
  /// In en, this message translates to:
  /// **'Log out'**
  String get logout;

  /// No description provided for @notConnected.
  ///
  /// In en, this message translates to:
  /// **'Not connected'**
  String get notConnected;

  /// No description provided for @sessionExpired.
  ///
  /// In en, this message translates to:
  /// **'Session expired'**
  String get sessionExpired;

  /// No description provided for @noInternetTitle.
  ///
  /// In en, this message translates to:
  /// **'No connection'**
  String get noInternetTitle;

  /// No description provided for @noInternetMessage.
  ///
  /// In en, this message translates to:
  /// **'Check your Wi-Fi or mobile data connection and try again.'**
  String get noInternetMessage;

  /// No description provided for @retryBtn.
  ///
  /// In en, this message translates to:
  /// **'Retry'**
  String get retryBtn;

  /// No description provided for @notificationsTitle.
  ///
  /// In en, this message translates to:
  /// **'Notifications'**
  String get notificationsTitle;

  /// No description provided for @markAllRead.
  ///
  /// In en, this message translates to:
  /// **'Mark all read'**
  String get markAllRead;

  /// No description provided for @allNotificationsRead.
  ///
  /// In en, this message translates to:
  /// **'All notifications marked as read'**
  String get allNotificationsRead;

  /// No description provided for @notificationDeleted.
  ///
  /// In en, this message translates to:
  /// **'Notification deleted'**
  String get notificationDeleted;

  /// No description provided for @noNotifications.
  ///
  /// In en, this message translates to:
  /// **'No Notifications'**
  String get noNotifications;

  /// No description provided for @noNotificationsDesc.
  ///
  /// In en, this message translates to:
  /// **'You\'re all caught up! Your trip alerts, reminders and incident reports will appear here.'**
  String get noNotificationsDesc;

  /// No description provided for @loadingError.
  ///
  /// In en, this message translates to:
  /// **'Loading error: {error}'**
  String loadingError(String error);

  /// No description provided for @myReservationsTitle.
  ///
  /// In en, this message translates to:
  /// **'My Reservations'**
  String get myReservationsTitle;

  /// No description provided for @tabValidated.
  ///
  /// In en, this message translates to:
  /// **'Validated'**
  String get tabValidated;

  /// No description provided for @tabPending.
  ///
  /// In en, this message translates to:
  /// **'Pending'**
  String get tabPending;

  /// No description provided for @tabCancelled.
  ///
  /// In en, this message translates to:
  /// **'Cancelled'**
  String get tabCancelled;

  /// No description provided for @statusValidated.
  ///
  /// In en, this message translates to:
  /// **'Validated'**
  String get statusValidated;

  /// No description provided for @statusCancelled.
  ///
  /// In en, this message translates to:
  /// **'Cancelled'**
  String get statusCancelled;

  /// No description provided for @statusPending.
  ///
  /// In en, this message translates to:
  /// **'Pending'**
  String get statusPending;

  /// No description provided for @noReservationValidated.
  ///
  /// In en, this message translates to:
  /// **'No validated reservation'**
  String get noReservationValidated;

  /// No description provided for @noReservationCancelled.
  ///
  /// In en, this message translates to:
  /// **'No cancelled reservation'**
  String get noReservationCancelled;

  /// No description provided for @noReservationPending.
  ///
  /// In en, this message translates to:
  /// **'No pending reservation'**
  String get noReservationPending;

  /// No description provided for @errorPrefix2.
  ///
  /// In en, this message translates to:
  /// **'Error: '**
  String get errorPrefix2;

  /// No description provided for @seatLabel.
  ///
  /// In en, this message translates to:
  /// **'Seat #{place}'**
  String seatLabel(String place);

  /// No description provided for @referenceLabel.
  ///
  /// In en, this message translates to:
  /// **'Reference: {ref}'**
  String referenceLabel(String ref);

  /// No description provided for @newsTitle.
  ///
  /// In en, this message translates to:
  /// **'News'**
  String get newsTitle;

  /// No description provided for @newsHeaderTitle.
  ///
  /// In en, this message translates to:
  /// **'The Traveller\'s Journal'**
  String get newsHeaderTitle;

  /// No description provided for @newsHeaderSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Latest updates from your favourite agencies'**
  String get newsHeaderSubtitle;

  /// No description provided for @justNow.
  ///
  /// In en, this message translates to:
  /// **'Just now'**
  String get justNow;

  /// No description provided for @minutesAgo.
  ///
  /// In en, this message translates to:
  /// **'{count} min ago'**
  String minutesAgo(int count);

  /// No description provided for @hoursAgo.
  ///
  /// In en, this message translates to:
  /// **'{count} h ago'**
  String hoursAgo(int count);

  /// No description provided for @daysAgo.
  ///
  /// In en, this message translates to:
  /// **'{count} d ago'**
  String daysAgo(int count);

  /// No description provided for @myColisTitle.
  ///
  /// In en, this message translates to:
  /// **'My Parcels'**
  String get myColisTitle;

  /// No description provided for @tabSent.
  ///
  /// In en, this message translates to:
  /// **'Sent'**
  String get tabSent;

  /// No description provided for @tabToReceive.
  ///
  /// In en, this message translates to:
  /// **'To receive'**
  String get tabToReceive;

  /// No description provided for @pleaseLogin.
  ///
  /// In en, this message translates to:
  /// **'Please log in'**
  String get pleaseLogin;

  /// No description provided for @noColisSent.
  ///
  /// In en, this message translates to:
  /// **'No parcel sent'**
  String get noColisSent;

  /// No description provided for @noColisToReceive.
  ///
  /// In en, this message translates to:
  /// **'No parcel to receive'**
  String get noColisToReceive;

  /// No description provided for @colisRef.
  ///
  /// In en, this message translates to:
  /// **'Ref: #C-{id}'**
  String colisRef(int id);

  /// No description provided for @colisOrigin.
  ///
  /// In en, this message translates to:
  /// **'Origin'**
  String get colisOrigin;

  /// No description provided for @colisDestination.
  ///
  /// In en, this message translates to:
  /// **'Destination'**
  String get colisDestination;

  /// No description provided for @colisRecipient.
  ///
  /// In en, this message translates to:
  /// **'Recipient: {name}'**
  String colisRecipient(String name);

  /// No description provided for @colisSender.
  ///
  /// In en, this message translates to:
  /// **'Sender: {name}'**
  String colisSender(String name);

  /// No description provided for @colisStatusPending.
  ///
  /// In en, this message translates to:
  /// **'Pending'**
  String get colisStatusPending;

  /// No description provided for @colisStatusDelivered.
  ///
  /// In en, this message translates to:
  /// **'Delivered'**
  String get colisStatusDelivered;

  /// No description provided for @colisStatusInTransit.
  ///
  /// In en, this message translates to:
  /// **'In transit'**
  String get colisStatusInTransit;

  /// No description provided for @chatbotTitle.
  ///
  /// In en, this message translates to:
  /// **'AI Assistant'**
  String get chatbotTitle;

  /// No description provided for @chatbotGreeting.
  ///
  /// In en, this message translates to:
  /// **'Hello! I am your CamerTrip assistant powered by advanced AI. How can I help you today?'**
  String get chatbotGreeting;

  /// No description provided for @chatbotTyping.
  ///
  /// In en, this message translates to:
  /// **'AI is thinking...'**
  String get chatbotTyping;

  /// No description provided for @chatbotHint.
  ///
  /// In en, this message translates to:
  /// **'Ask your question...'**
  String get chatbotHint;

  /// No description provided for @chatbotQ1.
  ///
  /// In en, this message translates to:
  /// **'What trips are available tomorrow?'**
  String get chatbotQ1;

  /// No description provided for @chatbotQ2.
  ///
  /// In en, this message translates to:
  /// **'What are my reservations?'**
  String get chatbotQ2;

  /// No description provided for @chatbotQ3.
  ///
  /// In en, this message translates to:
  /// **'Where are your agencies?'**
  String get chatbotQ3;

  /// No description provided for @tabStations.
  ///
  /// In en, this message translates to:
  /// **'Stations'**
  String get tabStations;

  /// No description provided for @tabUpcoming.
  ///
  /// In en, this message translates to:
  /// **'Upcoming'**
  String get tabUpcoming;

  /// No description provided for @tabRoutes.
  ///
  /// In en, this message translates to:
  /// **'Routes'**
  String get tabRoutes;

  /// No description provided for @noStationFound.
  ///
  /// In en, this message translates to:
  /// **'No station found'**
  String get noStationFound;

  /// No description provided for @noUpcomingTrip.
  ///
  /// In en, this message translates to:
  /// **'No upcoming trip'**
  String get noUpcomingTrip;

  /// No description provided for @noRouteAvailable.
  ///
  /// In en, this message translates to:
  /// **'No route available'**
  String get noRouteAvailable;

  /// No description provided for @seatsAvailable.
  ///
  /// In en, this message translates to:
  /// **'{count} seats available'**
  String seatsAvailable(int count);

  /// No description provided for @tripFull.
  ///
  /// In en, this message translates to:
  /// **'Trip Full'**
  String get tripFull;

  /// No description provided for @book.
  ///
  /// In en, this message translates to:
  /// **'Book'**
  String get book;

  /// No description provided for @full.
  ///
  /// In en, this message translates to:
  /// **'Full'**
  String get full;

  /// No description provided for @gevNetwork.
  ///
  /// In en, this message translates to:
  /// **'CamerTrip Network'**
  String get gevNetwork;

  /// No description provided for @chooseSeatTitle.
  ///
  /// In en, this message translates to:
  /// **'Seat selection'**
  String get chooseSeatTitle;

  /// No description provided for @departure.
  ///
  /// In en, this message translates to:
  /// **'Departure: {time}'**
  String departure(String time);

  /// No description provided for @door.
  ///
  /// In en, this message translates to:
  /// **'Door'**
  String get door;

  /// No description provided for @legendFree.
  ///
  /// In en, this message translates to:
  /// **'Free'**
  String get legendFree;

  /// No description provided for @legendSelected.
  ///
  /// In en, this message translates to:
  /// **'Selected'**
  String get legendSelected;

  /// No description provided for @legendOccupied.
  ///
  /// In en, this message translates to:
  /// **'Occupied'**
  String get legendOccupied;

  /// No description provided for @legendStaff.
  ///
  /// In en, this message translates to:
  /// **'Staff'**
  String get legendStaff;

  /// No description provided for @legendDoor.
  ///
  /// In en, this message translates to:
  /// **'Door'**
  String get legendDoor;

  /// No description provided for @selectedSeat.
  ///
  /// In en, this message translates to:
  /// **'Selected seat:'**
  String get selectedSeat;

  /// No description provided for @noSeat.
  ///
  /// In en, this message translates to:
  /// **'None'**
  String get noSeat;

  /// No description provided for @selectedSeatValue.
  ///
  /// In en, this message translates to:
  /// **'Seat #{seat}'**
  String selectedSeatValue(String seat);

  /// No description provided for @continueToPayment.
  ///
  /// In en, this message translates to:
  /// **'CONTINUE TO PAYMENT'**
  String get continueToPayment;

  /// No description provided for @paymentTitle.
  ///
  /// In en, this message translates to:
  /// **'Payment'**
  String get paymentTitle;

  /// No description provided for @paymentPhoneLabel.
  ///
  /// In en, this message translates to:
  /// **'Payment phone number'**
  String get paymentPhoneLabel;

  /// No description provided for @paymentPhoneHint.
  ///
  /// In en, this message translates to:
  /// **'6xx xxx xxx'**
  String get paymentPhoneHint;

  /// No description provided for @paymentEnterPhone.
  ///
  /// In en, this message translates to:
  /// **'Please enter your payment number'**
  String get paymentEnterPhone;

  /// No description provided for @paymentInvalidPhone.
  ///
  /// In en, this message translates to:
  /// **'Invalid number. Format: 6xx xxx xxx'**
  String get paymentInvalidPhone;

  /// No description provided for @paymentValidationTitle.
  ///
  /// In en, this message translates to:
  /// **'Payment Validation'**
  String get paymentValidationTitle;

  /// No description provided for @paymentUssdMessage.
  ///
  /// In en, this message translates to:
  /// **'A USSD payment prompt has been sent to:\n{phone}'**
  String paymentUssdMessage(String phone);

  /// No description provided for @paymentUssdCode.
  ///
  /// In en, this message translates to:
  /// **'USSD Code: {code}'**
  String paymentUssdCode(String code);

  /// No description provided for @paymentUssdTip.
  ///
  /// In en, this message translates to:
  /// **'Dial this code if the payment prompt does not appear automatically.'**
  String get paymentUssdTip;

  /// No description provided for @paymentPinPrompt.
  ///
  /// In en, this message translates to:
  /// **'Enter your PIN on your phone to authorise a debit of {amount} FCFA.'**
  String paymentPinPrompt(int amount);

  /// No description provided for @paymentCheckingStatus.
  ///
  /// In en, this message translates to:
  /// **'Checking payment status...'**
  String get paymentCheckingStatus;

  /// No description provided for @paymentCloseRetry.
  ///
  /// In en, this message translates to:
  /// **'Close / Retry'**
  String get paymentCloseRetry;

  /// No description provided for @paymentTimeout.
  ///
  /// In en, this message translates to:
  /// **'Payment timed out. Please check your tickets.'**
  String get paymentTimeout;

  /// No description provided for @paymentError.
  ///
  /// In en, this message translates to:
  /// **'Error: {message}'**
  String paymentError(String message);

  /// No description provided for @paymentFailedGeneric.
  ///
  /// In en, this message translates to:
  /// **'The payment failed.'**
  String get paymentFailedGeneric;

  /// No description provided for @paymentFailedInsufficientBalance.
  ///
  /// In en, this message translates to:
  /// **'Failed: Insufficient balance.'**
  String get paymentFailedInsufficientBalance;

  /// No description provided for @paymentFailedLimitExceeded.
  ///
  /// In en, this message translates to:
  /// **'Failed: Transaction limit exceeded.'**
  String get paymentFailedLimitExceeded;

  /// No description provided for @paymentFailedRefused.
  ///
  /// In en, this message translates to:
  /// **'Failed: Transaction refused by user.'**
  String get paymentFailedRefused;

  /// No description provided for @paymentFailedReason.
  ///
  /// In en, this message translates to:
  /// **'Failed: {reason}'**
  String paymentFailedReason(String reason);

  /// No description provided for @summaryRoute.
  ///
  /// In en, this message translates to:
  /// **'Route'**
  String get summaryRoute;

  /// No description provided for @summarySeat.
  ///
  /// In en, this message translates to:
  /// **'Selected seat'**
  String get summarySeat;

  /// No description provided for @summaryTotal.
  ///
  /// In en, this message translates to:
  /// **'Total Amount'**
  String get summaryTotal;

  /// No description provided for @bookingSuccess.
  ///
  /// In en, this message translates to:
  /// **'Booking Successful!'**
  String get bookingSuccess;

  /// No description provided for @bookingSuccessMessage.
  ///
  /// In en, this message translates to:
  /// **'Your ticket for seat #{seat} is awaiting final payment. Check your tickets for more details.'**
  String bookingSuccessMessage(String seat);

  /// No description provided for @backToHome.
  ///
  /// In en, this message translates to:
  /// **'BACK TO HOME'**
  String get backToHome;

  /// No description provided for @confirmPayment.
  ///
  /// In en, this message translates to:
  /// **'CONFIRM PAYMENT'**
  String get confirmPayment;
}

class _AppLocalizationsDelegate
    extends LocalizationsDelegate<AppLocalizations> {
  const _AppLocalizationsDelegate();

  @override
  Future<AppLocalizations> load(Locale locale) {
    return SynchronousFuture<AppLocalizations>(lookupAppLocalizations(locale));
  }

  @override
  bool isSupported(Locale locale) =>
      <String>['en', 'fr'].contains(locale.languageCode);

  @override
  bool shouldReload(_AppLocalizationsDelegate old) => false;
}

AppLocalizations lookupAppLocalizations(Locale locale) {
  // Lookup logic when only language code is specified.
  switch (locale.languageCode) {
    case 'en':
      return AppLocalizationsEn();
    case 'fr':
      return AppLocalizationsFr();
  }

  throw FlutterError(
    'AppLocalizations.delegate failed to load unsupported locale "$locale". This is likely '
    'an issue with the localizations generation tool. Please file an issue '
    'on GitHub with a reproducible sample app and the gen-l10n configuration '
    'that was used.',
  );
}
