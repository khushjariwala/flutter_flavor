import 'package:flutter/material.dart';
import 'domain/app_config.dart';

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    final config = AppConfig.of(context);

    return MaterialApp(
      title: config.appName,
      home: Scaffold(
        appBar: AppBar(title: Text(config.appName)),
        body: Center(child: Text(config.baseUrl)),
      ),
    );
  }
}
