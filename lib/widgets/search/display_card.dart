import 'dart:async';

import 'package:flutter/material.dart';
import 'package:vocab_trainer_app/misc/colors.dart';
import 'package:vocab_trainer_app/models/term.dart';
import 'package:vocab_trainer_app/widgets/overlays/language_selector.dart';

class DisplayCard extends StatefulWidget {
  final Term? _data;
  final void Function() afterUpdate;

  const DisplayCard(this._data, {super.key, required this.afterUpdate});

  @override
  State<DisplayCard> createState() => _DisplayCardState();
}

class _DisplayCardState extends State<DisplayCard> {
  TextEditingController termController = TextEditingController();
  TextEditingController defController = TextEditingController();
  int lastTermId = -1;

  Timer? updateDelay;
  bool lastSaveSuccess = true;

  String getStatusText() {
    return updateDelay != null && updateDelay!.isActive
        ? "Saving..."
        : "Saved!";
  }

  void resetTimer() {
    if (updateDelay != null) updateDelay!.cancel();

    setState(() {
      updateDelay = Timer(const Duration(seconds: 1), () {
        setState(() {
          updateDelay = null;
        });
        widget.afterUpdate();
      });
    });
  }

  @override
  void initState() {
    super.initState();
    termController.text = widget._data?.term.item ?? "";
    defController.text = widget._data?.definition.item ?? "";
    lastTermId = widget._data?.id ?? -1;

    termController.addListener(() {
      widget._data?.term.item = termController.value.text;
      resetTimer();
    });

    defController.addListener(() {
      widget._data?.definition.item = defController.value.text;
      resetTimer();
    });
  }

  @override
  void dispose() {
    super.dispose();
    termController.dispose();
    defController.dispose();
  }

  Widget buildInputLine({
    required TextEditingController controller,
    required String label,
    required String language,
    required void Function(String) onChangeLanguage,
  }) {
    return Column(
      children: [
        Container(
          margin: const EdgeInsets.symmetric(vertical: 2.5),
          child: TextField(
            controller: controller,
            decoration: const InputDecoration(
              border: UnderlineInputBorder(
                borderSide: BorderSide(color: ThemeColors.black),
              ),
            ),
            style: const TextStyle(
              color: ThemeColors.black,
              fontWeight: FontWeight.w400,
              fontSize: 24,
            ),
          ),
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              label,
              style: const TextStyle(
                color: ThemeColors.black,
                fontSize: 16,
                fontWeight: FontWeight.w300,
              ),
            ),
            InkWell(
              onTap: language == "Not Selected"
                  ? null
                  : () {
                      LanguageSelector(
                        currentSelection: language,
                        onLanguageSelect: onChangeLanguage,
                      ).show(context);
                    },
              child: Text(
                language,
                style: TextStyle(
                  color: ThemeColors.blue
                      .withOpacity(language == "Not Selected" ? .4 : 1),
                  fontWeight: FontWeight.w500,
                  fontSize: 16,
                ),
              ),
            ),
          ],
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    Term? data = widget._data;
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(10),
        border: Border.all(
          color: ThemeColors.black.withOpacity(.2),
          width: .5,
          strokeAlign: BorderSide.strokeAlignCenter,
        ),
        color: ThemeColors.primary,
      ),
      padding: const EdgeInsets.only(bottom: 10, left: 20, right: 20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          buildInputLine(
            controller: termController,
            label: "Term",
            language: data?.term.language ?? "Not Selected",
            onChangeLanguage: (newLanguage) {
              if (data != null) {
                setState(() {
                  data.term.language = newLanguage;
                });
                resetTimer();
              }
            },
          ),
          buildInputLine(
            controller: defController,
            label: "Definition",
            language: data?.definition.language ?? "Not Selected",
            onChangeLanguage: (newLanguage) {
              if (data != null) {
                setState(() {
                  data.definition.language = newLanguage;
                });
                resetTimer();
              }
            },
          ),
          const SizedBox(height: 15),
          Text(
            getStatusText(),
            style: TextStyle(
              color: ThemeColors.secondary.withOpacity(.4),
              fontSize: 16,
              fontWeight: FontWeight.w400,
            ),
            textAlign: TextAlign.start,
          ),
        ],
      ),
    );
  }
}
