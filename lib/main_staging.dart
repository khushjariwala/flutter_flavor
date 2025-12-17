import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_flavor/app.dart';
import 'package:flutter_flavor/app_config.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();

  runApp(
    AppConfig(
      appName: 'STAGING',
      baseUrl: 'https://staging.api.com',
      child: const MyApp(),
    ),
  );
}
