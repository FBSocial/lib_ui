import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/widgets.dart';

typedef FBPointOnDown = void Function();

class FBIgnorePointer extends SingleChildRenderObjectWidget {
  /// Creates a widget that is invisible to hit testing.
  ///
  /// The [ignoring] argument must not be null. If [ignoringSemantics] is null,
  /// this render object will be ignored for semantics if [ignoring] is true.
  const FBIgnorePointer({
    Key? key,
    required this.onDown,
    Widget? child,
  }) : super(key: key, child: child);

  final FBPointOnDown onDown;

  @override
  FBRenderIgnorePointer createRenderObject(BuildContext context) {
    return FBRenderIgnorePointer(onDown: onDown);
  }

  @override
  void updateRenderObject(
      BuildContext context, FBRenderIgnorePointer renderObject) {}
}

class FBRenderIgnorePointer extends RenderProxyBox {
  FBRenderIgnorePointer({
    RenderBox? child,
    required this.onDown,
  }) : super(child);

  final FBPointOnDown onDown;

  @override
  bool hitTest(BoxHitTestResult result, {Offset? position}) {
    onDown();
    return false;
  }

  @override
  void visitChildrenForSemantics(RenderObjectVisitor visitor) {
    if (child != null) visitor(child!);
  }

}
