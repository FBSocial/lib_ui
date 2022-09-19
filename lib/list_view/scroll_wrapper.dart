import 'package:flutter/material.dart';
import 'package:flutter/physics.dart';

class ScrollWrapper extends StatefulWidget {
  final Widget child;

  const ScrollWrapper({Key? key, required this.child}) : super(key: key);

  @override
  _ScrollWrapperState createState() => _ScrollWrapperState();
}

class _ScrollWrapperState extends State<ScrollWrapper> {
  final ScrollStatus _scrollStatus = ScrollStatus();
  late CusScrollBehavior _behavior;

  @override
  void initState() {
    _behavior = CusScrollBehavior(_scrollStatus);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return ScrollConfiguration(
      behavior: _behavior,
      child: NotificationListener<ScrollNotification>(
        onNotification: (scrollNotification) {
          if (scrollNotification is ScrollStartNotification) {
//            logger.info('开始滑动');
          } else if (scrollNotification is ScrollUpdateNotification) {
//            logger.info('正在滑动');
            _scrollStatus.isJumpEnd = true;
          } else if (scrollNotification is ScrollEndNotification) {
//            logger.info('结束滑动');
            _scrollStatus.isJumpEnd = true;
          }
          return true;
        },
        child: widget.child,
      ),
    );
  }
}

class CusScrollBehavior extends ScrollBehavior {
  final ScrollStatus scrollStatus;

  const CusScrollBehavior(this.scrollStatus);

  @override
  ScrollPhysics getScrollPhysics(BuildContext context) {
    switch (getPlatform(context)) {
      case TargetPlatform.iOS:
      case TargetPlatform.macOS:
        return CusBouncingScrollPhysics(scrollStatus);
      case TargetPlatform.android:
      case TargetPlatform.fuchsia:
      case TargetPlatform.linux:
      case TargetPlatform.windows:
        return CusClampingScrollPhysics(scrollStatus);
    }
  }
}

class CusBouncingScrollPhysics extends BouncingScrollPhysics {
  final ScrollStatus scrollStatus;

  const CusBouncingScrollPhysics(this.scrollStatus, {ScrollPhysics? parent})
      : super(parent: parent);

  @override
  SpringDescription get spring {
    if (!hasInitial) {
      hasInitial = true;
      return super.spring;
    }
    if (!scrollStatus.hasInitial) {
      scrollStatus.hasInitial = true;
      return springDescription();
    }
    if (!hasPhysicsAdded(this)) {
      addHashcodeToSet(this);
      return springDescription();
    }
    if (!scrollStatus.hasScroll) return super.spring;
    if (scrollStatus.isJumpEnd) return super.spring;
    return springDescription();
  }

  @override
  BouncingScrollPhysics applyTo(ScrollPhysics? ancestor) {
    return this;
  }


  /// 临时把滑动速度调整快了 @lizichen
  Simulation? _createBallisticSimulation(
      ScrollMetrics position, double velocity) {
    final Tolerance tolerance = this.tolerance;
    if (velocity.abs() >= tolerance.velocity || position.outOfRange) {
      return BouncingScrollSimulation(
        spring: spring,
        position: position.pixels,
        velocity: velocity * 1,
        // We should move this constant closer to the drag end.
        leadingExtent: position.minScrollExtent,
        trailingExtent: position.maxScrollExtent,
        tolerance: tolerance,
      );
    }
    return null;
  }

  @override
  Simulation? createBallisticSimulation(
      ScrollMetrics position, double velocity) {
    final result = _createBallisticSimulation(position, velocity);
    if (result != null) scrollStatus.hasScroll = true;

    scrollStatus.hasInitial = true;
    return result;
  }
}

class CusClampingScrollPhysics extends ClampingScrollPhysics {
  final ScrollStatus scrollStatus;

  const CusClampingScrollPhysics(
    this.scrollStatus, {
    ScrollPhysics? parent
  }) : super(parent: parent);

  @override
  SpringDescription get spring {
    if (!hasInitial) {
      hasInitial = true;
      return super.spring;
    }
    if (!scrollStatus.hasInitial) {
      scrollStatus.hasInitial = true;
      return springDescription();
    }
    if (!hasPhysicsAdded(this)) {
      addHashcodeToSet(this);
      return springDescription();
    }
    if (!scrollStatus.hasScroll) return super.spring;
    if (scrollStatus.isJumpEnd) return super.spring;
    return springDescription();
  }


  @override
  ClampingScrollPhysics applyTo(ScrollPhysics? ancestor) {
    return this;
  }

  @override
  Simulation? createBallisticSimulation(
      ScrollMetrics position, double velocity) {
    final result = super.createBallisticSimulation(position, velocity);
    if (result != null) scrollStatus.hasScroll = true;
    scrollStatus.hasInitial = true;
    return result;
  }
}

class ScrollStatus {
  bool isJumpEnd = false;
  bool hasScroll = false;
  bool hasInitial = false;
}

SpringDescription springDescription() => SpringDescription.withDampingRatio(mass: 0.01, stiffness: 1000);


final Set<int> _hashcodeSet = {};

bool hasPhysicsAdded(ScrollPhysics physics) => _hashcodeSet.contains(physics.hashCode);

void addHashcodeToSet(ScrollPhysics physics) => _hashcodeSet.add(physics.hashCode);

bool hasInitial = false;
