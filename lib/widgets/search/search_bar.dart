import 'package:flutter/material.dart';
import 'package:vocab_trainer_app/misc/colors.dart';
import 'package:vocab_trainer_app/models/term.dart';

class SearchBar extends StatelessWidget {
  final void Function(Term) onSubmit;
  final List<Term> allOptions;

  const SearchBar(this.allOptions, {super.key, required this.onSubmit});

  @override
  Widget build(BuildContext context) {
    return Autocomplete<Term>(
      optionsBuilder: (TextEditingValue currentText) {
        return allOptions.where((term) =>
            term.term.item
                .toLowerCase()
                .startsWith(currentText.text.toLowerCase()) ||
            term.definition.item
                .toLowerCase()
                .startsWith(currentText.text.toLowerCase()));
      },
      displayStringForOption: (term) =>
          "${term.term.item} (${term.term.language}): ${term.definition.item} (${term.definition.language})",
      fieldViewBuilder:
          (context, textEditingController, focusNode, onFieldSubmitted) =>
              TextField(
        controller: textEditingController,
        focusNode: focusNode,
        style: const TextStyle(
            fontWeight: FontWeight.w300,
            fontSize: 18,
            color: ThemeColors.black),
        textAlign: TextAlign.start,
        decoration: InputDecoration(
          contentPadding: const EdgeInsets.all(0.0),
          filled: true,
          fillColor: ThemeColors.primary,
          prefixIcon: Icon(Icons.search_rounded,
              color: ThemeColors.black.withOpacity(.4)),
          suffixIcon: Icon(Icons.close_rounded,
              color: ThemeColors.black.withOpacity(.4)),
          border: OutlineInputBorder(
              borderSide: BorderSide(
                  color: ThemeColors.black.withOpacity(.2),
                  width: 0.5,
                  strokeAlign: BorderSide.strokeAlignCenter),
              borderRadius: const BorderRadius.all(Radius.circular(50))),
          hintText: 'Search Anything',
        ),
      ),
      onSelected: (selectedTerm) => onSubmit(selectedTerm),
      // TODO: Cleaner options boxes
    );
  }
}
