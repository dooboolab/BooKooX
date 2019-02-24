import 'package:flutter/material.dart';
import 'package:flutter\_localizations/flutter\_localizations.dart';

import './screens/splash.dart' show Splash;
import './screens/intro.dart' show Intro;
import './utils/localization.dart';
import './utils/theme.dart' as Theme;

void main() => runApp(new MyApp());

class MyApp extends StatelessWidget {
  static const supportedLocales = ['en', 'ko'];

  @override
  Widget build(BuildContext context) {
    return new MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        brightness: Brightness.light,
        primaryColor: Theme.Colors.dusk,
        accentColor: Theme.Colors.dusk,
        hintColor: Theme.Colors.paleGray,
        disabledColor: Theme.Colors.disabled,
      ),
      routes: {
        '/splash': (BuildContext context) => Splash(),
        '/intro': (BuildContext context) => Intro(),
      },
      supportedLocales: [
        const Locale('en', 'US'),
        const Locale('ko', 'KR'),
      ],
      localizationsDelegates: [
        const LocalizationDelegate(supportedLocales: ['en', 'ko']),
        GlobalMaterialLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
      ],
      localeResolutionCallback: (Locale locale, Iterable<Locale> supportedLocales) {
        if (locale == null) {
          debugPrint("*language locale is null!!!");
          return supportedLocales.first;
        }
        for (Locale supportedLocale in supportedLocales) {
          if (supportedLocale.languageCode == locale.languageCode || supportedLocale.countryCode == locale.countryCode) {
            return supportedLocale;
          }
        }
        return supportedLocales.first;
      },
      title: 'BooKoo2',
      home: Splash(), // production
    );
  }
}
