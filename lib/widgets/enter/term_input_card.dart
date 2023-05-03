import 'dart:math';

import 'package:flutter/material.dart';
import 'package:vocab_trainer_app/misc/colors.dart';
import 'package:vocab_trainer_app/models/term.dart';

class TermInputCard extends StatefulWidget {
  final void Function(int) onDelete;
  final Term _data;

  const TermInputCard(this._data, {required this.onDelete, required super.key});

  int getID() {
    return _data.id;
  }

  @override
  State<TermInputCard> createState() => _TermInputCardState();
}

class _TermInputCardState extends State<TermInputCard> {
  late final Term _data;
  final HintOption _randomHint =
      allHints.elementAt(Random().nextInt(allHints.length));

  @override
  void initState() {
    super.initState();
    _data = widget._data;
  }

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
                  label == "Term" ? _randomHint.term : _randomHint.definition,
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
                      setState(() {
                        _data.term.item = newText;
                      });
                    },
                    onChangeLanguage: (newLanguage) {
                      setState(() {
                        _data.term.language = newLanguage;
                      });
                    },
                  ),
                  buildInputLine(
                    current: _data.definition.item,
                    label: "Definition",
                    language: _data.definition.language,
                    onChangeItem: (newText) {
                      setState(() {
                        _data.definition.item = newText;
                      });
                    },
                    onChangeLanguage: (newLanguage) {
                      setState(() {
                        _data.definition.language = newLanguage;
                      });
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
              onPressed: () => widget.onDelete(_data.id),
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
