import 'package:flutter/material.dart';
import 'package:vocab_trainer_app/misc/colors.dart';
import 'package:vocab_trainer_app/models/term.dart';
import '../misc/db_helper.dart';

class Review extends StatefulWidget {
  final List<Term> termsToReview;

  const Review(this.termsToReview, {super.key});

  @override
  State<Review> createState() => _ReviewingState();
}

class _ReviewingState extends State<Review> {
  final DBHelper db = DBHelper();
  List<Term> finished = [];
  List<Term> unfinished = [];

  @override
  void initState() {
    unfinished = [...widget.termsToReview];
    unfinished.forEach((element) {
      debugPrint(element.toString());
    });
    super.initState();
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
          onPressed: () {
            // TODO: Clean up an early quit here, if there is anything to clean up
            Navigator.pop(context);
          },
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
      body: const SizedBox.expand(
        child: Center(
          child: Text(
            "TODO",
            style: TextStyle(fontSize: 24),
          ),
        ),
      ),
    );
  }
}
