// TODO: Revisit whether this could work with composition or inheritance (or both)


// import 'package:flutter/material.dart';
// import 'package:vocab_trainer_app/misc/colors.dart';

// void showOverlay(BuildContext context, Widget child) {
//   OverlayState overlayState = Overlay.of(context);
//   OverlayEntry? content;
//   content = OverlayEntry(
//     builder: (context) {
//       return _OverlayBase(
//         reference: content,
//         child: child,
//       );
//     },
//   );
//   overlayState.insert(content);
// }

// // Listener that can be called
// // Make an interface for a overlay child widget that can take the dismiss overlay function from here,
// // Then call it where appropriate in the actual versions of the widget

// class _OverlayBase extends StatefulWidget {
//   final OverlayEntry? reference;
//   final Widget child;

//   const _OverlayBase({required this.child, this.reference});

//   @override
//   State<_OverlayBase> createState() => _OverlayBaseState();
// }

// class _OverlayBaseState extends State<_OverlayBase>
//     with TickerProviderStateMixin {
//   late AnimationController _opacityAnimationController;
//   late Animation<double> _opacityAnimation;

//   @override
//   void initState() {
//     _opacityAnimationController = AnimationController(
//       vsync: this,
//       duration: const Duration(milliseconds: 150),
//     );

//     _opacityAnimation =
//         Tween(begin: 0.0, end: 1.0).animate(_opacityAnimationController);
//     _opacityAnimationController.forward();

//     super.initState();
//   }

//   @override
//   void dispose() {
//     _opacityAnimationController.dispose();

//     super.dispose();
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       backgroundColor: Colors.transparent,
//       body: FadeTransition(
//         opacity: _opacityAnimation,
//         child: Stack(
//           children: [
//             ModalBarrier(
//               color: ThemeColors.black.withOpacity(.6),
//               dismissible: true,
//               onDismiss: () {
//                 _opacityAnimationController
//                     .reverse()
//                     .whenComplete(() => widget.reference?.remove());
//               },
//             ),
//             Center(
//               child: Container(
//                 width: MediaQuery.of(context).size.width * .8,
//                 decoration: const BoxDecoration(
//                   borderRadius: BorderRadius.all(
//                     Radius.circular(30),
//                   ),
//                   color: ThemeColors.accent,
//                 ),
//                 padding:
//                     const EdgeInsets.symmetric(vertical: 30, horizontal: 30),
//                 child: widget.child,
//               ),
//             ),
//           ],
//         ),
//       ),
//     );
//   }
// }
