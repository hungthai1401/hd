import 'package:flutter/material.dart';
import 'package:flutter_i18n/flutter_i18n_delegate.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:hd/route.dart' as routeDefine;
import 'package:hd/screens/splash/splash_page.dart';
import 'package:hd/theme/theme.dart';

class Application extends StatelessWidget {
  final String _applicationName = 'Tư vấn phụ tùng';

  FlutterI18nDelegate flutterI18nDelegate;

  Application(this.flutterI18nDelegate);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: _applicationName,
      theme: applicationTheme(),
      debugShowCheckedModeBanner: false,
      home: SplashPage(),
      localizationsDelegates: [
        flutterI18nDelegate,
        GlobalMaterialLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate
      ],
      onGenerateRoute: routeDefine.routes,
    );
  }
}
