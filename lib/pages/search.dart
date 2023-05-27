import 'package:flutter/material.dart';
import 'package:vocab_trainer_app/misc/colors.dart';
import 'package:vocab_trainer_app/misc/db_helper.dart';
import 'package:vocab_trainer_app/models/term.dart';
import 'package:vocab_trainer_app/widgets/miscellaneous/app_bar.dart';
import 'package:vocab_trainer_app/widgets/overlays/confirmation_dialogue.dart';
import 'package:vocab_trainer_app/widgets/search/display_card.dart';
import 'package:vocab_trainer_app/widgets/search/search_bar.dart';
import 'package:vocab_trainer_app/widgets/miscellaneous/toast.dart';

import '../widgets/search/action_button.dart';
import '../widgets/search/time_card.dart';

class Search extends StatefulWidget {
  final List<Term> currentTerms;
  final void Function({List<Term>? newTermsList}) updateTerms;

  const Search(
      {super.key, required this.currentTerms, required this.updateTerms});

  @override
  State<Search> createState() => _SearchState();
}

class _SearchState extends State<Search> {
  Term? currentTerm;
  DBHelper db = DBHelper();
  UniqueKey searchKey = UniqueKey();

  void setTerm(Term selected) {
    setState(() => currentTerm = selected);
  }

  void deleteTerm() async {
    if (currentTerm == null) return;

    bool success = await db.deleteTerm(currentTerm!);

    if (mounted && success)
      Toast.success("Successfully Deleted", context);
    else if (mounted) Toast.error("Deletion Failed", context);

    if (!success) return;

    setState(() {
      widget.currentTerms
          .removeWhere((element) => element.id == currentTerm!.id);
      currentTerm = null;
      widget.updateTerms();
      searchKey = UniqueKey();
    });
  }

  void resetTermWait() async {
    if (currentTerm == null) return;

    bool success = await db.resetWait(currentTerm!);

    if (mounted && success)
      Toast.success("Successfully Reset", context);
    else if (mounted) Toast.error("Reset Failed", context);

    if (!success) return;

    setState(() {
      currentTerm!.scheduleIndex = 0;
    });
  }

  void updateCurrentTermInDB() async {
    // TODO: Wait for X seconds of no further calls before persisting to DB
    if (currentTerm == null) return;

    bool success = await db.updateTerm(currentTerm!);
    if (!success) return;
  }

  @override
  Widget build(BuildContext context) {
    double screenWidth = MediaQuery.of(context).size.width;
    double screenHeight = MediaQuery.of(context).size.width;

    String ageString = currentTerm?.getAgeString() ?? "";
    String memoryStatusString =
        currentTerm?.getMemoryStatusString() ?? "Status: N/A";
    String nextCheckString = currentTerm?.getNextCheckString() ?? " N/A";

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
                SearchBar(widget.currentTerms,
                    onSubmit: setTerm, key: searchKey),
                const SizedBox(height: 25),
                DisplayCard(
                  currentTerm,
                  key: ObjectKey(currentTerm),
                  afterUpdate: updateCurrentTermInDB,
                ),
                const SizedBox(
                  height: 10,
                ),
                Container(
                  height: screenHeight * .35,
                  margin:
                      const EdgeInsets.symmetric(vertical: 10, horizontal: 0),
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
                  disabled: currentTerm == null,
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
                  disabled: currentTerm == null,
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
  }
}
