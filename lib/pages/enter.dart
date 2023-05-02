import 'package:flutter/material.dart';
import 'package:vocab_trainer_app/misc/colors.dart';
import 'package:vocab_trainer_app/widgets/app_bar.dart';

class Enter extends StatefulWidget {
  const Enter({super.key});

  @override
  State<Enter> createState() => _EnterState();
}

class _EnterState extends State<Enter> {
  void _handleSubmit() {}

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: ThemedAppBar(
        "Add New Vocabulary",
        actionButton: IconButton(
          icon: const Icon(
            Icons.check_rounded,
            color: ThemeColors.black,
            size: 30,
          ),
          onPressed: _handleSubmit,
        ),
      ),
      body: const Text("TODO"),
      backgroundColor: ThemeColors.accent,
    );
  }
}
