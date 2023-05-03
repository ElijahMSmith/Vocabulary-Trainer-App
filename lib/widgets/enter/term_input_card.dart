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

  @override
  void initState() {
    super.initState();
    _data = widget._data;
  }

  Widget buildInputLine(String current, String label, String language,
      void Function(String) onChange) {
    return const Text("TODO");
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        border: Border.all(
          color: ThemeColors.black.withOpacity(.2),
          width: .5,
          strokeAlign: BorderSide.strokeAlignCenter,
        ),
        color: ThemeColors.primary,
        borderRadius: const BorderRadius.all(
          Radius.circular(5),
        ),
      ),
      child: Row(
        children: [
          Container(
            child: Column(
              children: [
                buildInputLine(
                  _data.term.item,
                  "Term",
                  _data.term.language,
                  (newText) {
                    setState(() {
                      _data.term.item = newText;
                    });
                  },
                ),
                buildInputLine(
                  _data.definition.item,
                  "Term",
                  _data.definition.language,
                  (newText) {
                    setState(() {
                      _data.definition.item = newText;
                    });
                  },
                ),
              ],
            ),
          ),
          IconButton(
            onPressed: () => widget.onDelete(_data.id),
            icon: const Icon(Icons.delete_outline,
                size: 30, color: ThemeColors.red),
          ),
        ],
      ),
    );
  }
}
