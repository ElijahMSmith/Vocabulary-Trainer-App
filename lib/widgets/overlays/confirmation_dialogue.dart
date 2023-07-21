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
                width: MediaQuery.of(context).size.width * .85,
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
                        fontSize: 38,
                        fontWeight: FontWeight.w700,
                      ),
                      textAlign: TextAlign.center,
                    ),
                    const SizedBox(height: 25),
                    Text(
                      widget.bodyText,
                      style: const TextStyle(
                        color: ThemeColors.black,
                        fontSize: 22,
                        fontWeight: FontWeight.w500,
                      ),
                      textAlign: TextAlign.center,
                    ),
                    const SizedBox(height: 25),
                    if (widget.hasWrittenConfirmation) ...[
                      TextField(
                        controller: _confirmController,
                        decoration: InputDecoration(
                          hintText: "CONFIRM",
                          hintStyle: TextStyle(
                            color: ThemeColors.black.withOpacity(.4),
                            fontWeight: FontWeight.w500,
                            fontSize: 20,
                          ),
                          border: const UnderlineInputBorder(
                            borderSide: BorderSide(color: ThemeColors.black),
                          ),
                        ),
                        style: const TextStyle(
                          color: ThemeColors.black,
                          fontWeight: FontWeight.w500,
                          fontSize: 20,
                        ),
                        textAlign: TextAlign.center,
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


/*

TODO

══╡ EXCEPTION CAUGHT BY RENDERING LIBRARY
╞═════════════════════════════════════════════════════════
The following assertion was thrown during layout:
A RenderFlex overflowed by 39 pixels on the bottom.

The relevant error-causing widget was:
  Column
  Column:file:///Users/elijahsmith/Desktop/Projects.nosync/Vocabulary-Trainer-Ap
  p/lib/pages/settings.dart:37:16

The overflowing RenderFlex has an orientation of Axis.vertical.
The edge of the RenderFlex that is overflowing has been marked in the rendering
with a yellow and
black striped pattern. This is usually caused by the contents being too big for
the RenderFlex.
Consider applying a flex factor (e.g. using an Expanded widget) to force the
children of the
RenderFlex to fit within the available space instead of being sized to their
natural size.
This is considered an error condition because it indicates that there is content
that cannot be
seen. If the content is legitimately bigger than the available space, consider
clipping it with a
ClipRect widget before putting it in the flex, or using a scrollable container
rather than a Flex,
like a ListView.
The specific RenderFlex in question is: RenderFlex#0dbee relayoutBoundary=up2
OVERFLOWING:
  creator: Column ← Padding ← KeyedSubtree-[GlobalKey#4420d] ← _BodyBuilder ←
  MediaQuery ←
    LayoutId-[<_ScaffoldSlot.body>] ← CustomMultiChildLayout ← _ActionsScope ←
    Actions ←
    AnimatedBuilder ← DefaultTextStyle ← AnimatedDefaultTextStyle ← ⋯
  parentData: offset=Offset(10.0, 10.0) (can use size)
  constraints: BoxConstraints(0.0<=w<=391.4, 0.0<=h<=577.3)
  size: Size(391.4, 577.3)
  direction: vertical
  mainAxisAlignment: start
  mainAxisSize: max
  crossAxisAlignment: center
  verticalDirection: down
◢◤◢◤◢◤◢◤◢◤◢◤◢◤◢◤◢◤◢◤◢◤◢◤◢◤◢◤◢◤◢◤◢◤◢◤◢◤◢◤◢◤◢◤◢◤◢◤◢◤◢◤◢◤◢◤◢◤◢◤◢◤◢◤◢◤◢◤◢◤◢◤◢◤◢◤◢◤◢◤
◢◤◢◤◢◤◢◤◢◤◢◤◢◤◢◤◢◤◢◤
════════════════════════════════════════════════════════════════════════════════
════════════════════



*/