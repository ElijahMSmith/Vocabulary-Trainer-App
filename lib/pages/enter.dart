import 'dart:async';
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
  final ScrollController _listScrollController = ScrollController();
  final GlobalKey<AnimatedListState> listKey = GlobalKey<AnimatedListState>();
  final int ANIM_DURATION = 350;
  Logger logger = Logger();

  final List<TermWithHint> _allTerms = [];

  @override
  void initState() {
    super.initState();
    _createTerm();
  }

  void _handleSubmit() {
    for (var thisTerm in _allTerms) {
      logger.i(thisTerm.term);
    }
  }

  void _deleteTerm(int id) {
    for (var i = 0; i < _allTerms.length; i++) {
      Term thisTerm = _allTerms[i].term;
      if (thisTerm.id == id) {
        TermWithHint removed = _allTerms.removeAt(i);
        listKey.currentState?.removeItem(
          i,
          (context, animation) => slidingItem(context, removed, animation),
          duration: Duration(milliseconds: (ANIM_DURATION / 2).floor()),
        );
        break;
      }
    }
  }

  // TODO: When I delete a term, the terms below all lose their text (but still there if submitted)
  // Is it possible build method is returning/finishing before the data is available? FutureBuilder doesn't really seem like what I need here.
  // StackOverflow it
  
  void _createTerm() {
    Term term = Term.blank();
    HintOption hint = allHints.elementAt(Random().nextInt(allHints.length));
    _allTerms.add(TermWithHint(term, hint));
    listKey.currentState?.insertItem(
      _allTerms.length - 1,
      duration: Duration(milliseconds: ANIM_DURATION),
    );
    Timer(
      Duration(milliseconds: ANIM_DURATION + 100),
      () {
        _listScrollController.animateTo(
          _listScrollController.position.maxScrollExtent,
          duration: const Duration(milliseconds: 300),
          curve: Curves.ease,
        );
      },
    );
  }

  void _notifyStateUpdate() {
    setState(() {});
  }

  Widget slidingItem(
      BuildContext context, TermWithHint data, Animation<double> animation) {
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
        data,
        onDelete: _deleteTerm,
        afterUpdate: _notifyStateUpdate,
        key: Key(data.term.id.toString()),
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
        controller: _listScrollController,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            AnimatedList(
              physics: const NeverScrollableScrollPhysics(),
              key: listKey,
              initialItemCount: _allTerms.length,
              itemBuilder: (context, index, animation) {
                return slidingItem(context, _allTerms[index], animation);
              },
              scrollDirection: Axis.vertical,
              shrinkWrap: true,
            ),
            const SizedBox(height: 20),
            AddButton(onPressed: _createTerm, text: "New Term"),
            const SizedBox(height: 20),
          ],
        ),
      ),
      backgroundColor: ThemeColors.accent,
    );
  }
}
