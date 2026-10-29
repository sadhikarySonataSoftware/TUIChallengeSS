// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Hindi (`hi`).
class AppLocalizationsHi extends AppLocalizations {
  AppLocalizationsHi([String locale = 'hi']) : super(locale);

  @override
  String get appTitle => 'यात्रा योजनाकार';

  @override
  String get homeTitle => 'आप कहाँ उड़ान भरेंगे?';

  @override
  String get homeSubtitle => 'एक गंतव्य चुनें या दो शहरों के बीच मार्ग बनाएँ।';

  @override
  String get exploreDestinations => 'गंतव्य देखें';

  @override
  String get departureCity => 'प्रस्थान शहर';

  @override
  String get destinationCity => 'गंतव्य शहर';

  @override
  String get chooseBothCities =>
      'सबसे सस्ता मार्ग खोजने के लिए दोनों शहर चुनें।';

  @override
  String get chooseDifferentCities => 'दो अलग-अलग शहर चुनें।';

  @override
  String get noRouteFound => 'कोई मार्ग नहीं मिला';

  @override
  String noRouteDescription(Object departure, Object destination) {
    return '$departure से $destination तक कोई उपलब्ध मार्ग नहीं है।';
  }

  @override
  String get refresh => 'रीफ़्रेश करें';

  @override
  String get retry => 'पुनः प्रयास करें';

  @override
  String get apiEmpty => 'API से कोई कनेक्शन नहीं मिला।';

  @override
  String get loadError => 'कनेक्शन लोड नहीं हो सके।';

  @override
  String get networkError =>
      'लोकल API से कनेक्ट नहीं हो सका। जाँचें कि FastAPI पोर्ट 8000 पर चल रहा है।';
}
