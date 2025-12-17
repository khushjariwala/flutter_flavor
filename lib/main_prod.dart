import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_flavor/app_config.dart';
import 'package:flutter_flavor/prod_UI.dart';

void main() async{
    WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(
    AppConfig(
      appName: 'PROD',
      baseUrl: 'https://api.com',
      child: NotesScreenn()
    ),
  );
}
