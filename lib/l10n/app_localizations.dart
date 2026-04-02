import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:intl/intl.dart' as intl;

import 'app_localizations_en.dart';
import 'app_localizations_hi.dart';

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
    Locale('hi')
  ];

  /// No description provided for @app_title.
  ///
  /// In en, this message translates to:
  /// **'RideOn'**
  String get app_title;

  /// No description provided for @search_rides.
  ///
  /// In en, this message translates to:
  /// **'Search Rides'**
  String get search_rides;

  /// No description provided for @my_bookings.
  ///
  /// In en, this message translates to:
  /// **'My Bookings'**
  String get my_bookings;

  /// No description provided for @my_rides.
  ///
  /// In en, this message translates to:
  /// **'My Rides'**
  String get my_rides;

  /// No description provided for @profile.
  ///
  /// In en, this message translates to:
  /// **'Profile'**
  String get profile;

  /// No description provided for @from.
  ///
  /// In en, this message translates to:
  /// **'From'**
  String get from;

  /// No description provided for @to.
  ///
  /// In en, this message translates to:
  /// **'To'**
  String get to;

  /// No description provided for @search.
  ///
  /// In en, this message translates to:
  /// **'Search'**
  String get search;

  /// No description provided for @book_now.
  ///
  /// In en, this message translates to:
  /// **'Book Now'**
  String get book_now;

  /// No description provided for @ride_details.
  ///
  /// In en, this message translates to:
  /// **'Ride Details'**
  String get ride_details;

  /// No description provided for @cancel_booking.
  ///
  /// In en, this message translates to:
  /// **'Cancel Booking'**
  String get cancel_booking;

  /// No description provided for @rate_trip.
  ///
  /// In en, this message translates to:
  /// **'Rate Your Trip'**
  String get rate_trip;

  /// No description provided for @notifications.
  ///
  /// In en, this message translates to:
  /// **'Notifications'**
  String get notifications;

  /// No description provided for @publish.
  ///
  /// In en, this message translates to:
  /// **'Publish'**
  String get publish;

  /// No description provided for @my_published.
  ///
  /// In en, this message translates to:
  /// **'My Rides'**
  String get my_published;

  /// No description provided for @language.
  ///
  /// In en, this message translates to:
  /// **'Language'**
  String get language;

  /// No description provided for @active.
  ///
  /// In en, this message translates to:
  /// **'Active'**
  String get active;

  /// No description provided for @past.
  ///
  /// In en, this message translates to:
  /// **'Past'**
  String get past;

  /// No description provided for @booking_closed.
  ///
  /// In en, this message translates to:
  /// **'Booking Closed'**
  String get booking_closed;

  /// No description provided for @edit_ride.
  ///
  /// In en, this message translates to:
  /// **'Edit Ride'**
  String get edit_ride;

  /// No description provided for @cancel_ride.
  ///
  /// In en, this message translates to:
  /// **'Cancel Ride'**
  String get cancel_ride;

  /// No description provided for @booking_details.
  ///
  /// In en, this message translates to:
  /// **'Booking Details'**
  String get booking_details;

  /// No description provided for @hello_user.
  ///
  /// In en, this message translates to:
  /// **'Hello'**
  String get hello_user;

  /// No description provided for @where_going_today.
  ///
  /// In en, this message translates to:
  /// **'Where are you going today?'**
  String get where_going_today;

  /// No description provided for @nearby_rides.
  ///
  /// In en, this message translates to:
  /// **'Rides Near You'**
  String get nearby_rides;

  /// No description provided for @no_nearby_rides.
  ///
  /// In en, this message translates to:
  /// **'No rides found near your location.'**
  String get no_nearby_rides;

  /// No description provided for @find_a_ride.
  ///
  /// In en, this message translates to:
  /// **'Find a Ride'**
  String get find_a_ride;

  /// No description provided for @welcome_back.
  ///
  /// In en, this message translates to:
  /// **'Welcome Back!'**
  String get welcome_back;

  /// No description provided for @sign_in_continue.
  ///
  /// In en, this message translates to:
  /// **'Sign in to continue your journey'**
  String get sign_in_continue;

  /// No description provided for @enter_email.
  ///
  /// In en, this message translates to:
  /// **'Enter your email'**
  String get enter_email;

  /// No description provided for @enter_password.
  ///
  /// In en, this message translates to:
  /// **'Enter your password'**
  String get enter_password;

  /// No description provided for @forgot_password.
  ///
  /// In en, this message translates to:
  /// **'Forgot Password?'**
  String get forgot_password;

  /// No description provided for @or_continue_with.
  ///
  /// In en, this message translates to:
  /// **'Or continue with'**
  String get or_continue_with;

  /// No description provided for @no_account.
  ///
  /// In en, this message translates to:
  /// **'Don\'t have an account?'**
  String get no_account;

  /// No description provided for @have_account.
  ///
  /// In en, this message translates to:
  /// **'Already have an account?'**
  String get have_account;

  /// No description provided for @publish_ride.
  ///
  /// In en, this message translates to:
  /// **'Publish a Ride'**
  String get publish_ride;

  /// No description provided for @departure_date.
  ///
  /// In en, this message translates to:
  /// **'Departure Date'**
  String get departure_date;

  /// No description provided for @departure_time.
  ///
  /// In en, this message translates to:
  /// **'Departure Time'**
  String get departure_time;

  /// No description provided for @seats_available.
  ///
  /// In en, this message translates to:
  /// **'Available Seats'**
  String get seats_available;

  /// No description provided for @price_per_seat.
  ///
  /// In en, this message translates to:
  /// **'Price per Seat (₹)'**
  String get price_per_seat;

  /// No description provided for @ride_rules.
  ///
  /// In en, this message translates to:
  /// **'Ride Rules'**
  String get ride_rules;

  /// No description provided for @no_smoking.
  ///
  /// In en, this message translates to:
  /// **'No Smoking'**
  String get no_smoking;

  /// No description provided for @no_music.
  ///
  /// In en, this message translates to:
  /// **'No Music'**
  String get no_music;

  /// No description provided for @no_pets.
  ///
  /// In en, this message translates to:
  /// **'No Pets'**
  String get no_pets;

  /// No description provided for @no_heavy_luggage.
  ///
  /// In en, this message translates to:
  /// **'No Heavy Luggage'**
  String get no_heavy_luggage;

  /// No description provided for @price_negotiable.
  ///
  /// In en, this message translates to:
  /// **'Price Negotiable'**
  String get price_negotiable;

  /// No description provided for @edit_profile.
  ///
  /// In en, this message translates to:
  /// **'Edit Profile'**
  String get edit_profile;

  /// No description provided for @my_documents.
  ///
  /// In en, this message translates to:
  /// **'My Documents'**
  String get my_documents;

  /// No description provided for @my_reports.
  ///
  /// In en, this message translates to:
  /// **'Reports'**
  String get my_reports;

  /// No description provided for @settings.
  ///
  /// In en, this message translates to:
  /// **'Settings'**
  String get settings;

  /// No description provided for @logout.
  ///
  /// In en, this message translates to:
  /// **'Logout'**
  String get logout;

  /// No description provided for @verified.
  ///
  /// In en, this message translates to:
  /// **'Verified'**
  String get verified;

  /// No description provided for @not_verified.
  ///
  /// In en, this message translates to:
  /// **'Not Verified'**
  String get not_verified;

  /// No description provided for @rides_given.
  ///
  /// In en, this message translates to:
  /// **'Rides Given'**
  String get rides_given;

  /// No description provided for @rides_taken.
  ///
  /// In en, this message translates to:
  /// **'Rides Taken'**
  String get rides_taken;

  /// No description provided for @loading.
  ///
  /// In en, this message translates to:
  /// **'Loading...'**
  String get loading;

  /// No description provided for @retry.
  ///
  /// In en, this message translates to:
  /// **'Retry'**
  String get retry;

  /// No description provided for @error_occurred.
  ///
  /// In en, this message translates to:
  /// **'Something went wrong. Please try again.'**
  String get error_occurred;

  /// No description provided for @no_data_found.
  ///
  /// In en, this message translates to:
  /// **'No data found.'**
  String get no_data_found;

  /// No description provided for @save.
  ///
  /// In en, this message translates to:
  /// **'Save'**
  String get save;

  /// No description provided for @cancel.
  ///
  /// In en, this message translates to:
  /// **'Cancel'**
  String get cancel;

  /// No description provided for @confirm.
  ///
  /// In en, this message translates to:
  /// **'Confirm'**
  String get confirm;

  /// No description provided for @delete.
  ///
  /// In en, this message translates to:
  /// **'Delete'**
  String get delete;

  /// No description provided for @share.
  ///
  /// In en, this message translates to:
  /// **'Share'**
  String get share;
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
      <String>['en', 'hi'].contains(locale.languageCode);

  @override
  bool shouldReload(_AppLocalizationsDelegate old) => false;
}

AppLocalizations lookupAppLocalizations(Locale locale) {
  // Lookup logic when only language code is specified.
  switch (locale.languageCode) {
    case 'en':
      return AppLocalizationsEn();
    case 'hi':
      return AppLocalizationsHi();
  }

  throw FlutterError(
      'AppLocalizations.delegate failed to load unsupported locale "$locale". This is likely '
      'an issue with the localizations generation tool. Please file an issue '
      'on GitHub with a reproducible sample app and the gen-l10n configuration '
      'that was used.');
}
