import 'package:flutter/material.dart';
import 'package:vocab_trainer_app/main.dart';
import 'package:vocab_trainer_app/misc/colors.dart';

class SplashScreen extends StatelessWidget {
  final AppState loadingState;

  const SplashScreen(this.loadingState, {super.key});

  // TODO: Make this a cool logo or something, as well as fade in the content when removed
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: ThemeColors.accent.withOpacity(.8),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 50),
          child: Text(
            loadingState == AppState.LOADING
                ? "Loading..."
                : "Failed to load the required resources. If this issue persists, please let us know!",
            style: const TextStyle(
              fontSize: 32,
              fontWeight: FontWeight.bold,
            ),
            textAlign: TextAlign.center,
          ),
        ),
      ),
    );
  }
}
