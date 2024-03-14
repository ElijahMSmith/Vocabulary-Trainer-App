import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:vocab_trainer_app/misc/colors.dart';
import 'package:vocab_trainer_app/misc/util.dart';

class ReviewBubble extends StatelessWidget {
  final int termCount;
  final VoidCallback onPress;

  const ReviewBubble(
      {super.key, required this.termCount, required this.onPress});

  Widget buildReviewButton() {
    return TextButton.icon(
      style: ButtonStyle(
        padding: MaterialStateProperty.all(const EdgeInsets.all(12)),
        backgroundColor: MaterialStateProperty.all(ThemeColors.primary),
        shape: MaterialStateProperty.all<RoundedRectangleBorder>(
          RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(30),
          ),
        ),
      ),
      onPressed: onPress,
      icon: const Icon(Icons.arrow_circle_right_outlined,
          size: 20, color: ThemeColors.secondary),
      label: const Text(
        "Practice",
        style: TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.w400,
            color: ThemeColors.black),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: ThemeColors.secondary,
        borderRadius: const BorderRadius.all(Radius.circular(30)),
        boxShadow: [
          BoxShadow(
            blurRadius: 4,
            offset: const Offset(0, 4),
            color: Colors.black.withOpacity(.2),
          ),
        ],
      ),
      padding: const EdgeInsets.symmetric(vertical: 25, horizontal: 30),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Text(
            termCount > 0
                ? "Review $termCount ${makePluralIfNeeded("Term", termCount)}!"
                : "No Pending Terms!",
            style: const TextStyle(
              fontSize: 22,
              fontWeight: FontWeight.w500,
              color: Colors.white,
            ),
          ),
          const SizedBox(height: 5),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              SizedBox(
                height: 100,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      termCount > 0 ? "You got this." : "Nice work.",
                      style: const TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.w300,
                        color: Colors.white,
                      ),
                    ),
                    termCount > 0
                        ? buildReviewButton()
                        : const Text(
                            "See You Tomorrow!",
                            style: TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.w400,
                              color: Colors.white,
                            ),
                          ),
                  ],
                ),
              ),
              SvgPicture.asset(
                "assets/icons/brain.svg",
                width: 100,
                height: 100,
              )
            ],
          ),
        ],
      ),
    );
  }
}
