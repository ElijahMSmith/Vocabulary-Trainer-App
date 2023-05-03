import 'package:flutter/material.dart';
import 'package:vocab_trainer_app/misc/colors.dart';

class AddButton extends StatelessWidget {
  final VoidCallback onPressed;
  final String text;

  const AddButton({super.key, required this.onPressed, required this.text});

  @override
  Widget build(BuildContext context) {
    return TextButton(
      onPressed: onPressed,
      style: ButtonStyle(
        padding: MaterialStateProperty.all(
            const EdgeInsets.symmetric(vertical: 10, horizontal: 40)),
        backgroundColor: MaterialStateProperty.all(ThemeColors.secondary),
        shape: MaterialStateProperty.all<RoundedRectangleBorder>(
          RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(5),
          ),
        ),
      ),
      child: Text(
        text,
        style: const TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.w400,
            color: ThemeColors.primary),
      ),
    );
  }
}
