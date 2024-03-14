import 'package:flutter/material.dart';
import 'package:vocab_trainer_app/misc/colors.dart';
import 'package:vocab_trainer_app/models/term.dart';
import 'package:vocab_trainer_app/widgets/review/ready_check.dart';
import 'package:vocab_trainer_app/widgets/review/term_reviewer.dart';

enum ReviewState { READY, ACTIVE, FINISHED }

class Review extends StatefulWidget {
  final List<Term> termsToReview;

  const Review(this.termsToReview, {super.key});

  @override
  State<Review> createState() => _ReviewingState();
}

class _ReviewingState extends State<Review> {
  ReviewState state = ReviewState.READY;
  List<Term> finished = [];
  List<Term> unfinished = [];
  Term? currentTerm;

  @override
  void initState() {
    unfinished = widget.termsToReview;
    super.initState();
  }

  void startNextTerm() {
    setState(() {
      if (state == ReviewState.READY) state = ReviewState.ACTIVE;
      if (unfinished.isEmpty) state = ReviewState.FINISHED;

      setState(() {
        currentTerm = unfinished.removeLast();
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: ThemeColors.accent,
      appBar: AppBar(
        backgroundColor: ThemeColors.primary,
        centerTitle: true,
        title: const Text(
          "Practice",
          style: TextStyle(
            fontSize: 18,
            color: ThemeColors.black,
          ),
        ),
        leading: IconButton(
          onPressed: () => Navigator.pop(context),
          icon: const Icon(
            Icons.arrow_back_rounded,
            color: ThemeColors.black,
          ),
        ),
        actions: [
          IconButton(
            onPressed: () {
              // TODO: Open settings dialog
            },
            icon: const Icon(
              Icons.settings,
              color: ThemeColors.black,
            ),
          ),
        ],
      ),
      body: SizedBox.expand(
        child: Center(
          child: Builder(builder: (context) {
            if (state == ReviewState.READY)
              return ReadyCheck(
                termsAvailable: unfinished.length,
                onSubmit: (reviewCount) {
                  unfinished.shuffle();
                  while (unfinished.length > reviewCount)
                    unfinished.removeLast();
                  startNextTerm();
                },
              );
            else if (state == ReviewState.ACTIVE) {
              return const TermReviewer();
            } else {
              return const Text("TODO: Ending screen");
            }
          }),
        ),
      ),
    );
  }
}
