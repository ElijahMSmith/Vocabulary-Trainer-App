import 'package:flutter/material.dart';
import 'package:logger/logger.dart';
import 'package:vocab_trainer_app/misc/colors.dart';
import 'package:vocab_trainer_app/misc/db_helper.dart';
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
  DBHelper db = DBHelper();

  void setTerm(Term selected) {
    setState(() => currentTerm = selected.clone());
  }

  void deleteTerm() {
    // TODO: Delete from database
    allTerms.remove(currentTerm);
    setState(() {
      currentTerm = null;
    });
  }

  void resetTermWait() {
    // TODO: Update index in database
  }

  @override
  void initState() {
    super.initState();
    db.getAllTerms().then((retrieved) {
      setState(() => allTerms = retrieved);
      logger.d("Retrieved ${allTerms.length} words");
      for (Term t in retrieved) logger.d(t);
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
                  onPress: () {
                    //TODO
                  },
                  color: ThemeColors.secondary,
                ),
                const SizedBox(
                  height: 20,
                ),
                SearchActionButton(
                  text: "Delete This Term",
                  onPress: () {
                    //TODO
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
