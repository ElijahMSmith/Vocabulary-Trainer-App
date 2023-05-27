import 'dart:async';
import 'package:flutter/material.dart';
import 'package:vocab_trainer_app/misc/colors.dart';
import 'package:vocab_trainer_app/widgets/miscellaneous/custom_icons.dart';

class Toast {
  static void success(String content, BuildContext context) {
    _customToast(content, context, Icons.check_rounded, ThemeColors.green);
  }

  static void error(String content, BuildContext context) {
    _customToast(content, context, Icons.close_rounded, ThemeColors.red);
  }

  static void info(String content, BuildContext context) {
    _customToast(
        content, context, CustomIcons.info_no_outline, ThemeColors.blue,
        iconSize: 14, iconPadding: 8);
  }

  static void _customToast(String content, BuildContext context,
      IconData? iconType, Color backgroundColor,
      {double iconSize = 32, double iconPadding = 0}) {
    CustomToast(
      icon: iconType,
      iconSize: iconSize,
      iconPadding: iconPadding,
      backgroundColor: backgroundColor,
      title: Text(
        content,
        style: const TextStyle(
          fontSize: 18,
          fontWeight: FontWeight.w500,
          color: ThemeColors.primary,
        ),
      ),
      toastPosition: Position.Bottom,
      animationType: AnimationType.FromLeft,
      animationDuration: const Duration(milliseconds: 300),
      toastDuration: const Duration(milliseconds: 2000),
      autoDismiss: true,
      enableIconAnimation: false,
    ).show(context);
  }
}

// ignore: must_be_immutable
class CustomToast extends StatefulWidget {
  CustomToast({
    Key? key,
    required this.title,
    required this.icon,
    required this.backgroundColor,
    this.toastPosition = Position.Top,
    this.animationDuration = const Duration(
      milliseconds: 1500,
    ),
    this.animationCurve = Curves.ease,
    this.animationType = AnimationType.FromLeft,
    this.autoDismiss = true,
    this.toastDuration = const Duration(
      milliseconds: 3000,
    ),
    this.displayCloseButton = true,
    this.borderRadius = 10,
    this.enableIconAnimation = true,
    this.iconSize = 32,
    this.iconPadding = 0,
  }) : super(key: key);

  // Text content in Toast
  final Text title;

  // Leading icon
  final IconData? icon;

  // Container background color
  final Color backgroundColor;

  // Size of leading icon
  final double iconSize;

  // Padding for leading icon
  final double iconPadding;

  // Position displayed in screen, one of:
  // Position.Top, Position.Bottom
  final Position toastPosition;

  // Duration of toast enter/leave animation
  final Duration animationDuration;

  // Animation curve of the enter/leave animation
  final Cubic animationCurve;

  // The animation type applied on the toast, on of:
  // AnimationType.FromTop, AnimationType.FromLeft, AnimationType.FromRight, AnimationType.FromBottom
  final AnimationType animationType;

  // Whether toast will automatically dismiss itself
  final bool autoDismiss;

  // Duration before toast dismisses
  final Duration toastDuration;

  // Show the close button or not (false default)
  final bool displayCloseButton;

  // Default border radius of toast container (10 default)
  final double borderRadius;

  // Define wether the animation on the icon will be rendered or not
  final bool enableIconAnimation;

  OverlayEntry? ref;

  // Display the created toast using the current BuildContext
  void show(BuildContext context) {
    OverlayState overlayState = Overlay.of(context);

    ref = OverlayEntry(
      builder: (context) {
        return SafeArea(
          child: Column(
            mainAxisAlignment: toastPosition == Position.Bottom
                ? MainAxisAlignment.end
                : MainAxisAlignment.start,
            children: [
              AlertDialog(
                backgroundColor: Colors.transparent,
                elevation: 0,
                content: SizedBox(
                  child: this,
                ),
              ),
            ],
          ),
        );
      },
    );

    overlayState.insert(ref!);
  }

  void dismissOverlay() {
    if (ref != null) {
      ref!.remove();
      ref = null;
    }
  }

  @override
  State<CustomToast> createState() => _CustomToastState();
}

class _CustomToastState extends State<CustomToast>
    with TickerProviderStateMixin {
  late Animation<Offset> offsetAnimation;
  late AnimationController slideController;
  Timer? autoDismissTimer;

  @override
  void initState() {
    super.initState();
    _initAnimation();
    if (widget.autoDismiss) {
      autoDismissTimer = Timer(widget.toastDuration, () {
        slideController.reverse();
        Timer(widget.animationDuration, widget.dismissOverlay);
      });
    }
  }

  @override
  void dispose() {
    autoDismissTimer?.cancel();
    slideController.dispose();
    super.dispose();
  }

  // Initialize animation parameters [slideController] and [offsetAnimation]
  void _initAnimation() {
    slideController = AnimationController(
      duration: widget.animationDuration,
      vsync: this,
    );
    switch (widget.animationType) {
      case AnimationType.FromLeft:
        offsetAnimation = Tween<Offset>(
          begin: const Offset(-2, 0),
          end: const Offset(0, 0),
        ).animate(
          CurvedAnimation(
            parent: slideController,
            curve: widget.animationCurve,
          ),
        );
        break;
      case AnimationType.FromRight:
        offsetAnimation = Tween<Offset>(
          begin: const Offset(2, 0),
          end: const Offset(0, 0),
        ).animate(
          CurvedAnimation(
            parent: slideController,
            curve: widget.animationCurve,
          ),
        );
        break;
      case AnimationType.FromTop:
        offsetAnimation = Tween<Offset>(
          begin: const Offset(0, -2),
          end: const Offset(0, 0),
        ).animate(
          CurvedAnimation(
            parent: slideController,
            curve: widget.animationCurve,
          ),
        );
        break;
      case AnimationType.FromBottom:
        offsetAnimation = Tween<Offset>(
          begin: const Offset(0, 2),
          end: const Offset(0, 0),
        ).animate(
          CurvedAnimation(
            parent: slideController,
            curve: widget.animationCurve,
          ),
        );
        break;
      default:
    }

    WidgetsBinding.instance.addPostFrameCallback((_) {
      slideController.forward();
    });
  }

  Widget Spacer() {
    return const SizedBox(width: 16);
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: widget.toastPosition == Position.Top
          ? MainAxisAlignment.start
          : MainAxisAlignment.end,
      children: [
        SlideTransition(
          position: offsetAnimation,
          child: Container(
            decoration: BoxDecoration(
              color: widget.backgroundColor,
              borderRadius: BorderRadius.circular(widget.borderRadius),
              boxShadow: [
                BoxShadow(
                  color: ThemeColors.black.withOpacity(0.4),
                  spreadRadius: 1,
                  blurRadius: 2,
                  offset: const Offset(0, 1), // changes position of shadow
                ),
              ],
            ),
            margin: const EdgeInsets.only(bottom: 40),
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Container(
                    padding: EdgeInsets.all(widget.iconPadding),
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      border: Border.all(
                        width: 3,
                        color: ThemeColors.primary,
                      ),
                    ),
                    child: Center(
                      child: Icon(
                        widget.icon,
                        size: widget.iconSize,
                        color: ThemeColors.primary,
                      ),
                    ),
                  ),
                  Spacer(),
                  widget.title,
                  Spacer(),
                  widget.displayCloseButton
                      ? Padding(
                          padding: const EdgeInsets.only(),
                          child: _renderCloseButton(context),
                        )
                      : Container(),
                ],
              ),
            ),
          ),
        ),
      ],
    );
  }

  // Render close button that closes toast if clicked
  InkWell _renderCloseButton(BuildContext context) {
    return InkWell(
      onTap: () {
        slideController.reverse();
        autoDismissTimer?.cancel();
        Timer(
          widget.animationDuration,
          widget.dismissOverlay,
        );
      },
      child: const Icon(
        Icons.close,
        color: ThemeColors.primary,
        size: 20,
      ),
    );
  }
}

enum Position { Top, Bottom }

enum AnimationType { FromLeft, FromTop, FromRight, FromBottom }
