import 'package:flutter/material.dart';
import 'package:logger/logger.dart';
import 'package:vocab_trainer_app/misc/colors.dart';

class ModeButton extends StatelessWidget {
  final VoidCallback? onPress;
  final IconData iconData;
  final Color bkgIconColor;
  final String name;
  final String tag;
  final Logger logger = Logger();

  ModeButton(
      {super.key,
      required this.iconData,
      required this.name,
      required this.tag,
      this.onPress,
      this.bkgIconColor = ThemeColors.blue});

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 100,
      decoration: BoxDecoration(
        color: ThemeColors.primary,
        // color: Colors.transparent,
        borderRadius: const BorderRadius.all(Radius.circular(30)),
        boxShadow: [
          BoxShadow(
              blurRadius: 4,
              offset: const Offset(0, 4),
              color: Colors.black.withOpacity(.2))
        ],
      ),
      clipBehavior: Clip.hardEdge,
      child: Material(
        // color: ThemeColors.primary,
        color: Colors.transparent,
        // borderRadius: BorderRadius.all(Radius.circular(30)),
        child: InkWell(
          onTap: onPress,
          child: Row(
            children: [
              Container(
                margin: const EdgeInsets.fromLTRB(25, 0, 15, 0),
                padding: const EdgeInsets.all(10),
                width: 60,
                height: 60,
                decoration: BoxDecoration(
                    color: bkgIconColor,
                    borderRadius: const BorderRadius.all(Radius.circular(10))),
                child: Container(
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(100),
                      border: Border.all(
                          color: Colors.white,
                          width: 2,
                          strokeAlign: BorderSide.strokeAlignCenter),
                    ),
                    child: Icon(
                      iconData,
                      color: Colors.white,
                      size: 30,
                    )),
              ),
              Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    name,
                    style: const TextStyle(
                        fontSize: 24, fontWeight: FontWeight.w500),
                  ),
                  const SizedBox(height: 2),
                  Text(
                    tag,
                    style: const TextStyle(
                        fontSize: 16, fontWeight: FontWeight.w300),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}

/*

child: ClipRRect(
          borderRadius: const BorderRadius.only(
              topRight: Radius.circular(20), topLeft: Radius.circular(20)),
          child:

          */
