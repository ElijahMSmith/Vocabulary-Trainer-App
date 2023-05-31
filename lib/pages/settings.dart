import 'package:flutter/material.dart';
import 'package:vocab_trainer_app/misc/colors.dart';
import 'package:vocab_trainer_app/models/term.dart';
import 'package:vocab_trainer_app/widgets/miscellaneous/app_bar.dart';
import 'package:vocab_trainer_app/widgets/settings/settings_button.dart';

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
      body: Padding(
        padding: const EdgeInsets.all(10),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            // TODO: Implement handlers and initialSwitchToggleState
            SettingsButton(
              text: "Modify Practice Schedule",
              onPress: () {},
            ),
            SettingsButton(
              text: "Manage Notifications",
              onPress: () {},
            ),
            SettingsButton(
              text: "Reset Schedule After Miss",
              isSwitch: true,
              initialSwitchToggleState: false,
              onSwitchChange: (newVal) {},
            ),
            SettingsButton(
              text: "Dark Theme (Coming Soon!)",
              isSwitch: true,
              initialSwitchToggleState: false,
              onSwitchChange: (newVal) {},
            ),
            const SizedBox(height: 20),
            const Text(
              "Danger Zone",
              style: TextStyle(
                color: ThemeColors.red,
                fontSize: 32,
                fontWeight: FontWeight.w500,
              ),
            ),
            const SizedBox(height: 10),
            SettingsButton(
              text: "Reset All Term Schedules",
              dangerous: true,
              onPress: () {},
            ),
            SettingsButton(
              text: "Delete All Terms",
              dangerous: true,
              onPress: () {},
            ),
          ],
        ),
      ),
      backgroundColor: ThemeColors.accent,
    );
  }
}
