import 'dart:async';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:vocab_trainer_app/misc/colors.dart';
import 'package:vocab_trainer_app/misc/db_helper.dart';
import 'package:vocab_trainer_app/models/term_list.dart';
import 'package:vocab_trainer_app/models/term.dart';
import 'package:vocab_trainer_app/widgets/miscellaneous/app_bar.dart';
import 'package:vocab_trainer_app/widgets/overlays/confirmation_dialogue.dart';
import 'package:vocab_trainer_app/widgets/search/display_card.dart';
import 'package:vocab_trainer_app/widgets/search/search_bar.dart';
import 'package:vocab_trainer_app/widgets/miscellaneous/toast.dart';

import '../widgets/search/action_button.dart';
import '../widgets/search/time_card.dart';

const DB_UPDATE_DELAY_MS = 1000;

class Search extends StatefulWidget {
  const Search({super.key});

  @override
  State<Search> createState() => _SearchState();
}

class _SearchState extends State<Search> {
  final DBHelper _db = DBHelper();

  Term? _currentTerm;
  UniqueKey _searchKey = UniqueKey();
  Timer? _updateTimer;

  void setTerm(Term selected) {
    setState(() => _currentTerm = selected);
  }

  void deleteTerm() async {
    if (_currentTerm == null) return;
    bool success = await _db.deleteTerm(_currentTerm!);

    if (mounted && success) {
      Toast.success("Successfully Deleted", context);
      Provider.of<TermListModel>(context).remove(_currentTerm!);

      setState(() {
        _currentTerm = null;
        _searchKey = UniqueKey();
      });
    } else if (mounted) {
      Toast.error("Deletion Failed", context);
    }
  }

  void resetTermWait() async {
    if (_currentTerm == null) return;
    bool success = await _db.resetWait(_currentTerm!);

    if (mounted && success) {
      Toast.success("Successfully Reset", context);
      setState(() {
        _currentTerm!.scheduleIndex = 0;
      });
    } else if (mounted) {
      Toast.error("Reset Failed", context);
    }
  }

  void updateTermInDB() async {
    _updateTimer?.cancel();
    _updateTimer = Timer(const Duration(milliseconds: DB_UPDATE_DELAY_MS), () {
      if (_currentTerm != null) _db.updateTerm(_currentTerm!);
    });
  }

  @override
  Widget build(BuildContext context) {
    double screenWidth = MediaQuery.of(context).size.width;
    double screenHeight = MediaQuery.of(context).size.width;

    String ageString = _currentTerm?.ageString ?? "";
    String memoryStatusString =
        _currentTerm?.memoryStatusString ?? "Status: N/A";
    String nextCheckString = _currentTerm?.nextCheckString ?? " N/A";

    return Consumer<TermListModel>(
      builder: (context, termModel, child) {
        return Scaffold(
          appBar: ThemedAppBar("Edit Terms"),
          body: SingleChildScrollView(
            child: Center(
              child: SizedBox(
                width: screenWidth * .9,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    const SizedBox(height: 25),
                    TermSearchBar(
                      termModel.terms,
                      onSubmit: setTerm,
                      key: _searchKey,
                    ),
                    const SizedBox(height: 25),
                    DisplayCard(
                      _currentTerm,
                      key: ObjectKey(_currentTerm),
                      afterUpdate: updateTermInDB,
                    ),
                    const SizedBox(
                      height: 10,
                    ),
                    Container(
                      height: screenHeight * .35,
                      margin: const EdgeInsets.symmetric(
                        vertical: 10,
                        horizontal: 0,
                      ),
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.stretch,
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Expanded(
                            child: TimeCard(
                              "Existed for:",
                              ageString,
                              memoryStatusString,
                              aspectRatio: 2,
                            ),
                          ),
                          SizedBox(
                            width: screenWidth * .9 * (1.0 / 3),
                            child: TimeCard(
                              "Next Practice:",
                              nextCheckString.split(' ')[0],
                              nextCheckString.split(' ')[1],
                              aspectRatio: 1,
                            ),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(
                      height: 20,
                    ),
                    SearchActionButton(
                      text: "Reset Practice Schedule",
                      disabled: _currentTerm == null,
                      onPress: () {
                        ConfirmationDialogue(
                          bodyText:
                              "This term will be reset for review after your first scheduled practice duration.",
                          friendly: true,
                          onConfirm: resetTermWait,
                        ).show(context);
                      },
                      color: ThemeColors.secondary,
                    ),
                    const SizedBox(
                      height: 20,
                    ),
                    SearchActionButton(
                      text: "Delete This Term",
                      disabled: _currentTerm == null,
                      onPress: () {
                        ConfirmationDialogue(
                          friendly: false,
                          onConfirm: deleteTerm,
                        ).show(context);
                      },
                      color: ThemeColors.red,
                    ),
                  ],
                ),
              ),
            ),
          ),
          backgroundColor: ThemeColors.accent,
        );
      },
    );
  }
}
