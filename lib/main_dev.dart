import 'package:flutter/material.dart';
import 'package:flutter_i18n/flutter_i18n_delegate.dart';
import 'package:hd/screens/application.dart';
import 'package:hd/utilities/constants.dart';

void main() async {
  Constants.setEnvironment(Environment.DEV);
  final FlutterI18nDelegate flutterI18nDelegate = FlutterI18nDelegate(
    useCountryCode: false,
    fallbackFile: 'vi',
    path: 'assets/i18n',
    forcedLocale: new Locale('vi'),
  );
  WidgetsFlutterBinding.ensureInitialized();
  await flutterI18nDelegate.load(null);
  runApp(Application(flutterI18nDelegate));
}
