import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';

class CustomPanGestureRecognizer extends VerticalDragGestureRecognizer {
  @override
  void rejectGesture(int pointer) {
    try {
      acceptGesture(pointer);
    } catch (e) {
      super.rejectGesture(pointer);
    }
  }
}

class CustomVerticalDragDetector extends StatelessWidget {
  const CustomVerticalDragDetector({
    this.child,
    this.onDown,
    this.onStart,
    this.onUpdate,
    this.onEnd,
    this.onCancel,
    Key? key,
  }) : super(key: key);

  final Widget? child;
  final GestureDragDownCallback? onDown;
  final GestureDragStartCallback? onStart;
  final GestureDragUpdateCallback? onUpdate;
  final GestureDragEndCallback? onEnd;
  final GestureDragCancelCallback? onCancel;

  @override
  Widget build(BuildContext context) {
    return RawGestureDetector(gestures: {
      CustomPanGestureRecognizer:
          GestureRecognizerFactoryWithHandlers<CustomPanGestureRecognizer>(
              () => CustomPanGestureRecognizer(), (instance) {
        instance.onDown = onDown;
        instance.onStart = onStart;
        instance.onUpdate = onUpdate;
        instance.onEnd = onEnd;
        instance.onCancel = onCancel;
      }),
    }, child: child);
  }
}
