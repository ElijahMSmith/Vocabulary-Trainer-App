import 'package:flutter/material.dart';
import 'package:logger/logger.dart';
import 'package:vocab_trainer_app/misc/colors.dart';
import 'package:vocab_trainer_app/models/term.dart';

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
  Logger logger = Logger();

  // TODO: This build might be simplified by just building everything empty explicitly (with no controllers and bullshit) if null

  @override
  void initState() {
    super.initState();
    termController.text = widget._data?.term.item ?? "";
    defController.text = widget._data?.definition.item ?? "";
    lastTermId = widget._data?.id ?? -1;

    // TODO: Editing these fields does change what's in the allTerms list when searching
    // It shouldn't we should just be editing a clone. Is this a key thing too?
    termController.addListener(() {
      widget._data?.term.item = termController.value.text;
    });

    defController.addListener(() {
      widget._data?.definition.item = defController.value.text;
    });
  }

  @override
  void dispose() {
    super.dispose();
    termController.dispose();
    defController.dispose();
  }

  Widget buildInputLine(
      {required TextEditingController controller,
      required String label,
      required String language,
      required void Function(String) onChangeLanguage}) {
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
              fontWeight: FontWeight.w500,
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
              onTap: () {
                /* TODO: Open language selector and send the result to onChangeLanguage */
              },
              child: Text(
                language,
                style: const TextStyle(
                  color: ThemeColors.blue,
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
      padding: const EdgeInsets.only(bottom: 20, left: 20, right: 20),
      child: Column(
        children: [
          buildInputLine(
            controller: termController,
            label: "Term",
            language: data?.term.language ?? "Not Selected",
            onChangeLanguage: (newLanguage) {
              if (data != null) {
                data.term.language = newLanguage;
                widget.afterUpdate();
              }
            },
          ),
          buildInputLine(
            controller: defController,
            label: "Definition",
            language: data?.definition.language ?? "Not Selected",
            onChangeLanguage: (newLanguage) {
              if (data != null) {
                data.definition.language = newLanguage;
                widget.afterUpdate();
              }
            },
          ),
        ],
      ),
    );
  }
}
