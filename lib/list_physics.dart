import 'package:flutter/material.dart';

class FastListPhysics extends AlwaysScrollableScrollPhysics {
  const FastListPhysics({ScrollPhysics? parent}) : super(parent: parent);

  @override
  FastListPhysics applyTo(ScrollPhysics? ancestor) {
    return FastListPhysics(parent: buildParent(ancestor));
  }

  @override
  Simulation? createBallisticSimulation(
      ScrollMetrics position, double velocity) {
    final Tolerance tolerance = this.tolerance;
    if (velocity.abs() >= tolerance.velocity || position.outOfRange) {
      return BouncingScrollSimulation(
        spring: spring,
        position: position.pixels,
        velocity: velocity * 0.99, // 修改
        leadingExtent: position.minScrollExtent,
        trailingExtent: position.maxScrollExtent,
        tolerance: tolerance,
      );
    }
    return null;
  }

  @override
  double get maxFlingVelocity => super.maxFlingVelocity * 10;
}

class SlowListPhysics extends AlwaysScrollableScrollPhysics {
  const SlowListPhysics({ScrollPhysics? parent}) : super(parent: parent);

  @override
  SlowListPhysics applyTo(ScrollPhysics? ancestor) {
    return SlowListPhysics(parent: buildParent(ancestor));
  }

  @override
  Simulation? createBallisticSimulation(
      ScrollMetrics position, double velocity) {
    final Tolerance tolerance = this.tolerance;
    if (velocity.abs() >= tolerance.velocity || position.outOfRange) {
      return BouncingScrollSimulation(
        spring: spring,
        position: position.pixels,
        velocity: velocity * 0.95,
        // 修改
        leadingExtent: position.minScrollExtent,
        trailingExtent: position.maxScrollExtent,
        tolerance: tolerance,
      );
    }
    return null;
  }

  @override
  double get maxFlingVelocity => super.maxFlingVelocity * 7;
}

class SlowClampingListPhysics extends ClampingScrollPhysics {
  const SlowClampingListPhysics({ScrollPhysics? parent}) : super(parent: parent);

  @override
  SlowClampingListPhysics applyTo(ScrollPhysics? ancestor) {
    return SlowClampingListPhysics(parent: buildParent(ancestor));
  }

  @override
  Simulation? createBallisticSimulation(
      ScrollMetrics position, double velocity) {
    return super.createBallisticSimulation(position, velocity * 0.95);
  }

  @override
  double get maxFlingVelocity => super.maxFlingVelocity * 7;
}
