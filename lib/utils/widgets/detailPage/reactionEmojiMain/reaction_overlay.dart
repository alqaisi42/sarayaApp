import 'package:flutter/material.dart';
import 'package:newsapp/utils/widgets/detailPage/reactionEmojiMain/reaction.dart';




class ReactionOverlay extends StatefulWidget {
  const ReactionOverlay({
    super.key,
    required this.onDismiss,
    required this.onPressReact,
    required this.relativeRect,
    required this.overlaySize,
    required this.reactions,
    this.backgroundColor,
    this.size,
  });
  final Function() onDismiss;
  final Function(int) onPressReact;
  final List<String> reactions;
  final RelativeRect relativeRect;
  final double overlaySize;
  final Color? backgroundColor;
  final Size? size;

  @override
  State<ReactionOverlay> createState() => _ReactionOverlayState();
}



class _ReactionOverlayState extends State<ReactionOverlay>
    with TickerProviderStateMixin {
  late AnimationController overlayController;
  late Animation<double> overlayAnimation;

  final Map<int, AnimationController> _scaleControllers = {};
  final Map<int, Animation<double>> _scaleAnimations = {};
  final Map<int, Animation<double>> _translateAnimations = {};

  int? _hoveredIndex;

  @override
  void initState() {
    super.initState();
    overlayController = AnimationController(
        vsync: this, duration: const Duration(milliseconds: 300));

    overlayAnimation = CurvedAnimation(
      parent: overlayController,
      curve: Curves.easeInSine,
    );

    for (int i = 0; i < widget.reactions.length; i++) {
      _scaleControllers[i] = AnimationController(
        vsync: this,
        duration: const Duration(milliseconds: 500),
      );

      _scaleAnimations[i] = Tween<double>(
        begin: 1.0,
        end: 2.0,
      ).animate(CurvedAnimation(
        parent: _scaleControllers[i]!,
        curve: Curves.easeOutBack,
        reverseCurve: Curves.easeInQuad,
      ));

      _translateAnimations[i] = Tween<double>(
        begin: 0.0,
        end: -30.0,
      ).animate(CurvedAnimation(
        parent: _scaleControllers[i]!,
        curve: Curves.easeOutBack,
        reverseCurve: Curves.easeInQuad,
      ));
    }

    overlayController.forward();
  }

  @override
  void dispose() {
    overlayController.dispose();
    for (var controller in _scaleControllers.values) {
      controller.dispose();
    }
    super.dispose();
  }

  void _onHover(int? index) {
    if (index == null) {
      if (_hoveredIndex != null) {
        _scaleControllers[_hoveredIndex!]?.reverse();
      }
    } else {
      if (_hoveredIndex != index) {
        if (_hoveredIndex != null) {
          _scaleControllers[_hoveredIndex!]?.reverse();
        }
        _scaleControllers[index]?.forward();
      }
    }

    setState(() {
      _hoveredIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    double overlayWidth = widget.reactions.length * 48.0; // Adjusted width

    return Material(
      type: MaterialType.transparency,
      child: SizedBox(
        width: MediaQuery.of(context).size.width,
        height: MediaQuery.of(context).size.height,
        child: Stack(
          children: [
            Positioned.fill(
              child: GestureDetector(
                onTap: widget.onDismiss,
                child: Container(
                  color: Colors.transparent,
                ),
              ),
            ),
            Positioned.fromRelativeRect(
              rect: widget.relativeRect,
              child: ScaleTransition(
                scale: overlayAnimation,
                child: Stack(
                  clipBehavior: Clip.none,
                  children: [
                    Container(
                      width: overlayWidth, // Adjusted width
                      height: 52,
                      decoration: BoxDecoration(
                        color: Theme.of(context).primaryColor,
                        borderRadius: BorderRadius.circular(26),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withValues(alpha:0.2),
                            blurRadius: 8,
                            spreadRadius: 1,
                          ),
                        ],
                      ),
                    ),
                    SizedBox(
                      width: overlayWidth, // Adjusted width
                      height: 52,
                      child: SingleChildScrollView(
                        scrollDirection: Axis.horizontal,
                        physics: const NeverScrollableScrollPhysics(),
                        child: Row(
                          mainAxisSize: MainAxisSize.min, // Prevent extra space
                          mainAxisAlignment: MainAxisAlignment.center, // Center items
                          children: [
                            for (int i = 0; i < widget.reactions.length; i++) ...[
                              AnimatedBuilder(
                                animation: Listenable.merge([
                                  _scaleAnimations[i]!,
                                  _translateAnimations[i]!,
                                ]),
                                builder: (context, child) {
                                  return Transform.translate(
                                    offset: Offset(0, _translateAnimations[i]!.value),
                                    child: Transform.scale(
                                      scale: _scaleAnimations[i]!.value,
                                      child: child,
                                    ),
                                  );
                                },
                                child: MouseRegion(
                                  onEnter: (_) => _onHover(i),
                                  onExit: (_) => _onHover(null),
                                  child: GestureDetector(
                                    onTap: () => widget.onPressReact(i),
                                    onHorizontalDragUpdate: (details) {
                                      final RenderBox box = context.findRenderObject() as RenderBox;
                                      final Offset localPosition = box.globalToLocal(details.globalPosition);
                                      final int? hoveredIndex = _getHoveredIndex(localPosition);
                                      if (hoveredIndex != _hoveredIndex) {
                                        _onHover(hoveredIndex);
                                      }
                                    },
                                    child: Padding(
                                      padding: const EdgeInsets.symmetric(horizontal: 4.0),
                                      child: Container(
                                        height: 40,
                                        width: 40,
                                        decoration: BoxDecoration(
                                          shape: BoxShape.circle,
                                          boxShadow: _hoveredIndex == i ? [
                                            BoxShadow(
                                              color: Colors.black.withValues(alpha:0.2),
                                              blurRadius: 8,
                                              spreadRadius: 1,
                                            ),
                                          ] : null,
                                        ),
                                        child: Reaction(
                                          path: widget.reactions[i],
                                          onTap: widget.onPressReact,
                                          index: i,
                                          size: const Size(40, 40),
                                        ),
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                            ],
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  int? _getHoveredIndex(Offset localPosition) {
    final double itemWidth = 48;
    final int index = (localPosition.dx / itemWidth).floor();

    if (index >= 0 && index < widget.reactions.length) {
      return index;
    }
    return null;
  }
}



//
// class _ReactionOverlayState extends State<ReactionOverlay>
//     with TickerProviderStateMixin {
//   late AnimationController overlayController;
//   late Animation<double> overlayAnimation;
//
//   final Map<int, AnimationController> _scaleControllers = {};
//   final Map<int, Animation<double>> _scaleAnimations = {};
//   final Map<int, Animation<double>> _translateAnimations = {};
//
//   int? _hoveredIndex;
//
//   @override
//   void initState() {
//     super.initState();
//     overlayController = AnimationController(
//         vsync: this, duration: const Duration(milliseconds: 300));
//
//     overlayAnimation = CurvedAnimation(
//       parent: overlayController,
//       curve: Curves.easeInSine,
//     );
//
//     for (int i = 0; i < widget.reactions.length; i++) {
//       _scaleControllers[i] = AnimationController(
//         vsync: this,
//         duration: const Duration(milliseconds: 500),
//       );
//
//       _scaleAnimations[i] = Tween<double>(
//         begin: 1.0,
//         end: 2.0,
//       ).animate(CurvedAnimation(
//         parent: _scaleControllers[i]!,
//         curve: Curves.easeOutBack,
//         reverseCurve: Curves.easeInQuad,
//       ));
//
//       _translateAnimations[i] = Tween<double>(
//         begin: 0.0,
//         end: -30.0,
//       ).animate(CurvedAnimation(
//         parent: _scaleControllers[i]!,
//         curve: Curves.easeOutBack,
//         reverseCurve: Curves.easeInQuad,
//       ));
//     }
//
//     overlayController.forward();
//   }
//
//   @override
//   void dispose() {
//     overlayController.dispose();
//     for (var controller in _scaleControllers.values) {
//       controller.dispose();
//     }
//     super.dispose();
//   }
//
//   void _onHover(int? index) {
//     if (index == null) {
//       if (_hoveredIndex != null) {
//         _scaleControllers[_hoveredIndex!]?.reverse();
//       }
//     } else {
//       if (_hoveredIndex != index) {
//         if (_hoveredIndex != null) {
//           _scaleControllers[_hoveredIndex!]?.reverse();
//         }
//         _scaleControllers[index]?.forward();
//       }
//     }
//
//     setState(() {
//       _hoveredIndex = index;
//     });
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     return Material(
//       type: MaterialType.transparency,
//       child: SizedBox(
//         width: MediaQuery.of(context).size.width,
//         height: MediaQuery.of(context).size.height,
//         child: Stack(
//           children: [
//             Positioned.fill(
//               child: GestureDetector(
//                 onTap: widget.onDismiss,
//                 child: Container(
//                   color: Colors.transparent,
//                 ),
//               ),
//             ),
//             Positioned.fromRelativeRect(
//               rect: widget.relativeRect,
//               child: ScaleTransition(
//                 scale: overlayAnimation,
//                 child: Stack(
//                   clipBehavior: Clip.none,
//                   children: [
//                     Container(
//                       width: widget.overlaySize,
//                       height: 52,
//                       decoration: BoxDecoration(
//                         color: Theme.of(context).primaryColor,
//                         borderRadius: BorderRadius.circular(26),
//                         boxShadow: [
//                           BoxShadow(
//                             color: Colors.black.withValues(alpha:0.2),
//                             blurRadius: 8,
//                             spreadRadius: 1,
//                           ),
//                         ],
//                       ),
//                     ),
//                     SizedBox(
//                       width: widget.overlaySize,
//                       height: 52,
//                       child: SingleChildScrollView(
//                         scrollDirection: Axis.horizontal,
//                         physics: const NeverScrollableScrollPhysics(),
//                         child: Row(
//                           mainAxisAlignment: MainAxisAlignment.spaceEvenly,
//                           children: [
//                             const SizedBox(width: 6),
//                             for (int i = 0; i < widget.reactions.length; i++) ...[
//                               AnimatedBuilder(
//                                 animation: Listenable.merge([
//                                   _scaleAnimations[i]!,
//                                   _translateAnimations[i]!,
//                                 ]),
//                                 builder: (context, child) {
//                                   return Transform.translate(
//                                     offset: Offset(0, _translateAnimations[i]!.value),
//                                     child: Transform.scale(
//                                       scale: _scaleAnimations[i]!.value,
//                                       child: child,
//                                     ),
//                                   );
//                                 },
//                                 child: MouseRegion(
//                                   onEnter: (_) => _onHover(i),
//                                   onExit: (_) => _onHover(null),
//                                   child: GestureDetector(
//                                     onTap: () => widget.onPressReact(i),
//                                     onHorizontalDragUpdate: (details) {
//                                       final RenderBox box = context.findRenderObject() as RenderBox;
//                                       final Offset localPosition = box.globalToLocal(details.globalPosition);
//                                       final int? hoveredIndex = _getHoveredIndex(localPosition);
//                                       if (hoveredIndex != _hoveredIndex) {
//                                         _onHover(hoveredIndex);
//                                       }
//                                     },
//                                     child: Padding(
//                                       padding: const EdgeInsets.symmetric(horizontal: 4.0),
//                                       child: Container(
//                                         height: 40,
//                                         width: 40,
//                                         decoration: BoxDecoration(
//                                           shape: BoxShape.circle,
//                                           boxShadow: _hoveredIndex == i ? [
//                                             BoxShadow(
//                                               color: Colors.black.withValues(alpha:0.2),
//                                               blurRadius: 8,
//                                               spreadRadius: 1,
//                                             ),
//                                           ] : null,
//                                         ),
//                                         child: Reaction(
//                                           path: widget.reactions[i],
//                                           onTap: widget.onPressReact,
//                                           index: i,
//                                           size: const Size(40, 40),
//                                         ),
//                                       ),
//                                     ),
//                                   ),
//                                 ),
//                               ),
//                             ],
//                             const SizedBox(width: 6),
//                           ],
//                         ),
//                       ),
//                     ),
//                   ],
//                 ),
//               ),
//             ),
//           ],
//         ),
//       ),
//     );
//   }
//
//   int? _getHoveredIndex(Offset localPosition) {
//     final double itemWidth = 48;
//     final int index = (localPosition.dx / itemWidth).floor();
//
//     if (index >= 0 && index < widget.reactions.length) {
//       return index;
//     }
//     return null;
//   }
// }


