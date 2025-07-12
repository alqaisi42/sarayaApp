import 'package:audioplayers/audioplayers.dart';
import 'package:flutter/material.dart';


class Reaction extends StatefulWidget {
  const Reaction({
    super.key,
    required this.path,
    required this.onTap,
    required this.index,
    required this.size,
  });
  final String path;
  final int index;
  final Size size;
  final Function(int) onTap;

  @override
  State<Reaction> createState() => _ReactionState();
}

class _ReactionState extends State<Reaction> with TickerProviderStateMixin {
  late AnimationController iconScaleController;
  late AnimationController slideController;
  final player = AudioPlayer();

  @override
  void initState() {
    super.initState();
    iconScaleController = AnimationController(
        vsync: this,
        duration: const Duration(milliseconds: 200)
    );
    slideController = AnimationController(
        vsync: this,
        duration: const Duration(milliseconds: 100)
    );
  }

  @override
  void dispose() {
    iconScaleController.dispose();
    slideController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return SlideTransition(
      position: Tween<Offset>(
          begin: Offset.zero,
          end: const Offset(0.0, -0.3)
      ).animate(
        CurvedAnimation(
          curve: Curves.linear,
          parent: slideController,
        ),
      ),
      child: Container(
        width: widget.size.width,
        height: widget.size.height,
        alignment: Alignment.center,
        child: GestureDetector(
          onTap: () {
            iconScaleController.forward().whenComplete(() async {
              await player.play(AssetSource("audio/pop.mp3"));
              widget.onTap(widget.index);
            });
          },
          onPanStart: (details) {
            slideController.forward();
            iconScaleController.forward();
          },
          onPanUpdate: (details) {
            slideController.forward();
            iconScaleController.forward();
          },
          onPanEnd: (details) {
            iconScaleController.reverse();
            slideController.reverse();
          },
          child: ScaleTransition(
            scale: Tween(begin: 1.0, end: 1.5).animate(
              CurvedAnimation(
                curve: Curves.fastEaseInToSlowEaseOut,
                parent: iconScaleController,
              ),
            ),
            child: Image(
              image: AssetImage(widget.path),
              width: widget.size.width,
              height: widget.size.height,
              fit: BoxFit.contain,
            ),
          ),
        ),
      ),
    );
  }
}


