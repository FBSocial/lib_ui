import 'dart:math';
import 'dart:ui';

import 'package:flutter/foundation.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:get/get_navigation/src/routes/custom_transition.dart';

class FanbookCupertinoTransition extends CustomTransition {
  FanbookCupertinoTransition({this.ignoreCircleVideoSliderGesture = false});

  final bool ignoreCircleVideoSliderGesture;

  static _CupertinoBackGestureController<T> _startPopGesture<T>(
      PageRoute<T> route) {
    return _CupertinoBackGestureController<T>(
      navigator: route.navigator!,
      // ignore: invalid_use_of_protected_member
      controller: route.controller,
    );
  }

  @override
  Widget buildTransition(
      BuildContext context,
      Curve? curve,
      Alignment? alignment,
      Animation<double> animation,
      Animation<double> secondaryAnimation,
      Widget child) {
    return _FanbookCupertinoTransition(
      primaryRouteAnimation: animation,
      secondaryRouteAnimation: secondaryAnimation,
      linearTransition: false,
      child: _CupertinoBackGestureDetector(
          enabledCallback: () => true,
          onStartPopGesture: () =>
              _startPopGesture(ModalRoute.of(context) as PageRoute),
          ignoreCircleVideoSliderGesture: ignoreCircleVideoSliderGesture,
          child: child),
    );
  }
}

final Animatable<Offset> _kRightMiddleTween = Tween<Offset>(
  begin: const Offset(1, 0),
  end: Offset.zero,
);

// Offset from fully on screen to 1/3 offscreen to the left.
final Animatable<Offset> _kMiddleLeftTween = Tween<Offset>(
  begin: Offset.zero,
  end: const Offset(0, 0),
);

final DecorationTween _kGradientShadowTween = DecorationTween(
  begin: _CupertinoEdgeShadowDecoration.none, // No decoration initially.
  end: const _CupertinoEdgeShadowDecoration(
    edgeGradient: LinearGradient(
      // Spans 5% of the page.
      begin: AlignmentDirectional(0.90, 0),
      end: AlignmentDirectional.centerEnd,
      // Eyeballed gradient used to mimic a drop shadow on the start side only.
      colors: <Color>[
        Color(0x00000000),
        Color(0x04000000),
        Color(0x12000000),
        Color(0x38000000),
      ],
      stops: <double>[0, 0.3, 0.6, 1],
    ),
  ),
);

class _FanbookCupertinoTransition extends StatelessWidget {
  _FanbookCupertinoTransition({
    Key? key,
    required Animation<double> primaryRouteAnimation,
    required Animation<double> secondaryRouteAnimation,
    required this.child,
    required bool linearTransition,
  })  : _primaryPositionAnimation = (linearTransition
                ? primaryRouteAnimation
                : CurvedAnimation(
                    // The curves below have been rigorously derived from plots of native
                    // iOS animation frames. Specifically, a video was taken of a page
                    // transition animation and the distance in each frame that the page
                    // moved was measured. A best fit bezier curve was the fitted to the
                    // point set, which is linearToEaseIn. Conversely, easeInToLinear is the
                    // reflection over the origin of linearToEaseIn.
                    parent: primaryRouteAnimation,
                    curve: Curves.linearToEaseOut,
                    reverseCurve: Curves.easeInToLinear,
                  ))
            .drive(_kRightMiddleTween),
        _secondaryPositionAnimation = (linearTransition
                ? secondaryRouteAnimation
                : CurvedAnimation(
                    parent: secondaryRouteAnimation,
                    curve: Curves.linearToEaseOut,
                    reverseCurve: Curves.easeInToLinear,
                  ))
            .drive(_kMiddleLeftTween),
        _primaryShadowAnimation = (linearTransition
                ? primaryRouteAnimation
                : CurvedAnimation(
                    parent: primaryRouteAnimation,
                    curve: Curves.linearToEaseOut,
                  ))
            .drive(_kGradientShadowTween),
        super(key: key);

  // When this page is coming in to cover another page.
  final Animation<Offset> _primaryPositionAnimation;

  // When this page is becoming covered by another page.
  final Animation<Offset> _secondaryPositionAnimation;
  final Animation<Decoration> _primaryShadowAnimation;

  final Widget child;

  @override
  Widget build(BuildContext context) {
    return SlideTransition(
      position: _secondaryPositionAnimation,
      transformHitTests: false,
      child: SlideTransition(
        position: _primaryPositionAnimation,
        child: DecoratedBoxTransition(
          decoration: _primaryShadowAnimation,
          child: child,
        ),
      ),
    );
  }
}

class _CupertinoEdgeShadowDecoration extends Decoration {
  const _CupertinoEdgeShadowDecoration({this.edgeGradient});

  // An edge shadow decoration where the shadow is null. This is used
  // for interpolating from no shadow.
  static const _CupertinoEdgeShadowDecoration none =
      _CupertinoEdgeShadowDecoration();

  // A gradient to draw to the left of the box being decorated.
  // Alignments are relative to the original box translated one box
  // width to the left.
  final LinearGradient? edgeGradient;

  // Linearly interpolate between two edge shadow decorations decorations.
  //
  // The `t` argument represents position on the timeline, with 0.0 meaning
  // that the interpolation has not started, returning `a` (or something
  // equivalent to `a`), 1.0 meaning that the interpolation has finished,
  // returning `b` (or something equivalent to `b`), and values in between
  // meaning that the interpolation is at the relevant point on the timeline
  // between `a` and `b`. The interpolation can be extrapolated beyond 0.0 and
  // 1.0, so negative values and values greater than 1.0 are valid (and can
  // easily be generated by curves such as [Curves.elasticInOut]).
  //
  // Values for `t` are usually obtained from an [Animation<double>], such as
  // an [AnimationController].
  //
  // See also:
  //
  //  * [Decoration.lerp].
  static _CupertinoEdgeShadowDecoration? lerp(
    _CupertinoEdgeShadowDecoration? a,
    _CupertinoEdgeShadowDecoration? b,
    double t,
  ) {
    if (a == null && b == null) return null;
    return _CupertinoEdgeShadowDecoration(
      edgeGradient: LinearGradient.lerp(a?.edgeGradient, b?.edgeGradient, t),
    );
  }

  @override
  _CupertinoEdgeShadowDecoration? lerpFrom(Decoration? a, double t) {
    if (a is _CupertinoEdgeShadowDecoration) {
      return _CupertinoEdgeShadowDecoration.lerp(a, this, t);
    }
    return _CupertinoEdgeShadowDecoration.lerp(null, this, t);
  }

  @override
  _CupertinoEdgeShadowDecoration? lerpTo(Decoration? b, double t) {
    if (b is _CupertinoEdgeShadowDecoration) {
      return _CupertinoEdgeShadowDecoration.lerp(this, b, t);
    }
    return _CupertinoEdgeShadowDecoration.lerp(this, null, t);
  }

  @override
  _CupertinoEdgeShadowPainter createBoxPainter([VoidCallback? onChanged]) {
    return _CupertinoEdgeShadowPainter(this, onChanged);
  }

  @override
  bool operator ==(Object other) {
    if (other.runtimeType != runtimeType) return false;
    return other is _CupertinoEdgeShadowDecoration &&
        other.edgeGradient == edgeGradient;
  }

  @override
  int get hashCode => edgeGradient.hashCode;

  @override
  void debugFillProperties(DiagnosticPropertiesBuilder properties) {
    super.debugFillProperties(properties);
    properties
        .add(DiagnosticsProperty<LinearGradient>('edgeGradient', edgeGradient));
  }
}

class _CupertinoEdgeShadowPainter extends BoxPainter {
  _CupertinoEdgeShadowPainter(
    this._decoration,
    VoidCallback? onChange,
  ) : super(onChange);

  final _CupertinoEdgeShadowDecoration _decoration;

  @override
  void paint(Canvas canvas, Offset offset, ImageConfiguration configuration) {
    final LinearGradient? gradient = _decoration.edgeGradient;
    if (gradient == null) return;
    // The drawable space for the gradient is a rect with the same size as
    // its parent box one box width on the start side of the box.
    final TextDirection textDirection = configuration.textDirection!;
    late double deltaX;
    switch (textDirection) {
      case TextDirection.rtl:
        deltaX = configuration.size!.width;
        break;
      case TextDirection.ltr:
        deltaX = -configuration.size!.width;
        break;
    }
    final Rect rect = (offset & configuration.size!).translate(deltaX, 0);
    final Paint paint = Paint()
      ..shader = gradient.createShader(rect, textDirection: textDirection);

    canvas.drawRect(rect, paint);
  }
}

class _CupertinoBackGestureDetector<T> extends StatefulWidget {
  const _CupertinoBackGestureDetector({
    Key? key,
    required this.enabledCallback,
    required this.onStartPopGesture,
    required this.child,
    required this.ignoreCircleVideoSliderGesture,
  }) : super(key: key);

  final Widget child;

  final ValueGetter<bool> enabledCallback;

  final ValueGetter<_CupertinoBackGestureController<T>> onStartPopGesture;

  final bool ignoreCircleVideoSliderGesture;

  @override
  _CupertinoBackGestureDetectorState<T> createState() =>
      _CupertinoBackGestureDetectorState<T>();
}

class _CupertinoBackGestureDetectorState<T>
    extends State<_CupertinoBackGestureDetector<T>> {
  _CupertinoBackGestureController<T>? _backGestureController;

  late HorizontalDragGestureRecognizer _recognizer;

  @override
  void initState() {
    super.initState();
    _recognizer = HorizontalDragGestureRecognizer(debugOwner: this)
      ..onStart = _handleDragStart
      ..onUpdate = _handleDragUpdate
      ..onEnd = _handleDragEnd
      ..onCancel = _handleDragCancel;
  }

  @override
  void dispose() {
    _recognizer.dispose();
    super.dispose();
  }

  void _handleDragStart(DragStartDetails details) {
    assert(mounted);
    assert(_backGestureController == null);
    _backGestureController = widget.onStartPopGesture();
  }

  void _handleDragUpdate(DragUpdateDetails details) {
    assert(mounted);
    assert(_backGestureController != null);
    _backGestureController!.dragUpdate(
        _convertToLogical(details.primaryDelta! / context.size!.width));
  }

  void _handleDragEnd(DragEndDetails details) {
    assert(mounted);
    assert(_backGestureController != null);
    _backGestureController!.dragEnd(_convertToLogical(
        details.velocity.pixelsPerSecond.dx / context.size!.width));
    _backGestureController = null;
  }

  void _handleDragCancel() {
    assert(mounted);
    // This can be called even if start is not called, paired with the "down" event
    // that we don't consider here.
    _backGestureController?.dragEnd(0);
    _backGestureController = null;
  }

  void _handlePointerDown(PointerDownEvent event) {
    if (widget.enabledCallback()) _recognizer.addPointer(event);
  }

  // ignore: missing_return
  double _convertToLogical(double value) {
    switch (Directionality.of(context)) {
      case TextDirection.rtl:
        return -value;
      case TextDirection.ltr:
        return value;
    }
  }

  @override
  Widget build(BuildContext context) {
    assert(debugCheckHasDirectionality(context));
    // For devices with notches, the drag area needs to be larger on the side
    // that has the notch.
    double dragAreaWidth = Directionality.of(context) == TextDirection.ltr
        ? MediaQuery.of(context).padding.left
        : MediaQuery.of(context).padding.right;
    dragAreaWidth = max(dragAreaWidth, 20);
    final sliderSafeArea = MediaQuery.of(context).viewInsets.bottom + 70;
    return Stack(
      fit: StackFit.passthrough,
      children: <Widget>[
        widget.child,
        PositionedDirectional(
          start: 0,
          width: dragAreaWidth,
          top: 0,
          bottom: widget.ignoreCircleVideoSliderGesture ? sliderSafeArea : 0,
          child: Listener(
            onPointerDown: _handlePointerDown,
            behavior: HitTestBehavior.translucent,
          ),
        ),
      ],
    );
  }
}

class _CupertinoBackGestureController<T> {
  /// Creates a controller for an iOS-style back gesture.
  ///
  /// The [navigator] and [controller] arguments must not be null.
  _CupertinoBackGestureController({
    required this.navigator,
    required this.controller,
  }) {
    navigator.didStartUserGesture();
  }

  final AnimationController? controller;
  final NavigatorState navigator;

  /// The drag gesture has changed by [fractionalDelta]. The total range of the
  /// drag should be 0.0 to 1.0.
  void dragUpdate(double delta) {
    controller!.value -= delta;
  }

  /// The drag gesture has ended with a horizontal motion of
  /// [fractionalVelocity] as a fraction of screen width per second.
  void dragEnd(double velocity) {
    // Fling in the appropriate direction.
    // AnimationController.fling is guaranteed to
    // take at least one frame.
    //
    // This curve has been determined through rigorously eyeballing native iOS
    // animations.
    const Curve animationCurve = Curves.easeOut;
    bool animateForward;

    // If the user releases the page before mid screen with sufficient velocity,
    // or after mid screen, we should animate the page out. Otherwise, the page
    // should be animated back in.
    if (velocity.abs() >= 1.0) {
      animateForward = velocity <= 0;
    } else {
      animateForward = controller!.value > 0.5;
    }

    if (animateForward) {
      // The closer the panel is to dismissing, the shorter the animation is.
      // We want to cap the animation time, but we want to use a linear curve
      // to determine it.
      final droppedPageForwardAnimationTime = min(
        lerpDouble(
          800,
          0,
          controller!.value,
        )!
            .floor(),
        300,
      );
      controller!.animateTo(1,
          duration: Duration(milliseconds: droppedPageForwardAnimationTime),
          curve: Curves.fastLinearToSlowEaseIn);
    } else {
      // This route is destined to pop at this point. Reuse navigator's pop.
      navigator.pop();

      // The popping may have finished inline if already at the target
      // destination.
      if (controller!.isAnimating) {
        // Otherwise, use a custom popping animation duration and curve.
        final droppedPageBackAnimationTime = lerpDouble(
          0,
          300,
          controller!.value,
        )!
            .floor();
        controller!.animateBack(
          0,
          duration: Duration(milliseconds: droppedPageBackAnimationTime),
          curve: animationCurve,
        );
      }
    }

    if (controller!.isAnimating) {
      // Keep the userGestureInProgress in true state so we don't change the
      // curve of the page transition mid-flight since CupertinoPageTransition
      // depends on userGestureInProgress.
      late AnimationStatusListener animationStatusCallback;
      animationStatusCallback = (status) {
        navigator.didStopUserGesture();
        controller!.removeStatusListener(animationStatusCallback);
      };
      controller!.addStatusListener(animationStatusCallback);
    } else {
      navigator.didStopUserGesture();
    }
  }
}
