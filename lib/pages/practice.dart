import 'package:flutter/material.dart';
import 'package:vocab_trainer_app/misc/colors.dart';
import 'package:vocab_trainer_app/widgets/app_bar.dart';
import 'package:vocab_trainer_app/widgets/practice/mode_button.dart';
import 'package:vocab_trainer_app/widgets/practice/review_bubble.dart';

class Home extends StatefulWidget {
  const Home({super.key});

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  void _startReviewing() {
    // TODO
  }

  @override
  Widget build(BuildContext context) {
    double screenWidth = MediaQuery.of(context).size.width;
    return Scaffold(
      appBar: ThemedAppBar("TODO Name"),
      body: SingleChildScrollView(
        child: Center(
          child: SizedBox(
            width: screenWidth * .8,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                const SizedBox(height: 25),
                const Text(
                  "What is",
                  style: TextStyle(fontSize: 46, fontWeight: FontWeight.w400),
                ),
                const Text("Today's Goal?",
                    style:
                        TextStyle(fontSize: 46, fontWeight: FontWeight.w600)),
                const SizedBox(height: 25),
                ReviewBubble(
                  terms: 13,
                  onPress: _startReviewing,
                ),
                const SizedBox(height: 25),
                const Text(
                  "Other Modes",
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.w700,
                  ),
                ),
                const SizedBox(height: 20),
                const ModeButton(
                    iconData: Icons.info,
                    bkgIconColor: ThemeColors.red,
                    name: "Free Play",
                    tag: "Practice Anything"),
                const SizedBox(height: 10),
                const ModeButton(
                    iconData: Icons.fire_extinguisher,
                    bkgIconColor: ThemeColors.blue,
                    name: "Challenge",
                    tag: "Go For Streaks"),
                const SizedBox(height: 25),
              ],
            ),
          ),
        ),
      ),
      backgroundColor: ThemeColors.accent,
    );
  }
}
