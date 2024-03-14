import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:vocab_trainer_app/misc/colors.dart';

class TermReviewer extends StatefulWidget {
  const TermReviewer({super.key});

  @override
  State<TermReviewer> createState() => _TermReviewerState();
}

class _TermReviewerState extends State<TermReviewer> {
  TextEditingController translationInput = TextEditingController();

  @override
  Widget build(BuildContext context) {
    double screenWidth = MediaQuery.of(context).size.width;
    double screenHeight = MediaQuery.of(context).size.height;

    return SizedBox(
      width: screenWidth * 0.85,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              IconButton(
                icon: SvgPicture.asset(
                  "assets/icons/play_audio.svg",
                  width: 100,
                  height: 100,
                ),
                onPressed: () {
                  // TODO: Play TTS
                },
              ),
              SizedBox(width: screenWidth * .05),
              const Text(
                "TODO word",
                style: TextStyle(
                  color: ThemeColors.black,
                  fontWeight: FontWeight.w400,
                  fontSize: 36,
                ),
              ),
            ],
          ),
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Invisible icon to create same spacing on the left
              IconButton(
                icon: SvgPicture.asset(
                  "assets/icons/play_audio.svg",
                  width: 100,
                  height: 100,
                  // ignore: deprecated_member_use
                  color: ThemeColors.accent,
                ),
                onPressed: null,
              ),
              SizedBox(width: screenWidth * .05),
              const Text(
                "TODO language1",
                style: TextStyle(
                  color: ThemeColors.black,
                  fontWeight: FontWeight.w300,
                  fontSize: 20,
                ),
              ),
            ],
          ),
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 10),
            child: TextField(
              controller: translationInput,
              autocorrect: false,
              decoration: InputDecoration(
                hintStyle: TextStyle(
                  color: ThemeColors.black.withOpacity(.4),
                  fontSize: 18,
                  fontStyle: FontStyle.italic,
                ),
                border: const UnderlineInputBorder(
                  borderSide: BorderSide(color: ThemeColors.black),
                ),
                suffixIcon: MaterialButton(
                  shape: const CircleBorder(),
                  minWidth: 0,
                  onPressed: () {/*TODO*/},
                  child: Icon(
                    Icons.arrow_forward_rounded,
                    color: ThemeColors.black.withOpacity(.6),
                    size: 25,
                  ),
                ),
              ),
              style: const TextStyle(
                color: ThemeColors.black,
                fontWeight: FontWeight.w500,
                fontSize: 18,
              ),
            ),
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              const Text(
                "TODO language2",
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.w300,
                ),
              ),
              ElevatedButton(
                onPressed: () {/*TODO*/},
                style: ButtonStyle(
                  backgroundColor:
                      MaterialStateProperty.all<Color>(ThemeColors.blue),
                  shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                    RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(50),
                    ),
                  ),
                ),
                child: const Text("I Was Right"),
              ),
            ],
          ),
          SizedBox(height: screenHeight * .05),
          const Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                "You Typed: TODO",
                style: TextStyle(
                  fontSize: 26,
                  fontWeight: FontWeight.w500,
                  color: ThemeColors.black,
                ),
              ),
              Text(
                "Correct Answer: TODO",
                style: TextStyle(
                  fontSize: 26,
                  fontWeight: FontWeight.w500,
                  color: ThemeColors.red,
                ),
              ),
            ],
          )
        ],
      ),
    );
  }
}
