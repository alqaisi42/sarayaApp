


import 'package:flutter/material.dart';
import 'package:newsapp/utils/widgets/detailPage/reactionEmojiMain/reaction_data.dart';
import 'package:newsapp/utils/widgets/detailPage/reactionEmojiMain/reaction_overlay.dart';







class AnimatedReaction extends NavigatorObserver {
  OverlayEntry? overlayEntry;
  late OverlayState overlayState;
  BuildContext? _context;
  LocalHistoryEntry? _historyEntry;

  @override
  void didPop(Route<dynamic> route, Route<dynamic>? previousRoute) {
    super.didPop(route, previousRoute);
    if (_context != null) {
      hideOverlay(_context!);
    }
  }

  void showOverlay({
    required BuildContext context,
    required GlobalKey key,
    List<String>? reactions,
    required Function(int) onReaction,
    Color? backgroundColor,
    double? overlaySize,
    Size? iconSize,
  }) {
    // Clean up any existing overlay and history entry
    if (_context != null) {
      hideOverlay(_context!);
    }

    _context = context;

    // Create and add new history entry
    _historyEntry = LocalHistoryEntry(
      onRemove: () {
        hideOverlay(context);
      },
    );

    ModalRoute.of(context)?.addLocalHistoryEntry(_historyEntry!);

    RenderBox? box = key.currentContext!.findRenderObject() as RenderBox;
    final Offset topLeft = box.size.topCenter(box.localToGlobal(Offset.zero));
    final Offset bottomRight = box.size.bottomCenter(box.localToGlobal(Offset.zero));
    overlaySize ??= MediaQuery.of(context).size.width * 0.9;

    double top = topLeft.dy > MediaQuery.of(context).size.height * 0.3
        ? topLeft.dy - 70
        : bottomRight.dy;
    double bottom = topLeft.dy < MediaQuery.of(context).size.height * 0.3
        ? MediaQuery.of(context).size.height - bottomRight.dy - 60
        : MediaQuery.of(context).size.height - bottomRight.dy +
        (bottomRight.dy - topLeft.dy) +
        10;

    RelativeRect relativeRect = RelativeRect.fromLTRB(
      (MediaQuery.of(context).size.width - overlaySize) / 2,
      top,
      (MediaQuery.of(context).size.width - overlaySize) / 2,
      bottom,
    );

    overlayEntry = OverlayEntry(
      builder: (context) {
        return PopScope(
          onPopInvokedWithResult: (bool didPop, Object? result) {
            hideOverlay(context);
            if (!didPop) return;
          },
          child: ReactionOverlay(
            onDismiss: () {
              hideOverlay(context);
            },
            relativeRect: relativeRect,
            overlaySize: overlaySize ?? MediaQuery.of(context).size.width * 0.3,
            reactions: reactions ?? ReactionData.facebookReactionIcon,
            onPressReact: (val) {
              hideOverlay(context);
              onReaction(val);
            },
            size: iconSize,
            backgroundColor: Theme.of(context).colorScheme.primary,
          ),
        );
      },
    );

    overlayState = Overlay.of(context);
    overlayState.insert(overlayEntry!);
  }

  void hideOverlay(BuildContext context) {
    // Remove the history entry
    _historyEntry?.remove();
    _historyEntry = null;

    // Remove the overlay
    if (overlayEntry?.mounted ?? false) {
      overlayEntry?.remove();
      overlayEntry = null;
    }

    _context = null;
  }

  void dispose() {
    if (_context != null) {
      hideOverlay(_context!);
    }

  }
}



