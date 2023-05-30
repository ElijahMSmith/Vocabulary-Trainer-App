import 'dart:async';
import 'dart:math';

import 'package:flutter/material.dart';
import 'package:vocab_trainer_app/misc/colors.dart';
import 'package:vocab_trainer_app/misc/db_helper.dart';
import 'package:vocab_trainer_app/models/term.dart';
import 'package:vocab_trainer_app/widgets/miscellaneous/app_bar.dart';
import 'package:vocab_trainer_app/widgets/enter/add_button.dart';
import 'package:vocab_trainer_app/widgets/enter/term_input_card.dart';
import 'package:vocab_trainer_app/widgets/miscellaneous/toast.dart';

class Enter extends StatefulWidget {
  final List<Term> currentTerms;
  final void Function({List<Term>? newTermsList}) updateTerms;

  const Enter(
      {super.key, required this.currentTerms, required this.updateTerms});

  @override
  State<Enter> createState() => _EnterState();
}

class _EnterState extends State<Enter> {
  final ScrollController _listScrollController = ScrollController();
  GlobalKey<AnimatedListState> listKey = GlobalKey<AnimatedListState>();
  final DBHelper db = DBHelper();

  final int ANIM_DURATION = 350;
  final List<TermWithHint> _allTerms = [];

  @override
  void initState() {
    super.initState();
    _createTerm();
  }

  void _handleSubmit() {
    List<Term> nonEmptyTerms = _allTerms
        .where((termWithHint) =>
            termWithHint.term.term.item != "" &&
            termWithHint.term.definition.item != "")
        .map((termWithHint) => termWithHint.term)
        .toList();

    if (nonEmptyTerms.isEmpty) {
      Toast.error("No Terms to Add", context);
      return;
    }

    db.insertNewTerms(nonEmptyTerms);
    widget.currentTerms.addAll(nonEmptyTerms);

    setState(() {
      for (int i = _allTerms.length - 1; i >= 0; i--) {
        TermWithHint removed = _allTerms.removeAt(i);
        listKey.currentState?.removeItem(
          i,
          (context, animation) => slidingItem(context, removed, animation, i),
          duration: Duration(milliseconds: (ANIM_DURATION / 2).floor()),
        );
      }
    });

    widget.updateTerms();
    Toast.success("Created Terms!", context);
  }

  void _deleteTerm(int index) {
    TermWithHint removed = _allTerms.removeAt(index);
    listKey.currentState?.removeItem(
      index,
      (context, animation) => slidingItem(context, removed, animation, index),
      duration: Duration(milliseconds: (ANIM_DURATION / 2).floor()),
    );
  }

  void _createTerm() {
    Term newTerm = Term.blank();
    if (_allTerms.isNotEmpty) {
      TermWithHint last = _allTerms.last;
      newTerm.term.language = last.term.term.language;
      newTerm.definition.language = last.term.definition.language;
    }

    HintOption hint = allHints.elementAt(Random().nextInt(allHints.length));
    _allTerms.add(TermWithHint(newTerm, hint));

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

  Widget slidingItem(BuildContext context, TermWithHint data,
      Animation<double> animation, int listIndex) {
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
        data,
        onDelete: _deleteTerm,
        afterUpdate: _notifyStateUpdate,
        listIndex: listIndex,
        key: ObjectKey(data),
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
                return slidingItem(context, _allTerms[index], animation, index);
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
