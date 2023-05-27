import 'package:flutter/material.dart';
import 'package:vocab_trainer_app/misc/colors.dart';

class ThemedAppBar extends StatelessWidget implements PreferredSizeWidget {
  final String title;
  final IconButton? actionButton;
  final AppBar appBar = AppBar();

  ThemedAppBar(this.title, {Key? key, this.actionButton}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return AppBar(
      shape:
          Border(bottom: BorderSide(color: ThemeColors.black.withOpacity(.2))),
      elevation: 0,
      leading: ModalRoute.of(context)?.canPop == true
          ? IconButton(
              icon: const Icon(
                Icons.arrow_back,
                size: 30,
              ),
              onPressed: () => Navigator.of(context).pop(),
            )
          : null,
      backgroundColor: ThemeColors.primary,
      centerTitle: true,
      title: Text(
        title,
        style: const TextStyle(
            fontSize: 24,
            fontWeight: FontWeight.w500,
            color: ThemeColors.black),
      ),
      actions: actionButton != null ? [actionButton!] : [],
    );
  }

  @override
  Size get preferredSize => Size.fromHeight(appBar.preferredSize.height);
}
