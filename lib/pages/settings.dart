import 'package:flutter/material.dart';
import 'package:vocab_trainer_app/misc/colors.dart';
import 'package:vocab_trainer_app/misc/db_helper.dart';
import 'package:vocab_trainer_app/misc/shared_preferences_helper.dart';
import 'package:vocab_trainer_app/models/term.dart';
import 'package:vocab_trainer_app/widgets/miscellaneous/app_bar.dart';
import 'package:vocab_trainer_app/widgets/miscellaneous/toast.dart';
import 'package:vocab_trainer_app/widgets/overlays/confirmation_dialogue.dart';
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
  SPHelper sp = SPHelper();
  DBHelper db = DBHelper();

  @override
  void initState() {
    super.initState();
  }

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
              onPress: () {}, // TODO
            ),
            SettingsButton(
              text: "Manage Notifications",
              onPress: () {}, // TODO
            ),
            SettingsButton(
              text: "Reset Schedule After Miss",
              isSwitch: true,
              initialSwitchToggleState: sp.resetAfterMiss,
              onSwitchChange: (newVal) => sp.updateResetAfterMiss(newVal),
            ),
            SettingsButton(
              text: "Dark Theme (Coming Soon!)",
              isSwitch: true,
              initialSwitchToggleState: sp.useDarkTheme,
              onSwitchChange: (newVal) => sp.updateUseDarkTheme(newVal),
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
              onPress: () {
                ConfirmationDialogue(
                  bodyText:
                      "You must confirm this reset. This action is irreversible!",
                  friendly: false,
                  hasWrittenConfirmation: true,
                  onConfirm: () async {
                    bool success = await db.resetAllWaits();
                    if (mounted && success) {
                      Toast.success("Successfully Reset", context);
                      setState(() {
                        widget.currentTerms
                            .forEach((term) => term.scheduleIndex = 0);
                        widget.updateTerms();
                      });
                    } else if (mounted) {
                      Toast.error("Reset Failed", context);
                    }
                  },
                ).show(context);
              },
            ),
            SettingsButton(
              text: "Delete All Terms",
              dangerous: true,
              onPress: () {
                ConfirmationDialogue(
                  bodyText:
                      "You must confirm this deletion. This action is irreversible!",
                  friendly: false,
                  hasWrittenConfirmation: true,
                  onConfirm: () async {
                    bool success = await db.deleteAllTerms();
                    if (mounted && success) {
                      Toast.success("Successfully Deleted", context);
                      setState(() {
                        widget.currentTerms.clear();
                        widget.updateTerms();
                      });
                    } else if (mounted) {
                      Toast.error("Deletion Failed", context);
                    }
                  },
                ).show(context);
              },
            ),
          ],
        ),
      ),
      backgroundColor: ThemeColors.accent,
    );
  }
}
