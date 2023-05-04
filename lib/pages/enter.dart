import 'dart:math';

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
  final int ANIM_DURATION = 200;

  final List<Term> _allTerms = [];
  final List<HintOption> _hints = [];

  final GlobalKey<AnimatedListState> listKey = GlobalKey<AnimatedListState>();

  Logger logger = Logger();

  void _handleSubmit() {
    for (var thisTerm in _allTerms) {
      logger.i(thisTerm);
    }
  }

  void _deleteTerm(int id) {
    for (var i = 0; i < _allTerms.length; i++) {
      Term thisTerm = _allTerms[i];
      if (thisTerm.id == id) {
        listKey.currentState?.removeItem(
          i,
          (context, animation) => slidingItem(context, i, animation),
          duration: Duration(milliseconds: ANIM_DURATION),
        );
        setState(() {
          _allTerms.removeAt(i);
          _hints.removeAt(i);
        });
        break;
      }
    }
  }

// TODO: When I submit the terms all have updated values, but when we create/delete the cards lose their text
  void _createTerm() {
    listKey.currentState?.insertItem(
      0,
      duration: Duration(milliseconds: ANIM_DURATION),
    );
    setState(() {
      _allTerms.insert(0, Term.blank());
      _hints.insert(0, allHints.elementAt(Random().nextInt(allHints.length)));
    });
  }

  void _updateState() {
    setState(() {});
  }

  Widget slidingItem(BuildContext context, int i, Animation<double> animation) {
    return SlideTransition(
      position: animation.drive(
        Tween<Offset>(
          begin: const Offset(-1, 0),
          end: const Offset(0, 0),
        ).chain(
          CurveTween(curve: Curves.easeOut),
        ),
      ),
      child: TermInputCard(
        // TODO: This is throwing range error (valid value range is empty) when deleting last card in any size list
        // TODO: Animate cards shifting up and down as well (maybe a different Tween)
        _allTerms[i],
        onDelete: _deleteTerm,
        afterUpdate: _updateState,
        hintOption: _hints[i],
        key: Key(_allTerms[i].id.toString()),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
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
              AnimatedList(
                key: listKey,
                initialItemCount: 0,
                itemBuilder: (context, index, animation) {
                  return slidingItem(context, index, animation);
                },
                scrollDirection: Axis.vertical,
                shrinkWrap: true,
              ),
              const SizedBox(height: 20),
              AddButton(onPressed: _createTerm, text: "New Term"),
            ],
          ),
        ),
      ),
      backgroundColor: ThemeColors.accent,
    );
  }
}
