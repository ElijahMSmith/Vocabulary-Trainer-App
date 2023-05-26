import 'package:flutter/material.dart';
import 'package:vocab_trainer_app/misc/colors.dart';
import 'package:vocab_trainer_app/models/term.dart';
import 'package:vocab_trainer_app/widgets/app_bar.dart';
import 'package:vocab_trainer_app/widgets/toast.dart';

class Settings extends StatefulWidget {
  final List<Term> currentTerms;
  final void Function({List<Term>? newTermsList}) updateTerms;

  const Settings(
      {super.key, required this.currentTerms, required this.updateTerms});

  @override
  State<Settings> createState() => _SettingsState();
}

class _SettingsState extends State<Settings> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: ThemedAppBar("Settings"),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          TextButton(
            child: const Text("Success"),
            onPressed: () => Toast.success("Success Toast!", context),
          ),
          TextButton(
            child: const Text("Error"),
            onPressed: () => Toast.error("Error Toast!", context),
          ),
          TextButton(
            child: const Text("Info"),
            onPressed: () => Toast.info("Info Toast.", context),
          )
        ],
      ),
      backgroundColor: ThemeColors.accent,
    );
  }
}
