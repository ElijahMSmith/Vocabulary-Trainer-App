import 'package:flutter/material.dart';
import 'package:vocab_trainer_app/misc/colors.dart';

// TODO: replace
const defaultLanguageList = [
  "English",
  "Spanish",
  "French",
  "German",
  "Portuguese",
  "Russian",
  "Chinese (Simplified)",
  "Chinese (Traditional)",
  "Japanese"
];

// ignore: must_be_immutable
class LanguageSelector extends StatefulWidget {
  final String? currentSelection;
  final void Function(String newLanguage) onLanguageSelect;
  OverlayEntry? overlayRef;

  LanguageSelector(
      {super.key, this.currentSelection, required this.onLanguageSelect});

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
  State<LanguageSelector> createState() => _LanguageSelectorState();
}

class _LanguageSelectorState extends State<LanguageSelector>
    with TickerProviderStateMixin {
  late AnimationController _opacityAnimationController;
  late Animation<double> _opacityAnimation;

  @override
  void initState() {
    _opacityAnimationController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 150),
    );

    _opacityAnimation =
        Tween(begin: 0.0, end: 1.0).animate(_opacityAnimationController);
    _opacityAnimationController.forward();

    super.initState();
  }

  @override
  void dispose() {
    _opacityAnimationController.dispose();

    super.dispose();
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
                padding: const EdgeInsets.symmetric(
                  vertical: 30,
                  horizontal: 30,
                ),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    const Text(
                      "Select a Language",
                      style: TextStyle(
                        color: ThemeColors.black,
                        fontSize: 32,
                        fontWeight: FontWeight.w500,
                      ),
                      textAlign: TextAlign.center,
                    ),
                    const SizedBox(height: 14),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        // TODO: Why are these icons not right next to the container? Where is there extra space and how can I remove it?
                        const Icon(
                          Icons.arrow_drop_up,
                          size: 48,
                          color: ThemeColors.secondary,
                        ),
                        Container(
                          height: 240,
                          decoration: BoxDecoration(
                            color: ThemeColors.primary,
                            border: Border.all(
                              color: ThemeColors.black.withOpacity(.4),
                              width: 1,
                              strokeAlign: BorderSide.strokeAlignCenter,
                            ),
                            borderRadius: const BorderRadius.all(
                              Radius.circular(15),
                            ),
                          ),
                          child: ClipRRect(
                            borderRadius: const BorderRadius.all(
                              Radius.circular(15),
                            ),
                            child: ListView(
                              children: [
                                const SizedBox(height: 10),
                                ...defaultLanguageList
                                    .map<Widget>(
                                      (language) => Container(
                                        padding: const EdgeInsets.symmetric(
                                          horizontal: 15,
                                          vertical: 7.5,
                                        ),
                                        child: Text(
                                          language,
                                          style: const TextStyle(
                                            fontSize: 24,
                                            fontWeight: FontWeight.w300,
                                            color: ThemeColors.black,
                                          ),
                                        ),
                                      ),
                                    )
                                    .toList(),
                                const SizedBox(height: 10),
                              ],
                            ),
                          ),
                        ),
                        const Icon(
                          Icons.arrow_drop_down,
                          size: 48,
                          color: ThemeColors.secondary,
                        ),
                      ],
                    ),
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
