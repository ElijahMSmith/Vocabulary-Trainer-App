import 'package:flutter/material.dart';
import 'package:vocab_trainer_app/misc/colors.dart';

void showOverlay({
  required BuildContext context,
  String title = "Are You Sure?",
  String bodyText = "This Action is Irreversible!",
  bool friendly = false,
  bool hasWrittenConfirmation = false,
  required VoidCallback onConfirm,
}) {
  OverlayState overlayState = Overlay.of(context);
  OverlayEntry? content;
  content = OverlayEntry(
    builder: (context) {
      return _ConfirmationDialogue(
        title: title,
        bodyText: bodyText,
        friendly: friendly,
        hasWrittenConfirmation: hasWrittenConfirmation,
        onConfirm: onConfirm,
        reference: content,
      );
    },
  );
  overlayState.insert(content);
}

class _ConfirmationDialogue extends StatefulWidget {
  final String title;
  final String bodyText;
  final VoidCallback onConfirm;
  final bool hasWrittenConfirmation; // TODO: Implement
  final bool friendly; // TODO: Implement
  final OverlayEntry? reference;

  const _ConfirmationDialogue({
    required this.title,
    required this.bodyText,
    required this.friendly,
    required this.onConfirm,
    required this.hasWrittenConfirmation,
    required this.reference,
  });

  @override
  State<_ConfirmationDialogue> createState() => _ConfirmationDialogueState();
}

class _ConfirmationDialogueState extends State<_ConfirmationDialogue>
    with SingleTickerProviderStateMixin {
  late AnimationController _animationController;
  late Animation<double> _tweenAnimation;

  @override
  void initState() {
    _animationController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 100),
    );

    _tweenAnimation = Tween(begin: 0.0, end: 1.0).animate(_animationController);
    _animationController.forward();

    super.initState();
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    _animationController.reset();
    _animationController.forward();

    return FadeTransition(
      opacity: _tweenAnimation,
      child: Stack(
        children: [
          ModalBarrier(
            color: ThemeColors.black.withOpacity(.6),
            dismissible: true,
            onDismiss: () => _animationController
                .reverse()
                .whenComplete(() => widget.reference?.remove()),
          ),
          Center(
            child: Container(
              width: MediaQuery.of(context).size.width * .8,
              decoration: const BoxDecoration(
                borderRadius: BorderRadius.all(
                  Radius.circular(30),
                ),
                color: ThemeColors.primary,
              ),
              padding: const EdgeInsets.symmetric(vertical: 30, horizontal: 30),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.stretch,
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    widget.title,
                    style: const TextStyle(
                      color: ThemeColors.black,
                      fontSize: 32,
                      fontWeight: FontWeight.w700,
                    ),
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 45),
                  Text(
                    widget.bodyText,
                    style: const TextStyle(
                      color: ThemeColors.black,
                      fontSize: 18,
                      fontWeight: FontWeight.w500,
                    ),
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 45),
                  TextButton(
                    onPressed: () {
                      _animationController.reverse().whenComplete(() {
                        widget.reference?.remove();
                        widget.onConfirm();
                      });
                    },
                    style: ButtonStyle(
                      padding:
                          MaterialStateProperty.all(const EdgeInsets.all(12)),
                      backgroundColor: MaterialStateProperty.all(
                          widget.friendly ? ThemeColors.blue : ThemeColors.red),
                      shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                        RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10),
                        ),
                      ),
                    ),
                    child: const Text(
                      "CONFIRM",
                      style: TextStyle(
                        color: ThemeColors.primary,
                        fontSize: 22,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
