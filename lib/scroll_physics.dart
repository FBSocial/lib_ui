import 'dart:math' as math;

import 'package:flutter/foundation.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';

class BuffBouncingScrollPhysics extends ScrollPhysics {
  /// Creates scroll physics that bounce back from the edge.
  const BuffBouncingScrollPhysics({ScrollPhysics? parent})
      : super(parent: parent);

  @override
  BuffBouncingScrollPhysics applyTo(ScrollPhysics? ancestor) {
    return BuffBouncingScrollPhysics(parent: buildParent(ancestor));
  }

  /// The multiple applied to overscroll to make it appear that scrolling past
  /// the edge of the scrollable contents is harder than scrolling the list.
  /// This is done by reducing the ratio of the scroll effect output vs the
  /// scroll gesture input.
  ///
  /// This factor starts at 0.52 and progressively becomes harder to overscroll
  /// as more of the area past the edge is dragged in (represented by an increasing
  /// `overscrollFraction` which starts at 0 when there is no overscroll).
  double frictionFactor(double overscrollFraction) =>
      0.52 * math.pow(1 - overscrollFraction, 2);

  @override
  double applyPhysicsToUserOffset(ScrollMetrics position, double offset) {
    assert(offset != 0.0);
    assert(position.minScrollExtent <= position.maxScrollExtent);

    if (!position.outOfRange) return offset;

    final double overscrollPastStart =
        math.max(position.minScrollExtent - position.pixels, 0);
    final double overscrollPastEnd =
        math.max(position.pixels - position.maxScrollExtent, 0);
    final double overscrollPast =
        math.max(overscrollPastStart, overscrollPastEnd);
    final bool easing = (overscrollPastStart > 0.0 && offset < 0.0) ||
        (overscrollPastEnd > 0.0 && offset > 0.0);

    final double friction = easing
        // Apply less resistance when easing the overscroll vs tensioning.
        ? frictionFactor(
            (overscrollPast - offset.abs()) / position.viewportDimension)
        : frictionFactor(overscrollPast / position.viewportDimension);
    final double direction = offset.sign;

    return direction * _applyFriction(overscrollPast, offset.abs(), friction);
  }

  static double _applyFriction(
      double extentOutside, double absDelta, double gamma) {
    assert(absDelta > 0);
    double total = 0;
    if (extentOutside > 0) {
      final double deltaToLimit = extentOutside / gamma;
      if (absDelta < deltaToLimit) return absDelta * gamma;
      total += extentOutside;
      absDelta -= deltaToLimit;
    }
    return total + absDelta;
  }

  @override
  double applyBoundaryConditions(ScrollMetrics position, double value) => 0;

  @override
  Simulation? createBallisticSimulation(
      ScrollMetrics position, double velocity) {
    final Tolerance tolerance = this.tolerance;
    if (velocity.abs() >= tolerance.velocity || position.outOfRange) {
      return BouncingScrollSimulation(
        spring: spring,
        position: position.pixels,
        velocity: velocity * 1,
        leadingExtent: position.minScrollExtent,
        trailingExtent: position.maxScrollExtent,
        tolerance: tolerance,
      );
    }
    return null;
  }

  // The ballistic simulation here decelerates more slowly than the one for
  // ClampingScrollPhysics so we require a more deliberate input gesture
  // to trigger a fling.
  @override
  double get minFlingVelocity => kMinFlingVelocity * 2.0;

  // Methodology:
  // 1- Use https://github.com/flutter/scroll_overlay to test with Flutter and
  //    platform scroll views superimposed.
  // 2- Record incoming speed and make rapid flings in the test app.
  // 3- If the scrollables stopped overlapping at any moment, adjust the desired
  //    output value of this function at that input speed.
  // 4- Feed new input/output set into a power curve fitter. Change function
  //    and repeat from 2.
  // 5- Repeat from 2 with medium and slow flings.
  /// Momentum build-up function that mimics iOS's scroll speed increase with repeated flings.
  ///
  /// The velocity of the last fling is not an important factor. Existing speed
  /// and (related) time since last fling are factors for the velocity transfer
  /// calculations.
  @override
  double carriedMomentum(double existingVelocity) {
    return existingVelocity.sign *
        math.min(0.000816 * math.pow(existingVelocity.abs(), 1.967).toDouble(),
            40000.0);
  }

  // Eyeballed from observation to counter the effect of an unintended scroll
  // from the natural motion of lifting the finger after a scroll.
  @override
  double get dragStartDistanceMotionThreshold => 3.5;
}

class TabViewScrollPhysics extends ScrollPhysics {
  /// Creates scroll physics that bounce back from the edge.
  const TabViewScrollPhysics({ScrollPhysics? parent}) : super(parent: parent);

  @override
  SpringDescription get spring => const SpringDescription(
        mass: 80,
        stiffness: .01,
        damping: 1,
      );

  @override
  TabViewScrollPhysics applyTo(ScrollPhysics? ancestor) {
    return TabViewScrollPhysics(parent: buildParent(ancestor));
  }

  // Eyeballed from observation to counter the effect of an unintended scroll
  // from the natural motion of lifting the finger after a scroll.
  @override
  double get dragStartDistanceMotionThreshold => 50;

  @override
  double applyBoundaryConditions(ScrollMetrics position, double value) {
    assert(() {
      if (value == position.pixels) {
        throw FlutterError.fromParts(<DiagnosticsNode>[
          ErrorSummary(
              '$runtimeType.applyBoundaryConditions() was called redundantly.'),
          ErrorDescription(
              'The proposed new position, $value, is exactly equal to the current position of the '
              'given ${position.runtimeType}, ${position.pixels}.\n'
              'The applyBoundaryConditions method should only be called when the value is '
              'going to actually change the pixels, otherwise it is redundant.'),
          DiagnosticsProperty<ScrollPhysics>(
              'The physics object in question was', this,
              style: DiagnosticsTreeStyle.errorProperty),
          DiagnosticsProperty<ScrollMetrics>(
              'The position object in question was', position,
              style: DiagnosticsTreeStyle.errorProperty)
        ]);
      }
      return true;
    }());
    if (value < position.pixels &&
        position.pixels <= position.minScrollExtent) {
      return value - position.pixels;
    }
    if (position.maxScrollExtent <= position.pixels &&
        position.pixels < value) {
      return value - position.pixels;
    }
    if (value < position.minScrollExtent &&
        position.minScrollExtent < position.pixels) {
      return value - position.minScrollExtent;
    }
    if (position.pixels < position.maxScrollExtent &&
        position.maxScrollExtent < value) {
      return value - position.maxScrollExtent;
    }
    return 0;
  }
}

class CircleListViewScrollPhysics extends ScrollPhysics {
  /// Creates scroll physics that bounce back from the edge.
  const CircleListViewScrollPhysics({ScrollPhysics? parent})
      : super(parent: parent);

  @override
  CircleListViewScrollPhysics applyTo(ScrollPhysics? ancestor) {
    return CircleListViewScrollPhysics(parent: buildParent(ancestor));
  }

  @override
  bool shouldAcceptUserOffset(ScrollMetrics position) => true;

  @override
  double get dragStartDistanceMotionThreshold => 0;

  @override
  double get minFlingDistance => 1;
}

/// * 圈子详情页的ios滚动效果：顶部不回弹，底部可回弹
class CircleDetailScrollPhysics extends BouncingScrollPhysics {
  const CircleDetailScrollPhysics({ScrollPhysics? parent})
      : super(parent: parent);

  @override
  CircleDetailScrollPhysics applyTo(ScrollPhysics? ancestor) {
    return CircleDetailScrollPhysics(parent: buildParent(ancestor));
  }

  @override
  double applyBoundaryConditions(ScrollMetrics position, double value) {
    if (value < position.pixels &&
        position.pixels <= position.minScrollExtent) {
      return value - position.pixels;
    }
    if (value < position.minScrollExtent &&
        position.minScrollExtent < position.pixels) {
      return value - position.minScrollExtent;
    }
    return 0;
  }
}

///左右滑动: 松开手指后，加快滚动速度
SpringDescription swipeSpringDescription = const SpringDescription(
  mass: 70,
  stiffness: 50,
  damping: 1,
);

/// * 圈子详情页的顶部图片滚动组件-ios滚动效果
class CircleDetailSwipeIosScrollPhysics extends BouncingScrollPhysics {
  const CircleDetailSwipeIosScrollPhysics({ScrollPhysics? parent})
      : super(parent: parent);

  @override
  CircleDetailSwipeIosScrollPhysics applyTo(ScrollPhysics? ancestor) {
    return CircleDetailSwipeIosScrollPhysics(parent: buildParent(ancestor));
  }

  @override
  SpringDescription get spring => swipeSpringDescription;
}

/// * 圈子详情页的顶部图片滚动组件-android滚动效果
class CircleDetailSwipeAndroidScrollPhysics extends ClampingScrollPhysics {
  const CircleDetailSwipeAndroidScrollPhysics({ScrollPhysics? parent})
      : super(parent: parent);

  @override
  CircleDetailSwipeAndroidScrollPhysics applyTo(ScrollPhysics? ancestor) {
    return CircleDetailSwipeAndroidScrollPhysics(parent: buildParent(ancestor));
  }

  @override
  SpringDescription get spring => swipeSpringDescription;
}
