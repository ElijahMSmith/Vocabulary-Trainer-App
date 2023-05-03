import 'package:flutter/material.dart';
import 'package:vocab_trainer_app/misc/colors.dart';
import 'package:vocab_trainer_app/models/term.dart';

class TermInputCard extends StatelessWidget {
  final HintOption hintOption;

  final void Function(int) onDelete;
  final void Function() afterUpdate;
  final Term _data;

  const TermInputCard(
    this._data, {
    required this.onDelete,
    required this.afterUpdate,
    required this.hintOption,
    required super.key,
  });

  Widget buildInputLine(
      {required String current,
      required String label,
      required String language,
      required void Function(String) onChangeItem,
      required void Function(String) onChangeLanguage}) {
    return Column(
      children: [
        Container(
          margin: const EdgeInsets.symmetric(vertical: 2.5),
          child: TextField(
            onChanged: onChangeItem,
            decoration: InputDecoration(
              hintText:
                  label == "Term" ? hintOption.term : hintOption.definition,
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
                    current: _data.term.item,
                    label: "Term",
                    language: _data.term.language,
                    onChangeItem: (newText) {
                      _data.term.item = newText;
                      afterUpdate();
                      // This seems bad but the best I can think of right now
                    },
                    onChangeLanguage: (newLanguage) {
                      _data.term.language = newLanguage;
                      afterUpdate();
                    },
                  ),
                  buildInputLine(
                    current: _data.definition.item,
                    label: "Definition",
                    language: _data.definition.language,
                    onChangeItem: (newText) {
                      _data.definition.item = newText;
                      afterUpdate();
                    },
                    onChangeLanguage: (newLanguage) {
                      _data.definition.language = newLanguage;
                      afterUpdate();
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
              onPressed: () => onDelete(_data.id),
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
