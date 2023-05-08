import 'package:flutter/material.dart';
import 'package:vocab_trainer_app/misc/colors.dart';

class TimeCard extends StatelessWidget {
  final String headerText;
  final String insideText;
  final String trailingText;
  final double aspectRatio;

  const TimeCard(this.headerText, this.insideText, this.trailingText,
      {super.key, required this.aspectRatio});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 0, horizontal: 10),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Text(
            headerText,
            textAlign: TextAlign.center,
            style: const TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.w300,
              color: ThemeColors.black,
            ),
          ),
          Expanded(
            child: AspectRatio(
              aspectRatio: aspectRatio,
              child: Container(
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(10),
                  border: Border.all(
                    color: ThemeColors.black.withOpacity(.2),
                    width: .5,
                    strokeAlign: BorderSide.strokeAlignCenter,
                  ),
                  color: ThemeColors.primary,
                ),
                child: Center(
                  child: Text(
                    insideText,
                    textAlign: TextAlign.center,
                    style: const TextStyle(
                      fontSize: 32,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ),
              ),
            ),
          ),
          Text(
            trailingText,
            textAlign: TextAlign.center,
            style: const TextStyle(
        fontSize: 16, fontWeight: FontWeight.w300, color: ThemeColors.black),
          )
        ],
      ),
    );
  }
}
