import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:vocab_trainer_app/misc/colors.dart';
import 'package:vocab_trainer_app/models/language_data.dart';
import 'package:vocab_trainer_app/models/term_list.dart';

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

  final TextEditingController _controller = TextEditingController();
  String filter = "";

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

    _controller.addListener(() {
      debugPrint("Controller changed");
      setState(() => filter = _controller.text);
    });

    super.initState();
  }

  @override
  void dispose() {
    _opacityAnimationController.dispose();
    _controller.dispose();

    super.dispose();
  }

  List<Widget> makeLanguageWidgets(List<String> languages, String filter) {
    return languages
        .where((l) => l.toLowerCase().contains(filter.toLowerCase()))
        .map<Widget>(
          (language) => SizedBox(
            height: TILE_HEIGHT,
            child: Material(
              color: widget.currentSelection == language
                  ? ThemeColors.secondary
                  : ThemeColors.primary,
              child: ListTile(
                title: Text(
                  language,
                  style: TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.w300,
                    color: widget.currentSelection == language
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
        .toList();
  }

  @override
  Widget build(BuildContext context) {
    double LANGUAGE_SELECTOR_HEIGHT = 225;
    debugPrint("Rebuilding selector");

    return Consumer<TermListModel>(builder: (context, termModel, child) {
      List<String> nMostRecentList = termModel.getNMostRecent(7);

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
                  width: MediaQuery.of(context).size.width * .85,
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
                  child: SingleChildScrollView(
                    scrollDirection: Axis.vertical,
                    child: Column(
                      // TODO: Render overflow when entering the search box
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
                                      if (widget.currentSelection != null &&
                                          !nMostRecentList.contains(
                                              widget.currentSelection)) {
                                        // Stupid code that centers the selected language
                                        return (nMostRecentList.length +
                                                    allLanguages.indexOf(widget
                                                        .currentSelection!)) *
                                                TILE_HEIGHT -
                                            LANGUAGE_SELECTOR_HEIGHT / 2 +
                                            TILE_HEIGHT / 2;
                                      }
                                      return 0.0;
                                    }(),
                                  ),
                                  children: [
                                    if (_controller.text == "") ...[
                                      Padding(
                                        padding: const EdgeInsets.symmetric(
                                          horizontal: 10,
                                        ),
                                        child: Text(
                                          "Most Recently Used:",
                                          style: TextStyle(
                                            color: ThemeColors.black
                                                .withOpacity(.7),
                                            height: 2,
                                          ),
                                        ),
                                      ),
                                      ...makeLanguageWidgets(
                                        nMostRecentList,
                                        filter,
                                      ),
                                      // Always render full list
                                      const Divider(
                                        color: Colors.black,
                                        thickness: 0.5,
                                        height: 0.5,
                                      ),
                                    ],
                                    Padding(
                                      padding: const EdgeInsets.symmetric(
                                        horizontal: 10,
                                      ),
                                      child: Text(
                                        "All Languages:",
                                        style: TextStyle(
                                          color:
                                              ThemeColors.black.withOpacity(.7),
                                          height: 2,
                                        ),
                                      ),
                                    ),
                                    ...makeLanguageWidgets(
                                      allLanguages,
                                      filter,
                                    ),
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
                          controller: _controller,
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
              ),
            ],
          ),
        ),
      );
    });
  }
}
