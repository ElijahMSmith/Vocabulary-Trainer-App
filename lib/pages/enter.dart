import 'package:flutter/material.dart';
import 'package:logger/logger.dart';
import 'package:vocab_trainer_app/misc/colors.dart';
import 'package:vocab_trainer_app/models/term.dart';
import 'package:vocab_trainer_app/widgets/app_bar.dart';
import 'package:vocab_trainer_app/widgets/enter/add_button.dart';
import 'package:vocab_trainer_app/widgets/enter/term_input_card.dart';

class Enter extends StatefulWidget {
  const Enter({super.key});

  @override
  State<Enter> createState() => _EnterState();
}

class _EnterState extends State<Enter> {
  final List<TermInputCard> _allTerms = [];
  Logger logger = Logger();

  void _handleSubmit() {/*TODO*/}
  void _deleteTerm(int id) {
    for (var i = 0; i < _allTerms.length; i++) {
      TermInputCard thisTerm = _allTerms[i];
      if (thisTerm.getID() == id) {
        setState(() => _allTerms.removeAt(i));
        break;
      }
    }
  }

  void _createTerm() {
    Term newTerm = Term.blank();
    TermInputCard newCard = TermInputCard(
      newTerm,
      onDelete: _deleteTerm,
      key: Key(newTerm.id.toString()),
    );
    setState(() => _allTerms.add(newCard));
  }

  /*
  - TODO: How to get state out when saving everything?
  */

  @override
  Widget build(BuildContext context) {
    logger.i("${_allTerms.length} term cards");
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
      body: SingleChildScrollView(
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              ..._allTerms,
              AddButton(onPressed: _createTerm, text: "New Term"),
            ],
          ),
        ),
      ),
      backgroundColor: ThemeColors.accent,
    );
  }
}
