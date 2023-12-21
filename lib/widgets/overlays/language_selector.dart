import 'package:flutter/material.dart';
import 'package:vocab_trainer_app/misc/colors.dart';
import 'package:vocab_trainer_app/models/language_data.dart';

// ignore: must_be_immutable
class LanguageSelector extends StatefulWidget {
  final String? currentSelection;
  final void Function(String newLanguage) onLanguageSelect;
  OverlayEntry? _overlayRef;

  LanguageSelector(
      {super.key, this.currentSelection, required this.onLanguageSelect});

  void show(BuildContext context) {
    OverlayState overlayState = Overlay.of(context);
    _overlayRef = OverlayEntry(
      builder: (context) {
        return SafeArea(child: this);
      },
    );
    overlayState.insert(_overlayRef!);
  }

  void dismissOverlay() {
    if (_overlayRef != null) {
      _overlayRef!.remove();
      _overlayRef = null;
    }
  }

  @override
  State<LanguageSelector> createState() => _LanguageSelectorState();
}

class _LanguageSelectorState extends State<LanguageSelector>
    with TickerProviderStateMixin {
  late AnimationController _opacityAnimationController;
  late Animation<double> _opacityAnimation;

  final double TILE_HEIGHT = 55;

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

  // TODO: Add a search bar for filtering languages over scrolling
  // TODO: Group recently used at the top and then ALL below that

  @override
  Widget build(BuildContext context) {
    double LANGUAGE_SELECTOR_HEIGHT = 255;

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
                    .whenComplete(() => widget._overlayRef?.remove());
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
                child: Column( // TODO: Render overflow when entering the search box
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
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        const Icon(
                          Icons.arrow_drop_up,
                          size: 48,
                          color: ThemeColors.secondary,
                        ),
                        Container(
                          height: LANGUAGE_SELECTOR_HEIGHT,
                          decoration: BoxDecoration(
                            color: ThemeColors.primary,
                            border: Border.all(
                              color: ThemeColors.secondary.withOpacity(.4),
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
                              controller: ScrollController(
                                initialScrollOffset: () {
                                  if (widget.currentSelection != null) {
                                    // Stupid code that centers the selected language
                                    return allLanguages.indexOf(
                                                widget.currentSelection!) *
                                            TILE_HEIGHT -
                                        LANGUAGE_SELECTOR_HEIGHT / 2 +
                                        TILE_HEIGHT / 2;
                                  }
                                  return 0.0;
                                }(),
                              ),
                              children: [
                                ...allLanguages
                                    .map<Widget>(
                                      (language) => SizedBox(
                                        height: TILE_HEIGHT,
                                        child: Material(
                                          color: widget.currentSelection ==
                                                  language
                                              ? ThemeColors.secondary
                                              : ThemeColors.primary,
                                          child: ListTile(
                                            title: Text(
                                              language,
                                              style: TextStyle(
                                                fontSize: 24,
                                                fontWeight: FontWeight.w300,
                                                color:
                                                    widget.currentSelection ==
                                                            language
                                                        ? ThemeColors.primary
                                                        : ThemeColors.black,
                                              ),
                                            ),
                                            onTap: () {
                                              widget.onLanguageSelect(language);
                                              widget._overlayRef?.remove();
                                            },
                                          ),
                                        ),
                                      ),
                                    )
                                    .toList(),
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
                    SearchBar(
                      hintText: "Or Search Directly",
                      textStyle: const MaterialStatePropertyAll(
                        TextStyle(
                          fontSize: 18,
                        ),
                      ),
                      elevation: const MaterialStatePropertyAll(0),
                      shape: MaterialStatePropertyAll(
                        RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10),
                          side: BorderSide(
                            color: ThemeColors.secondary.withOpacity(.4),
                            width: 1,
                            style: BorderStyle.solid,
                          ),
                        ),
                      ),
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
