import 'package:flutter/material.dart';
import 'package:vocab_trainer_app/misc/colors.dart';

// ignore: must_be_immutable
class ConfirmationDialogue extends StatefulWidget {
  final String title;
  final String bodyText;
  final VoidCallback onConfirm;
  final bool hasWrittenConfirmation;
  final bool friendly;
  OverlayEntry? overlayRef;

  ConfirmationDialogue({
    super.key,
    this.title = "Are You Sure?",
    this.bodyText = "This action is irreversible!",
    this.friendly = false,
    this.hasWrittenConfirmation = false,
    required this.onConfirm,
  });

  void show(BuildContext context) {
    OverlayState overlayState = Overlay.of(context);
    overlayRef = OverlayEntry(
      builder: (context) {
        return SafeArea(child: this);
      },
    );
    overlayState.insert(overlayRef!);
  }

  void dismissOverlay() {
    if (overlayRef != null) {
      overlayRef!.remove();
      overlayRef = null;
    }
  }

  @override
  State<ConfirmationDialogue> createState() => _ConfirmationDialogueState();
}

class _ConfirmationDialogueState extends State<ConfirmationDialogue>
    with TickerProviderStateMixin {
  final TextEditingController _confirmController = TextEditingController();
  bool confirmButtonEnabled = true;

  late AnimationController _opacityAnimationController;
  late Animation<double> _opacityAnimation;

  late AnimationController _confirmAnimationController;
  late Animation<Color?> _confirmAnimation;

  late Color buttonColor;

  @override
  void initState() {
    buttonColor = widget.friendly ? ThemeColors.blue : ThemeColors.red;

    _opacityAnimationController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 150),
    );

    _opacityAnimation =
        Tween(begin: 0.0, end: 1.0).animate(_opacityAnimationController);
    _opacityAnimationController.forward();

    if (widget.hasWrittenConfirmation) {
      confirmButtonEnabled = shouldConfirmBeEnabled("");

      _confirmAnimationController = AnimationController(
        vsync: this,
        duration: const Duration(milliseconds: 300),
      );

      _confirmAnimation = ColorTween(
              begin: buttonColor.withOpacity(.6),
              end: buttonColor.withOpacity(1))
          .animate(_confirmAnimationController);

      _confirmController.addListener(() {
        setState(() {
          bool newVal = shouldConfirmBeEnabled(_confirmController.value.text);

          if (!confirmButtonEnabled && newVal)
            _confirmAnimationController.forward();
          else if (confirmButtonEnabled && !newVal)
            _confirmAnimationController.reverse();

          confirmButtonEnabled = newVal;
        });
      });
    }

    super.initState();
  }

  @override
  void dispose() {
    _opacityAnimationController.dispose();

    if (widget.hasWrittenConfirmation) {
      _confirmAnimationController.dispose();
      _confirmController.dispose();
    }

    super.dispose();
  }

  bool shouldConfirmBeEnabled(String newText) {
    return !widget.hasWrittenConfirmation || newText.toUpperCase() == "CONFIRM";
  }

  Widget textButtonWidget(bool enabled, Color? backgroundColor) {
    return TextButton(
      onPressed: confirmButtonEnabled
          ? () {
              _opacityAnimationController.reverse().whenComplete(() {
                widget.overlayRef?.remove();
                widget.onConfirm();
              });
            }
          : null,
      style: ButtonStyle(
        padding: MaterialStateProperty.all(const EdgeInsets.all(12)),
        backgroundColor:
            MaterialStateProperty.all(backgroundColor ?? ThemeColors.blue),
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
          fontWeight: FontWeight.w600,
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.transparent,
      body: FadeTransition(
        opacity: _opacityAnimation,
        child: Stack(
          children: [
            ModalBarrier(
              color: ThemeColors.black.withOpacity(.6),
              dismissible: true,
              onDismiss: () {
                _opacityAnimationController
                    .reverse()
                    .whenComplete(() => widget.overlayRef?.remove());
              },
            ),
            Center(
              child: Container(
                width: MediaQuery.of(context).size.width * .8,
                decoration: const BoxDecoration(
                  borderRadius: BorderRadius.all(
                    Radius.circular(30),
                  ),
                  color: ThemeColors.accent,
                ),
                padding:
                    const EdgeInsets.symmetric(vertical: 30, horizontal: 30),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(
                      widget.title,
                      style: const TextStyle(
                        color: ThemeColors.black,
                        fontSize: 36,
                        fontWeight: FontWeight.w800,
                      ),
                      textAlign: TextAlign.center,
                    ),
                    const SizedBox(height: 45),
                    Text(
                      widget.bodyText,
                      style: const TextStyle(
                        color: ThemeColors.black,
                        fontSize: 20,
                        fontWeight: FontWeight.w500,
                      ),
                      textAlign: TextAlign.center,
                    ),
                    const SizedBox(height: 25),
                    if (widget.hasWrittenConfirmation) ...[
                      TextField(
                        controller: _confirmController,
                        decoration: const InputDecoration(
                          hintText: "CONFIRM",
                          border: UnderlineInputBorder(
                            borderSide: BorderSide(color: ThemeColors.black),
                          ),
                        ),
                        style: const TextStyle(
                          color: ThemeColors.black,
                          fontWeight: FontWeight.w500,
                          fontSize: 24,
                        ),
                      ),
                      const SizedBox(height: 25),
                      AnimatedBuilder(
                        animation: _confirmAnimation,
                        builder: (context, child) => textButtonWidget(
                            confirmButtonEnabled, _confirmAnimation.value),
                      ),
                    ],
                    if (!widget.hasWrittenConfirmation) ...[
                      textButtonWidget(confirmButtonEnabled, buttonColor),
                    ],
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
