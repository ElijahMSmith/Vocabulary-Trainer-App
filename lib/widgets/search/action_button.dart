import 'package:flutter/material.dart';
import 'package:vocab_trainer_app/misc/colors.dart';

class SearchActionButton extends StatelessWidget {
  final VoidCallback onPress;
  final Color color;
  final String text;
  final bool disabled;

  const SearchActionButton({
    super.key,
    required this.onPress,
    required this.color,
    required this.text,
    this.disabled = false,
  });

  @override
  Widget build(BuildContext context) {
    debugPrint("$disabled");
    return TextButton(
      onPressed: disabled ? null : onPress,
      style: TextButton.styleFrom(
        backgroundColor: disabled ? color.withOpacity(.7) : color,
        padding: const EdgeInsets.symmetric(vertical: 20),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(10),
        ),
        elevation: 4,
      ),
      child: Text(
        text,
        style: const TextStyle(
          fontSize: 18,
          fontWeight: FontWeight.w400,
          color: ThemeColors.primary,
        ),
      ),
    );
  }
}
