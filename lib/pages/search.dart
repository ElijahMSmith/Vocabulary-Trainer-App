import 'package:flutter/material.dart';
import 'package:logger/logger.dart';
import 'package:vocab_trainer_app/misc/colors.dart';
import 'package:vocab_trainer_app/models/term.dart';
import 'package:vocab_trainer_app/widgets/app_bar.dart';
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
  Logger logger = Logger();

  void setTerm(Term selected) {
    logger.d("Setting to $selected");
    setState(() => currentTerm = selected.clone());
  }

  void deleteTerm() {
    // TODO: Delete from database
    allTerms.remove(currentTerm);
    setState(() {
      currentTerm = null;
    });
  }

  @override
  void initState() {
    super.initState();
    // TODO: Get all words from list and add to allTerms, remove hard-coded list
    allTerms = [
      Term.fromExisting(TermItem("Hola", "Spanish"),
          TermItem("Hello", "English"), DateTime.now(), DateTime.now(), 1),
      Term.fromExisting(TermItem("Ni", "Chinese"), TermItem("You", "English"),
          DateTime.now(), DateTime.now(), 1)
    ];
  }

  @override
  Widget build(BuildContext context) {
    double screenWidth = MediaQuery.of(context).size.width;
    double screenHeight = MediaQuery.of(context).size.width;
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
                SearchBar(allTerms, onSubmit: setTerm),
                const SizedBox(height: 25),
                DisplayCard(
                  currentTerm,
                  key: ObjectKey(currentTerm),
                  afterUpdate: () {
                    // Force refresh
                    setState(() {});
                  },
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
                          currentTerm?.getAgeString() ?? "",
                          currentTerm != null
                              ? "Status: ${currentTerm!.getMemoryStatusString()}"
                              : "Status: N/A",
                          aspectRatio: 2,
                        ),
                      ),
                      SizedBox(
                        width: screenWidth * .9 * (1.0 / 3),
                        child: TimeCard(
                          "Next Practice:",
                          currentTerm?.getNextCheckString() ?? "",
                          currentTerm?.getNextCheckStringUnits() ?? "N/A",
                          aspectRatio: 1,
                        ),
                      ),
                    ],
                  ),
                ),
                SearchActionButton(),
                SearchActionButton(),
              ],
            ),
          ),
        ),
      ),
      backgroundColor: ThemeColors.accent,
    );
  }
}
