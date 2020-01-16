import 'package:flutter/material.dart';
import 'package:flutter_config/flutter_config.dart';
import 'package:flutter_i18n/flutter_i18n_delegate.dart';
import 'package:hd/screens/application.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await FlutterConfig.loadEnvVariables();
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
