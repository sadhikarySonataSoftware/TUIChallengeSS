// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Bengali Bangla (`bn`).
class AppLocalizationsBn extends AppLocalizations {
  AppLocalizationsBn([String locale = 'bn']) : super(locale);

  @override
  String get appTitle => 'ভ্রমণ পরিকল্পনাকারী';

  @override
  String get homeTitle => 'আপনি কোথায় উড়ে যেতে চান?';

  @override
  String get homeSubtitle =>
      'একটি গন্তব্য বেছে নিন অথবা যেকোনো দুটি শহরের মধ্যে একটি রুট তৈরি করুন।';

  @override
  String get exploreDestinations => 'গন্তব্যগুলি ঘুরে দেখুন';

  @override
  String get departureCity => 'যাত্রার শহর';

  @override
  String get destinationCity => 'গন্তব্যের শহর';

  @override
  String get chooseBothCities => 'সবচেয়ে সস্তা রুট খুঁজতে দুটি শহরই বেছে নিন।';

  @override
  String get chooseDifferentCities => 'দুটি ভিন্ন শহর বেছে নিন।';

  @override
  String get noRouteFound => 'কোনো রুট পাওয়া যায়নি';

  @override
  String noRouteDescription(Object departure, Object destination) {
    return '$departure থেকে $destination পর্যন্ত কোনো উপলভ্য সংযোগের রুট নেই।';
  }

  @override
  String get refresh => 'রিফ্রেশ করুন';

  @override
  String get retry => 'আবার চেষ্টা করুন';

  @override
  String get apiEmpty => 'API থেকে কোনো সংযোগের তথ্য পাওয়া যায়নি।';

  @override
  String get loadError => 'সংযোগের তথ্য লোড করা যায়নি।';

  @override
  String get networkError =>
      'স্থানীয় API-তে সংযোগ করা যায়নি। নিশ্চিত করুন যে FastAPI পোর্ট 8000-এ চালু রয়েছে।';
}
