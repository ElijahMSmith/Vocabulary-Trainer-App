import 'package:flutter/material.dart';
import 'package:vocab_trainer_app/misc/colors.dart';
import 'package:vocab_trainer_app/models/term.dart';

class TermSearchBar extends StatefulWidget {
  final void Function(Term) onSubmit;
  final List<Term> allOptions;
  const TermSearchBar(this.allOptions, {super.key, required this.onSubmit});

  @override
  State<TermSearchBar> createState() => _SearchBarState();
}

class _SearchBarState extends State<TermSearchBar> {
  late TextEditingController _controller;
  late FocusNode _focusNode;

  final GlobalKey _autocompleteKey = GlobalKey();

  @override
  void initState() {
    super.initState();
    _controller = TextEditingController(text: "");
    _focusNode = FocusNode();
  }

  @override
  void dispose() {
    super.dispose();
    _controller.dispose();
    _focusNode.dispose();
  }

  @override
  Widget build(BuildContext context) {
    var inputBorder = OutlineInputBorder(
      borderSide: BorderSide(
        color: ThemeColors.black.withOpacity(.2),
        width: 0.5,
        strokeAlign: BorderSide.strokeAlignCenter,
      ),
      borderRadius: const BorderRadius.all(
        Radius.circular(50),
      ),
    );

    return LayoutBuilder(
      builder: (context, constraints) {
        return RawAutocomplete<Term>(
          key: _autocompleteKey,
          textEditingController: _controller,
          focusNode: _focusNode,
          optionsBuilder: (TextEditingValue currentText) {
            return widget.allOptions.where((term) =>
                term.term.item
                    .toLowerCase()
                    .contains(currentText.text.toLowerCase()) ||
                term.definition.item
                    .toLowerCase()
                    .contains(currentText.text.toLowerCase()));
          },
          displayStringForOption: (term) => term.displayString,
          fieldViewBuilder:
              (context, textEditingController, focusNode, onFieldSubmitted) {
            return TextField(
              controller: _controller,
              focusNode: _focusNode,
              onTapOutside: (event) =>
                  FocusManager.instance.primaryFocus?.unfocus(),
              style: const TextStyle(
                fontWeight: FontWeight.w400,
                fontSize: 18,
                color: ThemeColors.black,
              ),
              textAlign: TextAlign.start,
              decoration: InputDecoration(
                contentPadding: const EdgeInsets.all(0.0),
                filled: true,
                fillColor: ThemeColors.primary,
                prefixIcon: Icon(
                  Icons.search_rounded,
                  color: ThemeColors.black.withOpacity(.4),
                ),
                suffixIcon: MaterialButton(
                  shape: const CircleBorder(),
                  minWidth: 0,
                  onPressed: () => _controller.clear(),
                  child: Icon(
                    Icons.close_rounded,
                    color: ThemeColors.black.withOpacity(.4),
                    size: 20,
                  ),
                ),
                hintText: 'Search Anything',
                hintStyle: TextStyle(
                  fontWeight: FontWeight.w300,
                  fontSize: 18,
                  color: ThemeColors.black.withOpacity(.4),
                ),
                enabledBorder: inputBorder,
                focusedBorder: inputBorder,
              ),
            );
          },
          optionsViewBuilder: (context, onSelected, options) {
            return Align(
              alignment: Alignment.topLeft,
              child: SizedBox(
                width: constraints.maxWidth,
                child: Material(
                  elevation: 4,
                  clipBehavior: Clip.antiAlias,
                  shape: RoundedRectangleBorder(
                    borderRadius: const BorderRadius.all(Radius.circular(10)),
                    side: BorderSide(
                      color: ThemeColors.black.withOpacity(.4),
                      width: 0.5,
                    ),
                  ),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: options.map((term) {
                      return ListTile(
                        title: Text(
                          term.displayString,
                          style: const TextStyle(
                            fontSize: 14,
                            color: ThemeColors.black,
                            fontWeight: FontWeight.w400,
                          ),
                        ),
                        onTap: () {
                          _focusNode.unfocus();
                          widget.onSubmit(term);
                          _controller.text = "";
                        },
                      );
                    }).toList(),
                  ),
                ),
              ),
            );
          },
        );
      },
    );
  }
}
