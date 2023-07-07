import 'dart:async';

import 'package:flutter/widgets.dart';
import 'package:visibility_detector/visibility_detector.dart';

class ListViewItemTracker extends StatefulWidget {
  const ListViewItemTracker({
    Key? key,
    required this.child,
    required this.onExposed,
    required this.tag,
    this.exposeFactor = 0.5,
    this.confirmExposureDuration = const Duration(milliseconds: 500),
  }) : super(key: key);
  final Widget child;
  final String tag;
  final Function onExposed;
  final double exposeFactor;
  final Duration confirmExposureDuration;

  @override
  State<ListViewItemTracker> createState() => _ListViewItemTrackerState();
}

class _ListViewItemTrackerState extends State<ListViewItemTracker> {
  bool exposed = false;
  late VisibilityInfo currentInfo;
  @override
  void didUpdateWidget(covariant ListViewItemTracker oldWidget) {
    super.didUpdateWidget(oldWidget);
    exposed = false;
  }

  @override
  Widget build(BuildContext context) {
    return VisibilityDetector(
      onVisibilityChanged: (info) {
        currentInfo = info;
        if (!exposed &&
            info.visibleBounds.height >=
                info.size.height * widget.exposeFactor) {
          exposed = true;
          Future.delayed(widget.confirmExposureDuration, () {
            if (mounted &&
                currentInfo.visibleBounds.height >=
                    currentInfo.size.height * widget.exposeFactor) {
              widget.onExposed.call();
            }
          });
        }
      },
      key: ValueKey(widget.tag),
      child: widget.child,
    );
  }
}
