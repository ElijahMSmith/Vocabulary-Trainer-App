import 'package:flutter/material.dart';
import 'package:vocab_trainer_app/misc/colors.dart';
import 'package:vocab_trainer_app/models/language_data.dart';

// ignore: must_be_immutable
class LanguageSelector extends StatefulWidget {
  final LanguageCollection allLanguages = LanguageCollection();

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

  final double TILE_HEIGHT = 50;

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
  // TODO: Make all languages one line

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
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        const Icon(
                          Icons.arrow_drop_up,
                          size: 48,
                          color: ThemeColors.secondary,
                        ),
                        Container(
                          height: 255,
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
                                  initialScrollOffset: widget
                                              .currentSelection !=
                                          null
                                      ? (widget.allLanguages.indexOfName(
                                              widget.currentSelection!) *
                                          TILE_HEIGHT) // TODO: This doesn't work
                                      : 0),
                              children: [
                                ...widget.allLanguages.data
                                    .map<Widget>(
                                      (languageData) => SizedBox(
                                        height: TILE_HEIGHT,
                                        child: Material(
                                          color: widget.currentSelection ==
                                                  languageData.name
                                              ? ThemeColors.secondary
                                              : ThemeColors.primary,
                                          child: ListTile(
                                            title: Text(
                                              languageData.name,
                                              style: TextStyle(
                                                fontSize: 24,
                                                fontWeight: FontWeight.w300,
                                                color:
                                                    widget.currentSelection ==
                                                            languageData.name
                                                        ? ThemeColors.primary
                                                        : ThemeColors.black,
                                              ),
                                            ),
                                            onTap: () {
                                              widget.onLanguageSelect(
                                                  languageData.name);
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
