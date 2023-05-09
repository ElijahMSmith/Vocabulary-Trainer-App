import 'package:flutter/material.dart';
import 'package:vocab_trainer_app/misc/colors.dart';
import 'package:vocab_trainer_app/models/term.dart';

class TermInputCard extends StatefulWidget {
  final void Function(int) onDelete;
  final void Function() afterUpdate;
  final TermWithHint _data;
  final int listIndex;

  const TermInputCard(this._data,
      {super.key,
      required this.onDelete,
      required this.afterUpdate,
      required this.listIndex});

  @override
  State<TermInputCard> createState() => _TermInputCardState();
}

class _TermInputCardState extends State<TermInputCard> {
  TextEditingController termController = TextEditingController();
  TextEditingController defController = TextEditingController();

  @override
  void initState() {
    super.initState();
    termController.text = widget._data.term.term.item;
    defController.text = widget._data.term.definition.item;

    termController.addListener(() {
      widget._data.term.term.item = termController.value.text;
    });
    defController.addListener(() {
      widget._data.term.definition.item = defController.value.text;
    });
  }

  Widget buildInputLine({
    required TextEditingController controller,
    required String label,
    required String language,
    required void Function(String) onChangeLanguage,
  }) {
    TermWithHint data = widget._data;
    return Column(
      children: [
        Container(
          margin: const EdgeInsets.symmetric(vertical: 2.5),
          child: TextField(
            controller: controller,
            decoration: InputDecoration(
              hintText: label == "Term" ? data.hint.term : data.hint.definition,
              hintStyle: TextStyle(
                  color: ThemeColors.black.withOpacity(.4),
                  fontSize: 18,
                  fontStyle: FontStyle.italic),
              border: const UnderlineInputBorder(
                borderSide: BorderSide(color: ThemeColors.black),
              ),
            ),
            style: const TextStyle(
                color: ThemeColors.black,
                fontWeight: FontWeight.w500,
                fontSize: 18),
          ),
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              label,
              style: const TextStyle(
                  color: ThemeColors.black,
                  fontSize: 14,
                  fontWeight: FontWeight.w300),
            ),
            InkWell(
              onTap: () {
                /* TODO: Open language selector and send the result to onChangeLanguage */
              },
              child: Text(
                language,
                style: const TextStyle(
                    color: ThemeColors.blue, fontWeight: FontWeight.w500),
              ),
            )
          ],
        )
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    Term termObj = widget._data.term;
    return Container(
      margin: const EdgeInsets.fromLTRB(10, 10, 10, 0),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(10),
        border: Border.all(
          color: ThemeColors.black.withOpacity(.2),
          width: .5,
          strokeAlign: BorderSide.strokeAlignCenter,
        ),
        color: ThemeColors.primary,
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Expanded(
            child: Container(
              padding: const EdgeInsets.only(left: 25, bottom: 20),
              child: Column(
                children: [
                  buildInputLine(
                    controller: termController,
                    label: "Term",
                    language: termObj.term.language,
                    onChangeLanguage: (newLanguage) {
                      termObj.term.language = newLanguage;
                      widget.afterUpdate();
                    },
                  ),
                  buildInputLine(
                    controller: defController,
                    label: "Definition",
                    language: termObj.definition.language,
                    onChangeLanguage: (newLanguage) {
                      termObj.definition.language = newLanguage;
                      widget.afterUpdate();
                    },
                  ),
                ],
              ),
            ),
          ),
          Container(
            decoration: BoxDecoration(
              border: Border.all(color: ThemeColors.red, width: 1),
              shape: BoxShape.circle,
            ),
            margin: const EdgeInsets.only(left: 25, right: 25),
            child: IconButton(
              onPressed: () => widget.onDelete(widget.listIndex),
              icon: const Icon(
                Icons.delete_outline,
                size: 30,
                color: ThemeColors.red,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
