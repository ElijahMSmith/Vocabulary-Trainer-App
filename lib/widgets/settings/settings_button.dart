import 'package:flutter/material.dart';
import 'package:vocab_trainer_app/misc/colors.dart';

class SettingsButton extends StatefulWidget {
  final String text;
  final bool dangerous;

  final bool isSwitch;
  final bool initialSwitchToggleState;
  final bool disabled;
  final void Function(bool)? onSwitchChange;
  final void Function()? onPress;

  const SettingsButton({
    super.key,
    required this.text,
    this.dangerous = false,
    this.isSwitch = false,
    this.disabled = false,
    this.initialSwitchToggleState = false,
    this.onSwitchChange,
    this.onPress,
  });

  @override
  State<SettingsButton> createState() => _SettingsButtonState();
}

class _SettingsButtonState extends State<SettingsButton> {
  bool toggle = false;

  @override
  void initState() {
    toggle = widget.initialSwitchToggleState;
    super.initState();
  }

  void handleSwitchChange(bool newValue) {
    setState(() {
      toggle = newValue;
      if (widget.onSwitchChange != null) widget.onSwitchChange!(toggle);
    });
  }

  Widget buildActionItem() {
    if (widget.isSwitch) {
      return Switch(
        value: toggle,
        activeColor: ThemeColors.secondary,
        onChanged: handleSwitchChange,
      );
    } else if (widget.dangerous) {
      return const Icon(
        Icons.delete_forever_outlined,
        color: ThemeColors.red,
        size: 36,
      );
    } else {
      return const Icon(
        Icons.arrow_circle_right_outlined,
        color: ThemeColors.secondary,
        size: 36,
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 80,
      margin: const EdgeInsets.only(bottom: 10),
      decoration: BoxDecoration(
        border: Border.all(
          color: ThemeColors.black.withOpacity(.2),
          width: 1,
        ),
        borderRadius: const BorderRadius.all(
          Radius.circular(10),
        ),
        color: ThemeColors.primary,
      ),
      clipBehavior: Clip.hardEdge,
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: widget.disabled
              ? null
              : (widget.onPress ??
                  (widget.isSwitch ? () => handleSwitchChange(!toggle) : null)),
          child: Row(
            children: [
              const SizedBox(width: 20),
              Text(
                widget.text,
                style: TextStyle(
                  fontWeight: FontWeight.w400,
                  color: widget.dangerous ? ThemeColors.red : ThemeColors.black,
                  fontSize: 20,
                ),
              ),
              Expanded(child: Container()),
              buildActionItem(),
              const SizedBox(width: 20),
            ],
          ),
        ),
      ),
    );
  }
}
