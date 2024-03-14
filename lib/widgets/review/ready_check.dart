import 'package:flutter/material.dart';
import 'package:vocab_trainer_app/misc/colors.dart';
import 'package:vocab_trainer_app/misc/util.dart';

class ReadyCheck extends StatefulWidget {
  final int termsAvailable;
  final void Function(int) onSubmit;

  const ReadyCheck(
      {required this.termsAvailable, required this.onSubmit, super.key});

  @override
  State<ReadyCheck> createState() => _ReadyCheckState();
}

class _ReadyCheckState extends State<ReadyCheck> {
  int termsSelected = 0;
  final TextEditingController controller = TextEditingController();

  @override
  void initState() {
    termsSelected = widget.termsAvailable;
    controller.text = termsSelected.toString();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    var inputBorder = OutlineInputBorder(
      borderSide: BorderSide(
        color: ThemeColors.secondary.withOpacity(.7),
        width: 0.5,
        strokeAlign: BorderSide.strokeAlignCenter,
      ),
      borderRadius: const BorderRadius.all(
        Radius.circular(15),
      ),
    );

    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Text(
          "You have ${widget.termsAvailable}\n${makePluralIfNeeded("term", widget.termsAvailable)} to review.",
          style: const TextStyle(
            fontSize: 42,
            fontWeight: FontWeight.w600,
          ),
          textAlign: TextAlign.center,
        ),
        const SizedBox(height: 30),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Text(
              "I want to review",
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.w500,
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(
                horizontal: 10,
              ),
              child: SizedBox(
                width: 50,
                height: 40,
                child: TextField(
                  controller: controller,
                  keyboardType: TextInputType.number,
                  onTapOutside: (_) =>
                      FocusManager.instance.primaryFocus?.unfocus(),
                  style: const TextStyle(
                    fontWeight: FontWeight.w400,
                    fontSize: 18,
                    color: ThemeColors.black,
                  ),
                  textAlign: TextAlign.center,
                  textAlignVertical: TextAlignVertical.center,
                  decoration: InputDecoration(
                    filled: true,
                    fillColor: ThemeColors.primary,
                    enabledBorder: inputBorder,
                    focusedBorder: inputBorder,
                    contentPadding: const EdgeInsets.all(5),
                  ),
                ),
              ),
            ),
            const Text(
              "term(s)",
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.w500,
              ),
            ),
          ],
        ),
        const SizedBox(
          height: 30,
        ),
        ElevatedButton(
          onPressed: () => widget.onSubmit(int.parse(controller.text)),
          style: ButtonStyle(
            backgroundColor: MaterialStateProperty.all<Color>(ThemeColors.blue),
            shape: MaterialStateProperty.all<RoundedRectangleBorder>(
              RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(50),
              ),
            ),
            padding: MaterialStateProperty.all<EdgeInsetsGeometry>(
                const EdgeInsets.symmetric(
              vertical: 5,
              horizontal: 25,
            )),
          ),
          child: const Text(
            "Let's Go!",
            style: TextStyle(
              fontSize: 24,
            ),
          ),
        ),
      ],
    );
  }
}
