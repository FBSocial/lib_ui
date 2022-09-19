// ignore_for_file: unnecessary_null_comparison

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';

class IndexListView extends BoxScrollView {
  final SliverChildBuilderDelegate childrenDelegate;
  final IndexController? indexController;
  final int? initialIndex;
  final IndexListener? indexListener;
  final InitialAlignment initialAlignment;
  final EdgeInsetsGeometry? indexPadding;

  IndexListView.builder({
    Key? key,
    Axis scrollDirection = Axis.vertical,
    bool reverse = false,
    required this.indexController,
    bool? primary,
    ScrollPhysics? physics,
    bool shrinkWrap = false,
    required this.childrenDelegate,
    double? cacheExtent,
    int? semanticChildCount,
    this.initialIndex = 0,
    this.indexPadding = EdgeInsets.zero,
    this.indexListener,
    this.initialAlignment = InitialAlignment.top,
  }) : super(
          key: key,
          scrollDirection: scrollDirection,
          reverse: reverse,
          controller: indexController ?? IndexController(),
          primary: primary,
          physics: physics,
          shrinkWrap: shrinkWrap,
          padding:
              indexController?.position._padding ?? const EdgeInsets.all(0),
          cacheExtent: cacheExtent,
          semanticChildCount: semanticChildCount,
        ) {
    indexController?._initialAlignment = initialAlignment;
    indexController?._initialIndex = initialIndex;
    indexController?._indexListener = indexListener;
    indexController?._initialPadding =
        indexPadding as EdgeInsets? ?? EdgeInsets.zero;
  }

  @override
  Widget buildChildLayout(BuildContext context) {
    return IndexSliverList(
      childDelegate: childrenDelegate,
      controller: indexController,
    );
  }

  @override
  Widget buildViewport(BuildContext context, ViewportOffset offset,
      AxisDirection axisDirection, List<Widget> slivers) {
    if (shrinkWrap) {
      return ShrinkWrappingViewport(
        axisDirection: axisDirection,
        offset: offset,
        slivers: slivers,
      );
    }
    return IndexViewPort(
      axisDirection: axisDirection,
      offset: offset,
      slivers: slivers,
      cacheExtent: cacheExtent,
      center: center,
      anchor: anchor,
      controller: indexController,
    );
  }
}

class IndexViewPort extends Viewport {
  final IndexController? controller;

  IndexViewPort({
    Key? key,
    AxisDirection axisDirection = AxisDirection.down,
    AxisDirection? crossAxisDirection,
    double anchor = 0.0,
    required ViewportOffset offset,
    Key? center,
    double? cacheExtent,
    CacheExtentStyle cacheExtentStyle = CacheExtentStyle.pixel,
    List<Widget> slivers = const <Widget>[],
    this.controller,
  }) : super(
          key: key,
          axisDirection: axisDirection,
          crossAxisDirection: crossAxisDirection,
          anchor: anchor,
          offset: offset,
          center: center,
          cacheExtent: cacheExtent,
          cacheExtentStyle: cacheExtentStyle,
          slivers: slivers,
        );

  @override
  RenderViewport createRenderObject(BuildContext context) {
    return IndexRenderViewport(
      axisDirection: axisDirection,
      crossAxisDirection: crossAxisDirection ??
          Viewport.getDefaultCrossAxisDirection(context, axisDirection),
      anchor: anchor,
      offset: offset,
      cacheExtent: cacheExtent,
      cacheExtentStyle: cacheExtentStyle,
      controller: controller,
    );
  }
}

class IndexRenderViewport extends RenderViewport {
  final IndexController? controller;

  IndexRenderViewport({
    AxisDirection axisDirection = AxisDirection.down,
    required AxisDirection crossAxisDirection,
    required ViewportOffset offset,
    double anchor = 0.0,
    List<RenderSliver>? children,
    RenderSliver? center,
    double? cacheExtent,
    CacheExtentStyle cacheExtentStyle = CacheExtentStyle.pixel,
    this.controller,
  }) : super(
          axisDirection: axisDirection,
          crossAxisDirection: crossAxisDirection,
          offset: offset,
          anchor: anchor,
          children: children,
          center: center,
          cacheExtent: cacheExtent,
          cacheExtentStyle: cacheExtentStyle,
        );

  @override
  void performLayout() {
    super.performLayout();
    if (controller?._initialAlignment == InitialAlignment.bottom) {
      final position = controller!.position;
      if (position == null) return;
      final constraints = firstChild!.constraints;
      final axisDirection = applyGrowthDirectionToAxisDirection(
          constraints.axisDirection, constraints.growthDirection);
      if (axisDirection == AxisDirection.down &&
          !position._hasAlign &&
          position.indexMap.isNotEmpty) {
        final last = position.indexMap.values.last;
        if (last == null) return;
        final paddingTop = last > position._viewportExtent
            ? 0
            : (position._viewportExtent - last);
        WidgetsBinding.instance!.addPostFrameCallback((timeStamp) {
          (firstChild as RenderSliverPadding).padding = EdgeInsets.only(
              top: paddingTop.toDouble() + controller!._initialPadding.top);
          controller?.position._padding = EdgeInsets.only(
              top: paddingTop.toDouble() + controller!._initialPadding.top);
        });
      }
      position._hasAlign = true;
    }
  }
}

class IndexSliverList extends SliverList {
  final IndexController? controller;
  final SliverChildDelegate childDelegate;

  const IndexSliverList({
    this.controller,
    Key? key,
    required this.childDelegate,
  }) : super(key: key, delegate: childDelegate);

  @override
  RenderSliverList createRenderObject(BuildContext context) {
    final SliverMultiBoxAdaptorElement element =
        context as SliverMultiBoxAdaptorElement;
    return IndexRenderSliverList(
        childManager: element,
        controller: controller,
        realChildCount:
            (childDelegate as SliverChildBuilderDelegate).childCount);
  }

  @override
  void updateRenderObject(BuildContext context, RenderObject renderObject) {
    (renderObject as IndexRenderSliverList).realChildCount =
        (childDelegate as SliverChildBuilderDelegate).childCount;
    super.updateRenderObject(context, renderObject);
  }
}

class IndexRenderSliverList extends RenderSliverList {
  final IndexController? controller;
  int? realChildCount;

  IndexRenderSliverList({
    required RenderSliverBoxChildManager childManager,
    this.controller,
    this.realChildCount,
  }) : super(childManager: childManager);

  @override
  void performLayout() {
    final SliverConstraints constraints = this.constraints;
    childManager.didStartLayout();
    childManager.setDidUnderflow(false);

    final double scrollOffset =
        constraints.scrollOffset + constraints.cacheOrigin;
    assert(scrollOffset >= 0.0);
    final double remainingExtent = constraints.remainingCacheExtent;
    assert(remainingExtent >= 0.0);
    double targetEndScrollOffset = scrollOffset + remainingExtent;
    final BoxConstraints childConstraints = constraints.asBoxConstraints();
    int leadingGarbage = 0;
    int trailingGarbage = 0;
    bool reachedEnd = false;

    // This algorithm in principle is straight-forward: find the first child
    // that overlaps the given scrollOffset, creating more children at the top
    // of the list if necessary, then walk down the list updating and laying out
    // each child and adding more at the end if necessary until we have enough
    // children to cover the entire viewport.
    //
    // It is complicated by one minor issue, which is that any time you update
    // or create a child, it's possible that the some of the children that
    // haven't yet been laid out will be removed, leaving the list in an
    // inconsistent state, and requiring that missing nodes be recreated.
    //
    // To keep this mess tractable, this algorithm starts from what is currently
    // the first child, if any, and then walks up and/or down from there, so
    // that the nodes that might get removed are always at the edges of what has
    // already been laid out.

    // Make sure we have at least one child to start from.
    if (firstChild == null) {
      if (!addInitialChild()) {
        // There are no children.
        geometry = SliverGeometry.zero;
        childManager.didFinishLayout();
        return;
      }
    }

    // We have at least one child.

    // These variables track the range of children that we have laid out. Within
    // this range, the children have consecutive indices. Outside this range,
    // it's possible for a child to get removed without notice.
    RenderBox? leadingChildWithLayout, trailingChildWithLayout;

    RenderBox? earliestUsefulChild = firstChild;

    // A firstChild with null layout offset is likely a result of children
    // reordering.
    //
    // We rely on firstChild to have accurate layout offset. In the case of null
    // layout offset, we have to find the first child that has valid layout
    // offset.
    if (childScrollOffset(firstChild!) == null) {
      int leadingChildrenWithoutLayoutOffset = 0;
      while (childScrollOffset(earliestUsefulChild!) == null) {
        earliestUsefulChild = childAfter(firstChild!);
        leadingChildrenWithoutLayoutOffset += 1;
      }
      // We should be able to destroy children with null layout offset safely,
      // because they are likely outside of viewport
      collectGarbage(leadingChildrenWithoutLayoutOffset, 0);
      assert(firstChild != null);
    }

    // Find the last child that is at or before the scrollOffset.
    earliestUsefulChild = firstChild;
    for (double earliestScrollOffset = childScrollOffset(earliestUsefulChild!)!;
        earliestScrollOffset > scrollOffset;
        earliestScrollOffset = childScrollOffset(earliestUsefulChild)!) {
      // We have to add children before the earliestUsefulChild.
      earliestUsefulChild =
          insertAndLayoutLeadingChild(childConstraints, parentUsesSize: true);

      if (earliestUsefulChild == null) {
        final SliverMultiBoxAdaptorParentData childParentData =
            firstChild!.parentData as SliverMultiBoxAdaptorParentData;
        childParentData.layoutOffset = 0.0;

        if (scrollOffset == 0.0) {
          // insertAndLayoutLeadingChild only lays out the children before
          // firstChild. In this case, nothing has been laid out. We have
          // to lay out firstChild manually.
          firstChild!.layout(childConstraints, parentUsesSize: true);
          earliestUsefulChild = firstChild;
          leadingChildWithLayout = earliestUsefulChild;
          trailingChildWithLayout ??= earliestUsefulChild;
          break;
        } else {
          // We ran out of children before reaching the scroll offset.
          // We must inform our parent that this sliver cannot fulfill
          // its contract and that we need a scroll offset correction.
          geometry = SliverGeometry(
            scrollOffsetCorrection: -scrollOffset,
          );
          return;
        }
      }

      final double firstChildScrollOffset =
          earliestScrollOffset - paintExtentOf(firstChild!);
      // firstChildScrollOffset may contain double precision error
      if (firstChildScrollOffset < -precisionErrorTolerance) {
        // The first child doesn't fit within the viewport (underflow) and
        // there may be additional children above it. Find the real first child
        // and then correct the scroll position so that there's room for all and
        // so that the trailing edge of the original firstChild appears where it
        // was before the scroll offset correction.
        // i.e. find a way to avoid visiting ALL of the children whose offset
        // is < 0 before returning for the scroll correction.
        double correction = 0;
        while (earliestUsefulChild != null) {
          assert(firstChild == earliestUsefulChild);
          correction += paintExtentOf(firstChild!);
          earliestUsefulChild = insertAndLayoutLeadingChild(childConstraints,
              parentUsesSize: true);
        }
        earliestUsefulChild = firstChild;
        if ((correction - earliestScrollOffset).abs() >
            precisionErrorTolerance) {
          geometry = SliverGeometry(
            scrollOffsetCorrection: correction - earliestScrollOffset,
          );
          final SliverMultiBoxAdaptorParentData childParentData =
              firstChild!.parentData as SliverMultiBoxAdaptorParentData;
          childParentData.layoutOffset = 0.0;
          return;
        }
      }

      final SliverMultiBoxAdaptorParentData childParentData =
          earliestUsefulChild!.parentData as SliverMultiBoxAdaptorParentData;
      childParentData.layoutOffset = firstChildScrollOffset;
      assert(earliestUsefulChild == firstChild);
      leadingChildWithLayout = earliestUsefulChild;
      trailingChildWithLayout ??= earliestUsefulChild;
    }

    // At this point, earliestUsefulChild is the first child, and is a child
    // whose scrollOffset is at or before the scrollOffset, and
    // leadingChildWithLayout and trailingChildWithLayout are either null or
    // cover a range of render boxes that we have laid out with the first being
    // the same as earliestUsefulChild and the last being either at or after the
    // scroll offset.

    assert(earliestUsefulChild == firstChild);
    assert(childScrollOffset(earliestUsefulChild!)! <= scrollOffset);

    // Make sure we've laid out at least one child.
    if (leadingChildWithLayout == null) {
      earliestUsefulChild!.layout(childConstraints, parentUsesSize: true);
      leadingChildWithLayout = earliestUsefulChild;
      trailingChildWithLayout = earliestUsefulChild;
    }

    // Here, earliestUsefulChild is still the first child, it's got a
    // scrollOffset that is at or before our actual scrollOffset, and it has
    // been laid out, and is in fact our leadingChildWithLayout. It's possible
    // that some children beyond that one have also been laid out.
    final position = controller!.position;
    bool hasInitial = false;
    bool isReCalculate = false;
    bool needUpdateIndex = false;
    position._viewportExtent = constraints.viewportMainAxisExtent;
    hasInitial = position._hasInitial;
    isReCalculate = hasInitial && realChildCount != position.indexMap.length;
    needUpdateIndex = isReCalculate ||
        (!hasInitial &&
            position.initialIndex != null &&
            position.initialIndex! > 0);

    bool inLayoutRange = true;
    RenderBox child = earliestUsefulChild!;
    int index = indexOf(child);
    double endScrollOffset = childScrollOffset(child)! + paintExtentOf(child);
    saveIndexOffset(index, endScrollOffset);
    bool advance() {
      // returns true if we advanced, false if we have no more children
      // This function is used in two different places below, to avoid code duplication.
      if (child == trailingChildWithLayout) inLayoutRange = false;
      child = childAfter(child)!;
      if (child == null) inLayoutRange = false;
      index += 1;
      if (!inLayoutRange) {
        if (indexOf(child) != index) {
          // We are missing a child. Insert it (and lay it out) if possible.
          child = insertAndLayoutChild(
            childConstraints,
            after: trailingChildWithLayout,
            parentUsesSize: true,
          )!;
          if (child == null) {
            // We have run out of children.
            return false;
          }
        } else {
          // Lay out the child.
          child.layout(childConstraints, parentUsesSize: true);
        }
        trailingChildWithLayout = child;
      }
      final SliverMultiBoxAdaptorParentData childParentData =
          child.parentData as SliverMultiBoxAdaptorParentData;
      childParentData.layoutOffset = endScrollOffset;
      assert(childParentData.index == index);
      endScrollOffset = childScrollOffset(child)! + paintExtentOf(child);
//      final trailingPixel = curPixel + constraints.remainingPaintExtent;
//      if(!getRelayoutTrailingGarbage && endScrollOffset > trailingPixel && isReCalculate){
//        reLayoutTrailingGarbage = realChildCount - index;
//        getRelayoutTrailingGarbage = true;
//      }
//      if(isReCalculate && endScrollOffset < curPixel) reLayoutLeadingGarbage = index;
      saveIndexOffset(index, endScrollOffset);
      return true;
    }

    if (needUpdateIndex) {
      final initialTarget = position.initialIndex! > realChildCount! - 1
          ? realChildCount! - 1
          : position.initialIndex;
      final realTarget = hasInitial ? realChildCount! - 1 : initialTarget!;
      while (index < realTarget) {
        leadingGarbage += 1;
        if (!advance()) {
          assert(leadingGarbage == childCount);
          assert(child == null);
          // we want to make sure we keep the last child around so we know the end scroll offset
          collectGarbage(leadingGarbage - 1, 0);
          assert(firstChild == lastChild);
          final double extent =
              childScrollOffset(lastChild!)! + paintExtentOf(lastChild!);
          geometry = SliverGeometry(
              scrollExtent: extent,
              maxPaintExtent: extent,
              scrollOffsetCorrection: endScrollOffset);
          return;
        }
      }
      if (!hasInitial && position.initialIndex! > 0) {
        final curIndex = realTarget > 1 ? realTarget - 1 : realTarget;
        final curOff = position.indexMap[curIndex]!;
        final finalOff = endScrollOffset > curOff ? curOff : endScrollOffset;
        position.correctPixels(finalOff);
      }
      targetEndScrollOffset += endScrollOffset;
    } else {
      // Find the first child that ends after the scroll offset.
      while (endScrollOffset < scrollOffset) {
        leadingGarbage += 1;
        if (!advance()) {
          assert(leadingGarbage == childCount);
          // we want to make sure we keep the last child around so we know the end scroll offset
          collectGarbage(leadingGarbage - 1, 0);
          assert(firstChild == lastChild);
          final double extent =
              childScrollOffset(lastChild!)! + paintExtentOf(lastChild!);
          geometry = SliverGeometry(
            scrollExtent: extent,
            maxPaintExtent: extent,
          );
          return;
        }
      }
    }
    controller!.position._hasInitial = true;
    // Now find the first child that ends after our end.
    while (endScrollOffset < targetEndScrollOffset) {
      if (!advance()) {
        reachedEnd = true;
        break;
      }
    }

    // Finally count up all the remaining children and label them as garbage.
    child = childAfter(child)!;
    while (child != null) {
      trailingGarbage += 1;
      child = childAfter(child)!;
    }

    // At this point everything should be good to go, we just have to clean up
    // the garbage and report the geometry.

    if (endScrollOffset > this.constraints.remainingCacheExtent &&
        !isReCalculate) {
      collectGarbage(leadingGarbage, trailingGarbage);
    }

    assert(debugAssertChildListIsNonEmptyAndContiguous());
    double estimatedMaxScrollOffset;
    if (reachedEnd) {
      estimatedMaxScrollOffset = endScrollOffset;
    } else {
      estimatedMaxScrollOffset = childManager.estimateMaxScrollOffset(
        constraints,
        firstIndex: indexOf(firstChild!),
        lastIndex: indexOf(lastChild!),
        leadingScrollOffset: childScrollOffset(firstChild!),
        trailingScrollOffset: endScrollOffset,
      );
      assert(estimatedMaxScrollOffset >=
          endScrollOffset - childScrollOffset(firstChild!)!);
    }
    final double paintExtent = calculatePaintOffset(
      constraints,
      from: childScrollOffset(firstChild!)!,
      to: endScrollOffset,
    );
    final double cacheExtent = calculateCacheOffset(
      constraints,
      from: childScrollOffset(firstChild!)!,
      to: endScrollOffset,
    );
    final double targetEndScrollOffsetForPaint =
        constraints.scrollOffset + constraints.remainingPaintExtent;
    geometry = SliverGeometry(
      scrollExtent: estimatedMaxScrollOffset,
      paintExtent: paintExtent,
      cacheExtent: cacheExtent,
      maxPaintExtent: estimatedMaxScrollOffset,
      // Conservative to avoid flickering away the clip during scroll.
      hasVisualOverflow: endScrollOffset > targetEndScrollOffsetForPaint ||
          constraints.scrollOffset > 0.0,
    );
    // We may have started the layout while scrolled to the end, which would not
    // expose a new child.

    final firstIndex = indexOf(firstChild!);
    final lastIndex = indexOf(lastChild!);
    if (hasInitial) {
      controller!._calculateIndex(
          firstIndex, lastIndex, constraints.viewportMainAxisExtent);
    }
    if (position._isToEnd) {
      if (position.pixels + constraints.viewportMainAxisExtent <
          endScrollOffset) {
        position.correctPixels(
            endScrollOffset - constraints.viewportMainAxisExtent);
        position._isToEnd = false;
      }
    }
    if (estimatedMaxScrollOffset == endScrollOffset) {
      childManager.setDidUnderflow(true);
    }
    childManager.didFinishLayout();
  }

  void saveIndexOffset(int index, double endScrollOffset) {
    if (!controller!.hasClients) return;
    controller!.position._indexMap[index] = endScrollOffset;
    if (index >= realChildCount! - 1) {
      controller!.position._maxPixels = endScrollOffset;
    }
  }

  @override
  void layout(Constraints constraints, {bool parentUsesSize = false}) {
    super.layout(constraints, parentUsesSize: parentUsesSize);
    final sliverConstrains = constraints as SliverConstraints;
    final position = controller!.position;
    if (position == null) return;
    if (!position._hasReLayout && position.initialIndex! > 0) {
      final pixels = position.getEndPixel();
      final viewportExtent = sliverConstrains.viewportMainAxisExtent;
      final maxScrollExtend = geometry!.scrollExtent;
      position._hasReLayout = true;
      double finalPixel =
          _calculatePixel(maxScrollExtend, viewportExtent, position, pixels);
      if (!position._hasAlign &&
          controller!._initialAlignment == InitialAlignment.bottom &&
          maxScrollExtend < viewportExtent) finalPixel = 0;
      super.layout(sliverConstrains.copyWith(scrollOffset: finalPixel),
          parentUsesSize: parentUsesSize);
    }
  }

  double _calculatePixel(double maxScrollExtend, double viewportExtent,
      IndexScrollPosition position, double pixels) {
    final correctPixels = maxScrollExtend - viewportExtent;
    final outScreen = maxScrollExtend > viewportExtent;
    final indexOver = position.initialIndex! >= position._indexMap.length;
    final curIndexPixels = indexOver
        ? pixels
        : position._indexMap[
            position.initialIndex! > 1 ? position.initialIndex! - 1 : 0]!;
    final pixelOver = curIndexPixels > correctPixels;
    final realPixels = pixelOver ? correctPixels : curIndexPixels;
    final double finalPixel = outScreen ? realPixels : 0.0;
    position.correctPixels(finalPixel);
    return finalPixel;
  }
}

class IndexController extends ScrollController {
  int? _initialIndex = 0;
  EdgeInsets _initialPadding = EdgeInsets.zero;
  IndexListener? _indexListener;
  InitialAlignment _initialAlignment = InitialAlignment.top;

  IndexController({
    double initialScrollOffset = 0.0,
    bool keepScrollOffset = true,
    String? debugLabel,
  }) : super(
            initialScrollOffset: initialScrollOffset,
            keepScrollOffset: keepScrollOffset,
            debugLabel: debugLabel);

  @override
  ScrollPosition createScrollPosition(ScrollPhysics physics,
      ScrollContext context, ScrollPosition? oldPosition) {
    return IndexScrollPosition(
      physics: physics,
      context: context,
      initialPixels: initialScrollOffset,
      keepScrollOffset: keepScrollOffset,
      initialIndex: _initialIndex,
      oldPosition: oldPosition,
      debugLabel: debugLabel,
    );
  }

  @override
  IndexScrollPosition get position => super.position as IndexScrollPosition;

  void jumpToIndex(int index) {
    position.jumpToIndex(index);
  }

  Future animationToIndex(
    int index, {
    required Duration duration,
    Curve curve = Curves.linear,
  }) async {
    await position.animationToIndex(index, duration: duration, curve: curve);
  }

  void _calculateIndex(int first, int last, double screenOff) {
    if (_indexListener == null) return;
    final startOff = position.pixels - position._padding.top;
    final endOff = startOff + screenOff;
    final indexMap = position.indexMap;

    final indexMapLength = indexMap.length;
    if (last >= indexMapLength - 1) last = indexMapLength - 1;
    double lastOff = indexMap[last] ?? 0.0;
    while (lastOff > endOff && first <= last) {
      final nextLast = last - 1;
      lastOff = indexMap[nextLast] ?? 0.0;
      if (lastOff > endOff) last = nextLast;
    }
    double firstOff = indexMap[first] ?? 0.0;
    while (firstOff < startOff && first < last) {
      first++;
      firstOff = indexMap[first]!;
    }
    WidgetsBinding.instance!.addPostFrameCallback((timeStamp) {
      _indexListener!.call(first, last);
    });
  }
}

class IndexScrollPosition extends ScrollPositionWithSingleContext {
  final int? initialIndex;
  bool _hasReLayout = false;
  bool _hasInitial = false;
  bool _hasAlign = false;
  double _viewportExtent = 0;
  double _maxPixels = 0;
  bool _isToEnd = false;
  EdgeInsets _padding = const EdgeInsets.all(0);
  final Map<int, double> _indexMap = {};

  IndexScrollPosition({
    required ScrollPhysics physics,
    required ScrollContext context,
    double initialPixels = 0.0,
    this.initialIndex = 0,
    bool keepScrollOffset = true,
    ScrollPosition? oldPosition,
    String? debugLabel,
  }) : super(
          physics: physics,
          context: context,
          keepScrollOffset: keepScrollOffset,
          oldPosition: oldPosition,
          initialPixels: initialPixels,
          debugLabel: debugLabel,
        );

  void jumpToIndex(int index) {
    if (index < 0) {
      jumpTo(0);
      return;
    }
    if (index >= indexMap.length - 1 && !_isToEnd) _isToEnd = true;
    final double finalPixel = _calculateJumpOff(index);
    jumpTo(finalPixel);
  }

  double _calculateJumpOff(int index) {
    final lastPixel = _maxPixels + _padding.top;
    final correctPixels = lastPixel - _viewportExtent;
    final outScreen = lastPixel > _viewportExtent;
    final indexOver = index >= _indexMap.length;
    final curIndexPixels = indexOver ? lastPixel : _indexMap[index]!;
    final pixelOver = curIndexPixels > correctPixels;
    final realPixels = pixelOver ? correctPixels : curIndexPixels;
    final double finalPixel = outScreen ? realPixels : 0.0;
    return finalPixel;
  }

  Future animationToIndex(
    int index, {
    required Duration duration,
    Curve curve = Curves.linear,
  }) async {
    if (index < 0) {
      await animateTo(0, duration: duration, curve: curve);
      return;
    }
    final double finalPixel = _calculateJumpOff(index);
    await animateTo(finalPixel, duration: duration, curve: curve);
  }

  double getEndPixel() {
    return maxScrollExtent;
  }

  Map<int, double> get indexMap => _indexMap;
}

typedef IndexListener = Function(int firstIndex, int lastIndex);

enum InitialAlignment {
  top,
  bottom,
}
