import 'package:flutter/material.dart';
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

  void setTerm(Term selected) {
    setState(() => currentTerm = selected);
  }

  @override
  void initState() {
    super.initState();
    // TODO: Get all words from list and add to allTerms
  }

  @override
  Widget build(BuildContext context) {
    double screenWidth = MediaQuery.of(context).size.width;

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
                SearchBar(onSubmit: setTerm),
                DisplayCard(),
                Row(
                  children: [TimeCard(), TimeCard()],
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
