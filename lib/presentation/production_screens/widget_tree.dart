import 'package:flutter/material.dart';
import 'package:flutter_flavor/infrastructure/firebase_auth.dart';
import 'package:flutter_flavor/presentation/production_screens/home_page.dart';
import 'package:flutter_flavor/presentation/production_screens/login_screen.dart';

class ProdScreen extends StatefulWidget {
  const ProdScreen({super.key});

  @override
  State<ProdScreen> createState() => _ProdScreenState();
}

class _ProdScreenState extends State<ProdScreen> {
  @override
  Widget build(BuildContext context) {
    return StreamBuilder(
      stream: Auth().authStateChanges,
      builder: (context, snapshot) {
        if (snapshot.hasData) {
          return HomePage();
        } else {
          return LoginPage();
        }
      },
    );
  }
}
