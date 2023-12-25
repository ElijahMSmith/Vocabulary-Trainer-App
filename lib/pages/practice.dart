import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:vocab_trainer_app/misc/colors.dart';
import 'package:vocab_trainer_app/models/term_list.dart';
import 'package:vocab_trainer_app/models/term.dart';
import 'package:vocab_trainer_app/pages/review.dart';
import 'package:vocab_trainer_app/widgets/miscellaneous/app_bar.dart';
import 'package:vocab_trainer_app/widgets/practice/mode_button.dart';
import 'package:vocab_trainer_app/widgets/practice/review_bubble.dart';

import '../misc/db_helper.dart';

class Practice extends StatefulWidget {
  const Practice({super.key});

  @override
  State<Practice> createState() => _PracticeState();
}

class _PracticeState extends State<Practice> {
  final DBHelper db = DBHelper();

  void _startReviewing(List<Term> toReview) {
    // TODO: Add a new screen on the navigator stack and send reviewTerms, allTerms, and updateTerms there
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => Review(toReview)),
    );
  }

  List<Term> getReviewableTerms(List<Term> termList) {
    return termList.where((term) => term.daysUntilNextCheck <= 0).toList();
  }

  @override
  Widget build(BuildContext context) {
    double screenWidth = MediaQuery.of(context).size.width;
    List<Term> reviewableTerms =
        getReviewableTerms(Provider.of<TermListModel>(context).terms);
    return Consumer<TermListModel>(
      builder: (context, termModel, child) {
        return Scaffold(
          appBar: ThemedAppBar("TODO Name"),
          body: SingleChildScrollView(
            child: Center(
              child: SizedBox(
                width: screenWidth * .8,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    const SizedBox(height: 25),
                    const Text(
                      "What is",
                      style:
                          TextStyle(fontSize: 46, fontWeight: FontWeight.w400),
                    ),
                    const Text("Today's Goal?",
                        style: TextStyle(
                            fontSize: 46, fontWeight: FontWeight.w600)),
                    const SizedBox(height: 25),
                    ReviewBubble(
                      termCount: reviewableTerms.length,
                      onPress: () => _startReviewing(reviewableTerms),
                    ),
                    const SizedBox(height: 25),
                    const Text(
                      "Other Modes",
                      style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                    const SizedBox(height: 20),
                    const ModeButton(
                      iconData: Icons.info,
                      bkgIconColor: ThemeColors.red,
                      name: "Free Play (Coming Soon)",
                      tag: "Practice Anything",
                    ),
                    const SizedBox(height: 10),
                    const ModeButton(
                      iconData: Icons.fire_extinguisher,
                      bkgIconColor: ThemeColors.blue,
                      name: "Challenge (Coming Soon)",
                      tag: "Go For Streaks",
                    ),
                    const SizedBox(height: 25),
                  ],
                ),
              ),
            ),
          ),
          backgroundColor: ThemeColors.accent,
        );
      },
    );
  }
}
