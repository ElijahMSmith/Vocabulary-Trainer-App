import 'package:flutter/material.dart';
import 'package:vocab_trainer_app/misc/colors.dart';

class SplashScreen extends StatelessWidget {
  const SplashScreen({super.key});

  // TODO: Make this a cool logo or something, as well as fade in the content when removed

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      backgroundColor: ThemeColors.accent,
      body: Center(
        child: Text(
          "Loading...",
          style: TextStyle(
            fontSize: 32,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
    );
  }
}
