import 'package:flutter/material.dart';
import 'package:vocab_trainer_app/misc/colors.dart';

void showOverlay(
    {required BuildContext context,
    String? title,
    String? bodyText,
    bool? friendly,
    bool? hasWrittenConfirmation,
    required VoidCallback onConfirm}) {
  OverlayState overlayState = Overlay.of(context);
  OverlayEntry content = OverlayEntry(
    builder: (context) {
      return ConfirmationDialogue(
        title: title,
        bodyText: bodyText,
        friendly: friendly,
        hasWrittenConfirmation: hasWrittenConfirmation,
        onConfirm: onConfirm,
      );
    },
  );
  overlayState.insert(content);
}

class ConfirmationDialogue extends StatelessWidget {
  final String title;
  final String bodyText;
  final VoidCallback onConfirm;
  final bool
      hasWrittenConfirmation; // TODO: Button if this is false, text confirm additionally if true
  final bool friendly; // Softer colors than red and scary

  const ConfirmationDialogue({
    super.key,
    this.title = "Are You Sure?",
    this.bodyText = "This Action is Irreversible!",
    this.friendly = false,
    required this.onConfirm,
    required this.hasWrittenConfirmation,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.black.withOpacity(.4),
      child: Center(
        child: Container(
            width: MediaQuery.of(context).size.width * .9,
            color: ThemeColors.primary,
            decoration: const BoxDecoration(
              borderRadius: BorderRadius.all(
                Radius.circular(30),
              ),
            ),
            padding: const EdgeInsets.all(10),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Text(
                  bodyText,
                  style: const TextStyle(
                    color: ThemeColors.black,
                    fontSize: 32,
                    fontWeight: FontWeight.w700,
                  ),
                ),
                Text(
                  bodyText,
                  style: const TextStyle(
                    color: ThemeColors.black,
                    fontSize: 18,
                    fontWeight: FontWeight.w400,
                  ),
                ),
                TextButton(
                  onPressed: onConfirm,
                  style: ButtonStyle(
                    padding:
                        MaterialStateProperty.all(const EdgeInsets.all(12)),
                    backgroundColor: MaterialStateProperty.all(ThemeColors.red),
                    shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                      RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                    ),
                  ),
                  child: const Text(
                    "CONFIRM",
                    style: TextStyle(
                      color: ThemeColors.black,
                      fontSize: 22,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ),
              ],
            )),
      ),
    );
  }
}
