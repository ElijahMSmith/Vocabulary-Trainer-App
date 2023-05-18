import 'package:flutter/material.dart';
import 'package:vocab_trainer_app/misc/colors.dart';
import 'package:vocab_trainer_app/misc/db_helper.dart';
import 'package:vocab_trainer_app/models/term.dart';
import 'package:vocab_trainer_app/widgets/app_bar.dart';
import 'package:vocab_trainer_app/widgets/confirmation_dialogue.dart';
import 'package:vocab_trainer_app/widgets/search/display_card.dart';
import 'package:vocab_trainer_app/widgets/search/search_bar.dart';

import '../widgets/search/action_button.dart';
import '../widgets/search/time_card.dart';

class Search extends StatefulWidget {
  const Search({super.key});

  @override
  State<Search> createState() => _SearchState();
}

class _SearchState extends State<Search> {
  Term? currentTerm;
  List<Term> allTerms = [];
  DBHelper db = DBHelper();
  UniqueKey searchKey = UniqueKey();

  void setTerm(Term selected) {
    setState(() => currentTerm = selected);
  }

  void deleteTerm() async {
    if (currentTerm == null) return;

    bool success = await db.deleteTerm(currentTerm!);
    if (!success) return;

    int oldIndex =
        allTerms.indexWhere((element) => element.id == currentTerm!.id);
    setState(() {
      // TODO: The only time the search bar fails to update is if the top-level item is deleted
      // If any of the other items are deleted, it works as expected. WTF.
      currentTerm = null;
      if (oldIndex > 0) allTerms.removeAt(oldIndex);
      searchKey = UniqueKey();
    });
  }

  void resetTermWait() async {
    if (currentTerm == null) return;

    bool success = await db.resetWait(currentTerm!);
    if (!success) return;

    currentTerm!.scheduleIndex = 0;
    updateCurrentTermLocally();
  }

  void updateCurrentTermTotally() async {
    debugPrint("Attempting update");
    if (currentTerm == null) return;

    bool success = await db.updateTerm(currentTerm!);
    debugPrint("Updating was a success? $success");
    if (!success) return;

    updateCurrentTermLocally();
  }

  void updateCurrentTermLocally() {
    for (int i = 0; i < allTerms.length; i++) {
      Term oldTerm = allTerms[i];
      if (oldTerm.id == currentTerm!.id) {
        setState(() {
          allTerms[i] = currentTerm!;
        });
        break;
      }
    }
  }

  @override
  void initState() {
    super.initState();
    db.getAllTerms().then((retrieved) {
      setState(() => allTerms = retrieved);
    });
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
                SearchBar(allTerms, onSubmit: setTerm, key: searchKey),
                const SizedBox(height: 25),
                DisplayCard(
                  currentTerm,
                  key: ObjectKey(currentTerm),
                  afterUpdate: updateCurrentTermTotally,
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
                  onPress: () => showOverlay(
                    context: context,
                    bodyText:
                        "This term will be reset for review after your first scheduled practice duration.",
                    friendly: true,
                    onConfirm: resetTermWait,
                  ),
                  color: ThemeColors.secondary,
                ),
                const SizedBox(
                  height: 20,
                ),
                SearchActionButton(
                  text: "Delete This Term",
                  disabled: currentTerm == null,
                  onPress: () => showOverlay(
                    context: context,
                    friendly: false,
                    onConfirm: deleteTerm,
                  ),
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
