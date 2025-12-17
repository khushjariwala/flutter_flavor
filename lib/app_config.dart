import 'package:flutter/material.dart';

class AppConfig extends InheritedWidget {
  final String appName;
  final String baseUrl;

  const AppConfig({
    super.key,
    required this.appName,
    required this.baseUrl,
    required super.child,
  });

  static AppConfig of(BuildContext context) {
    return context.dependOnInheritedWidgetOfExactType<AppConfig>()!;
  }

  @override
  bool updateShouldNotify(AppConfig oldWidget) => false;
}
