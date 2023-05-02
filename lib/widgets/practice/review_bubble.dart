import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:vocab_trainer_app/misc/colors.dart';

class ReviewBubble extends StatelessWidget {
  final int terms;
  final VoidCallback onPress;

  const ReviewBubble({super.key, required this.terms, required this.onPress});

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
      decoration: const BoxDecoration(
        color: ThemeColors.secondary,
        borderRadius: BorderRadius.all(Radius.circular(30)),
      ),
      padding: const EdgeInsets.symmetric(vertical: 25, horizontal: 30),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Text(terms > 0 ? "Review $terms Terms!" : "No Pending Terms!",
              style: const TextStyle(
                  fontSize: 22,
                  fontWeight: FontWeight.w500,
                  color: Colors.white)),
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
                      terms > 0 ? "You got this." : "Nice work.",
                      style: const TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.w300,
                          color: Colors.white),
                    ),
                    terms > 0
                        ? buildReviewButton()
                        : const Text(
                            "Check Back Tomorrow!",
                            style: TextStyle(
                                fontSize: 18,
                                fontWeight: FontWeight.w300,
                                color: Colors.white),
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
