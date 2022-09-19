import 'dart:math';
import 'dart:ui' as ui;

import 'package:flutter/material.dart';

enum TooltipDirection {
  top,
  topLeft,
  topRight,
  bottom,
  bottomLeft,
  bottomRight,
  left,
  leftTop,
  leftBottom,
  right,
  rightTop,
  rightBottom,
  // 弹出位置跟随鼠标位置，需传入globalPoint参数
  followMouse,
  // 上下自动布局，默认在上方
  auto,
}
enum ShowCloseButton { inside, outside, none }
enum ClipAreaShape { oval, rectangle }

typedef OutSideTapHandler = void Function();

////////////////////////////////////////////////////////////////////////////////////////////////////
/// Super flexible Tooltip class that allows you to show any content
/// inside a Tooltip in the overlay of the screen.
///
class SuperTooltip {
  /// Allows to accedd the closebutton for UI Testing
  static Key closeButtonKey = const Key("CloseButtonKey");

  /// Signals if the Tooltip is visible at the moment
  bool isOpen = false;

  final Offset? globalPoint;

  ///
  /// The content of the Tooltip
  final Widget content;

  ///
  /// The direcion in which the tooltip should open
  TooltipDirection popupDirection;

  ///
  /// optional handler that gets called when the Tooltip is closed
  final OutSideTapHandler? onClose;

  ///
  /// [minWidth], [minHeight], [maxWidth], [maxHeight] optional size constraints.
  /// If a constraint is not set the size will ajust to the content
  double? minWidth, minHeight, maxWidth, maxHeight;

  ///
  /// The minium padding from the Tooltip to the screen limits
  final double minimumOutSidePadding;

  ///
  /// If [snapsFarAwayVertically== true] the bigger free space above or below the target will be
  /// covered completely by the ToolTip. All other dimension or position constraints get overwritten
  final bool snapsFarAwayVertically;

  ///
  /// If [snapsFarAwayHorizontally== true] the bigger free space left or right of the target will be
  /// covered completely by the ToolTip. All other dimension or position constraints get overwritten
  final bool snapsFarAwayHorizontally;

  /// [top], [right], [bottom], [left] position the Tooltip absolute relative to the whole screen
  double? top, right, bottom, left, offsetX, offsetY;

  ///
  /// A Tooltip can have none, an inside or an outside close icon
  final ShowCloseButton showCloseButton;

  ///
  /// [hasShadow] defines if the tooltip should have a shadow
  final bool hasShadow;

  ///
  /// The shadow color.
  final Color shadowColor;

  ///
  /// The shadow blur radius.
  final double shadowBlurRadius;

  ///
  /// The shadow spread radius.
  final double shadowSpreadRadius;

  ///
  /// the stroke width of the border
  final double borderWidth;

  ///
  /// The corder radii of the border
  final double borderRadius;

  ///
  /// The color of the border
  final Color borderColor;

  ///
  /// The color of the close icon
  final Color closeButtonColor;

  ///
  /// The size of the close button
  final double closeButtonSize;

  ///
  /// The length of the Arrow
  final double arrowLength;

  ///
  /// The width of the arrow at its base
  final double arrowBaseWidth;

  ///
  /// The distance of the tip of the arrow's tip to the center of the target
  final double arrowTipDistance;

  ///
  /// The backgroundcolor of the Tooltip
  final Color backgroundColor;

  /// The color of the rest of the overlay surrounding the Tooltip.
  /// typically a translucent color.
  final Color outsideBackgroundColor;

  ///
  /// By default touching the surrounding of the Tooltip closes the tooltip.
  /// you can define a rectangle area where the background is completely transparent
  /// and the widgets below react to touch
  final Rect? touchThrougArea;

  ///
  /// The shape of the [touchThrougArea].
  final ClipAreaShape touchThroughAreaShape;

  ///
  /// If [touchThroughAreaShape] is [ClipAreaShape.rectangle] you can define a border radius
  final double touchThroughAreaCornerRadius;

  ///
  /// Let's you pass a key to the Tooltips cotainer for UI Testing
  final Key? tooltipContainerKey;

  ///
  /// Allow the tooltip to be dismissed tapping outside
  final bool dismissOnTapOutside;

  ///
  /// Enable background overlay
  final bool containsBackgroundOverlay;
  // 在direction为auto时生效，优先取向上
  final bool preferenceTop;
  Offset? _targetCenter;
  OverlayEntry? _backGroundOverlay;
  OverlayEntry? _ballonOverlay;

  SuperTooltip({
    this.tooltipContainerKey,
    required this.content, // The contents of the tooltip.
    required this.popupDirection,
    this.onClose,
    this.globalPoint,
    this.minWidth,
    this.minHeight,
    this.maxWidth,
    this.maxHeight,
    this.offsetX = 0,
    this.offsetY = 0,
    this.minimumOutSidePadding = 10.0,
    this.showCloseButton = ShowCloseButton.none,
    this.snapsFarAwayVertically = false,
    this.snapsFarAwayHorizontally = false,
    this.hasShadow = true,
    this.shadowColor = Colors.black54,
    this.shadowBlurRadius = 10.0,
    this.shadowSpreadRadius = 5.0,
    this.borderWidth = 2.0,
    this.borderRadius = 10.0,
    this.borderColor = Colors.black,
    this.closeButtonColor = Colors.black,
    this.closeButtonSize = 30.0,
    this.arrowLength = 20.0,
    this.arrowBaseWidth = 20.0,
    this.arrowTipDistance = 2.0,
    this.backgroundColor = Colors.white,
    this.outsideBackgroundColor = const Color.fromARGB(50, 255, 255, 255),
    this.touchThroughAreaShape = ClipAreaShape.oval,
    this.touchThroughAreaCornerRadius = 5.0,
    this.touchThrougArea,
    this.dismissOnTapOutside = true,
    this.containsBackgroundOverlay = true,
    this.preferenceTop = true,
  })  : assert((maxWidth ?? double.infinity) >= (minWidth ?? 0.0)),
        assert((maxHeight ?? double.infinity) >= (minHeight ?? 0.0)),
        assert(!(popupDirection == TooltipDirection.followMouse &&
            globalPoint == null));

  ///
  /// Removes the Tooltip from the overlay
  void close() {
    if (onClose != null) {
      onClose!();
    }

    _ballonOverlay!.remove();
    _backGroundOverlay?.remove();
    isOpen = false;
  }

  ///
  /// Displays the tooltip
  /// The center of [targetContext] is used as target of the arrow
  void show(BuildContext targetContext) {
    final renderBox = targetContext.findRenderObject() as RenderBox;
    // final localPoint = renderBox.globalToLocal(globalPoint);
    final overlay =
        Overlay.of(targetContext)!.context.findRenderObject() as RenderBox?;

    _targetCenter = renderBox.localToGlobal(renderBox.size.center(Offset.zero),
        ancestor: overlay);

    // Create the background below the popup including the clipArea.
    if (containsBackgroundOverlay) {
      _backGroundOverlay = OverlayEntry(
          builder: (context) => _AnimationWrapper(
                builder: (context, opacity) => AnimatedOpacity(
                  opacity: opacity,
                  duration: const Duration(milliseconds: 600),
                  child: GestureDetector(
                    onTap: () {
                      if (dismissOnTapOutside) {
                        close();
                      }
                    },
                    child: Container(
                        decoration: ShapeDecoration(
                            shape: _ShapeOverlay(
                                touchThrougArea,
                                touchThroughAreaShape,
                                touchThroughAreaCornerRadius,
                                outsideBackgroundColor))),
                  ),
                ),
              ));
    }

    /// Handling snap far away feature.
    // if (snapsFarAwayVertically) {
    //   maxHeight = null;
    //   left = 0.0;
    //   right = 0.0;
    //   if (_targetCenter.dy > overlay.size.center(Offset.zero).dy) {
    //     popupDirection = TooltipDirection.top;
    //     top = 0.0;
    //   } else {
    //     popupDirection = TooltipDirection.bottom;
    //     bottom = 0.0;
    //   }
    // } // Only one of of them is possible, and vertical has higher priority.
    // else if (snapsFarAwayHorizontally) {
    //   maxWidth = null;
    //   top = 0.0;
    //   bottom = 0.0;
    //   if (_targetCenter.dx < overlay.size.center(Offset.zero).dx) {
    //     popupDirection = TooltipDirection.right;
    //     right = 0.0;
    //   } else {
    //     popupDirection = TooltipDirection.left;
    //     left = 0.0;
    //   }
    // }

    _ballonOverlay = OverlayEntry(
        builder: (context) => _AnimationWrapper(
              builder: (context, opacity) => AnimatedOpacity(
                duration: const Duration(
                  milliseconds: 300,
                ),
                opacity: opacity,
                child: Center(
                    child: CustomSingleChildLayout(
                        delegate: _PopupBallonLayoutDelegate(
                            popupDirection: popupDirection,
                            targetCenter: _targetCenter,
                            outSidePadding: minimumOutSidePadding,
                            offsetX: offsetX,
                            offsetY: offsetY,
                            contextSize: renderBox.size,
                            localPoint: globalPoint,
                            maxWidth: maxWidth,
                            maxHeight: maxHeight,
                            preferenceTop: preferenceTop),
                        child: Stack(
                          fit: StackFit.passthrough,
                          children: [_buildPopUp()],
                        ))),
              ),
            ));

    final overlays = <OverlayEntry?>[];

    if (containsBackgroundOverlay) {
      overlays.add(_backGroundOverlay);
    }
    overlays.add(_ballonOverlay);

    Overlay.of(targetContext)!.insertAll(overlays as Iterable<OverlayEntry>);
    isOpen = true;
  }

  Widget _buildPopUp() {
    return Positioned(
      child: Container(
        key: tooltipContainerKey,
        decoration: ShapeDecoration(
            color: backgroundColor,
            shadows: hasShadow
                ? [
                    BoxShadow(
                        color: shadowColor,
                        blurRadius: shadowBlurRadius,
                        spreadRadius: shadowSpreadRadius)
                  ]
                : null,
            shape: _BubbleShape(
                popupDirection,
                _targetCenter,
                borderRadius,
                arrowBaseWidth,
                arrowTipDistance,
                borderColor,
                borderWidth,
                left,
                top,
                right,
                bottom)),
        // margin: _getBallonContainerMargin(),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(borderRadius),
          child: content,
        ),
      ),
    );
  }

  // EdgeInsets _getBallonContainerMargin() {
  //   final top = (showCloseButton == ShowCloseButton.outside)
  //       ? closeButtonSize + 5
  //       : 0.0;
  //
  //   switch (popupDirection) {
  //     //
  //     case TooltipDirection.down:
  //       return EdgeInsets.only(
  //         top: arrowTipDistance + arrowLength,
  //       );
  //
  //     case TooltipDirection.up:
  //       return EdgeInsets.only(
  //           bottom: arrowTipDistance + arrowLength, top: top);
  //
  //     case TooltipDirection.left:
  //       return EdgeInsets.only(right: arrowTipDistance + arrowLength, top: top);
  //
  //     case TooltipDirection.right:
  //       return EdgeInsets.only(left: arrowTipDistance + arrowLength, top: top);
  //
  //     default:
  //       throw AssertionError(popupDirection);
  //   }
  // }
}

////////////////////////////////////////////////////////////////////////////////////////////////////

class _PopupBallonLayoutDelegate extends SingleChildLayoutDelegate {
  final TooltipDirection? _popupDirection;
  final Offset? _targetCenter;
  final double? _offsetX;
  final double? _outSidePadding;
  final double? _offsetY;
  final Size _contextSize;
  final Offset? _globalPoint;
  final double? _maxWidth;
  final double? _maxHeight;
  final bool _preferenceTop;
  _PopupBallonLayoutDelegate({
    TooltipDirection? popupDirection,
    Offset? targetCenter,
    double? outSidePadding,
    double? offsetX,
    double? offsetY,
    Size contextSize = Size.zero,
    Offset? localPoint = Offset.zero,
    double? maxWidth,
    double? maxHeight,
    bool preferenceTop = false,
  })  : _targetCenter = targetCenter,
        _popupDirection = popupDirection,
        _outSidePadding = outSidePadding,
        _offsetX = offsetX,
        _offsetY = offsetY,
        _contextSize = contextSize,
        _globalPoint = localPoint,
        _maxWidth = maxWidth,
        _maxHeight = maxHeight,
        _preferenceTop = preferenceTop;
  @override
  Offset getPositionForChild(Size size, Size childSize) {
    double safeTop(double topmostYtoTarget) {
      return max(topmostYtoTarget - _offsetY!, _outSidePadding!);
    }

    double safeBottom(double topmostYtoTarget) {
      if (topmostYtoTarget + childSize.height + _outSidePadding! + _offsetY! >
          size.height) {
        topmostYtoTarget = size.height - childSize.height - _outSidePadding!;
      }
      return topmostYtoTarget;
    }

    double safeRight(double topmostXtoTarget) {
      if (topmostXtoTarget + childSize.width + _outSidePadding! + _offsetX! >
          size.width) {
        topmostXtoTarget = size.width - childSize.width - _outSidePadding!;
      }
      return topmostXtoTarget;
    }

    double safeLeft(double topmostXtoTarget) {
      return max(topmostXtoTarget + _offsetX!, _outSidePadding!);
    }

    double calcLeftMostXtoTarget() {
      double leftMostXtoTarget;
      switch (_popupDirection) {
        case TooltipDirection.top:
        case TooltipDirection.auto:
        case TooltipDirection.bottom:
          leftMostXtoTarget = _targetCenter!.dx - childSize.width / 2 + _offsetX!;
          leftMostXtoTarget = safeRight(leftMostXtoTarget);
          leftMostXtoTarget = safeLeft(leftMostXtoTarget);

          break;
        case TooltipDirection.topLeft:
        case TooltipDirection.bottomLeft:
          leftMostXtoTarget =
              _targetCenter!.dx - _contextSize.width / 2 + _offsetX!;
          leftMostXtoTarget = safeRight(leftMostXtoTarget);
          leftMostXtoTarget = safeLeft(leftMostXtoTarget);
          break;
        case TooltipDirection.topRight:
        case TooltipDirection.bottomRight:
          leftMostXtoTarget = _targetCenter!.dx +
              _contextSize.width / 2 -
              childSize.width +
              _offsetX!;
          leftMostXtoTarget = safeRight(leftMostXtoTarget);
          leftMostXtoTarget = safeLeft(leftMostXtoTarget);
          break;

        case TooltipDirection.followMouse:
          leftMostXtoTarget = _globalPoint!.dx;
          if (_globalPoint!.dx + childSize.width + _offsetX! + _outSidePadding! >
              size.width) {
            leftMostXtoTarget = _globalPoint!.dx - childSize.width - _offsetX!;
            leftMostXtoTarget = safeLeft(leftMostXtoTarget);
          }
          break;
        default:
          throw AssertionError(_popupDirection);
      }
      return leftMostXtoTarget;
    }

    double calcTopMostYtoTarget() {
      double topmostYtoTarget = 0;
      switch (_popupDirection) {
        case TooltipDirection.left:
        case TooltipDirection.right:
          topmostYtoTarget = _targetCenter!.dy - childSize.height / 2 + _offsetY!;
          topmostYtoTarget = safeTop(topmostYtoTarget);
          topmostYtoTarget = safeBottom(topmostYtoTarget);

          break;
        case TooltipDirection.leftTop:
        case TooltipDirection.rightTop:
          topmostYtoTarget =
              _targetCenter!.dy - _contextSize.height / 2 + _offsetY!;
          topmostYtoTarget = safeTop(topmostYtoTarget);
          topmostYtoTarget = safeBottom(topmostYtoTarget);
          break;
        case TooltipDirection.leftBottom:
        case TooltipDirection.rightBottom:
          topmostYtoTarget = _targetCenter!.dy +
              _contextSize.height / 2 -
              childSize.height +
              _offsetY!;
          topmostYtoTarget = safeTop(topmostYtoTarget);
          topmostYtoTarget = safeBottom(topmostYtoTarget);
          break;
        case TooltipDirection.followMouse:
          topmostYtoTarget = _globalPoint!.dy;
          topmostYtoTarget = safeBottom(topmostYtoTarget);

          break;
        default:
          throw AssertionError(_popupDirection);
      }
      return topmostYtoTarget;
    }

    Offset offset = Offset.zero;
    switch (_popupDirection) {
      case TooltipDirection.bottom:
      case TooltipDirection.bottomLeft:
      case TooltipDirection.bottomRight:
        offset = Offset(calcLeftMostXtoTarget(),
            _targetCenter!.dy + _contextSize.height / 2 + _offsetY!);
        break;
      case TooltipDirection.top:
      case TooltipDirection.topLeft:
      case TooltipDirection.topRight:
        offset = Offset(
            calcLeftMostXtoTarget(),
            _targetCenter!.dy -
                childSize.height -
                _contextSize.height / 2 +
                _offsetY!);
        break;
      case TooltipDirection.left:
      case TooltipDirection.leftTop:
      case TooltipDirection.leftBottom:
        final left =
            _targetCenter!.dx - childSize.width - _contextSize.width / 2;
        offset = Offset(left + _offsetX!, calcTopMostYtoTarget());
        break;
      case TooltipDirection.right:
      case TooltipDirection.rightTop:
      case TooltipDirection.rightBottom:
        offset = Offset(
          _targetCenter!.dx + _contextSize.width / 2 + _offsetX!,
          calcTopMostYtoTarget(),
        );
        break;
      case TooltipDirection.followMouse:
        offset = Offset(
          calcLeftMostXtoTarget(),
          calcTopMostYtoTarget(),
        );
        break;
      case TooltipDirection.auto:
        double y = 0;
        if (_preferenceTop) {
          y = _targetCenter!.dy -
              childSize.height -
              _offsetY! -
              _contextSize.height / 2;
          if (y < _outSidePadding!) {
            y = _targetCenter!.dy + _contextSize.height / 2 + _offsetY!;
            y = safeBottom(y);
          }
        } else {
          y = _targetCenter!.dy + _contextSize.height / 2 + _offsetY!;
          if (y + childSize.height + _outSidePadding! + _offsetY! > size.height) {
            y = _targetCenter!.dy -
                childSize.height -
                _offsetY! -
                _contextSize.height / 2;
            y = safeTop(y);
          }
        }
        offset = Offset(
          calcLeftMostXtoTarget(),
          y,
        );
        break;
      default:
        throw AssertionError(_popupDirection);
    }
    return Offset(offset.dx.floor().toDouble(), offset.dy.floor().toDouble());
  }

  @override
  BoxConstraints getConstraintsForChild(BoxConstraints constraints) {
    // var calcMinWidth = _minWidth ?? 0.0;
    // var calcMaxWidth = _maxWidth ?? double.infinity;
    // var calcMinHeight = _minHeight ?? 0.0;
    // var calcMaxHeight = _maxHeight ?? double.infinity;
    //
    // void calcMinMaxWidth() {
    //   if (_left != null && _right != null) {
    //     calcMaxWidth = constraints.maxWidth - (_left + _right);
    //   } else if ((_left != null && _right == null) ||
    //       (_left == null && _right != null)) {
    //     // make sure that the sum of left, right + maxwidth isn't bigger than the screen width.
    //     final sideDelta = (_left ?? 0.0) + (_right ?? 0.0) + _outSidePadding;
    //     if (calcMaxWidth > constraints.maxWidth - sideDelta) {
    //       calcMaxWidth = constraints.maxWidth - sideDelta;
    //     }
    //   } else {
    //     if (calcMaxWidth > constraints.maxWidth - 2 * _outSidePadding) {
    //       calcMaxWidth = constraints.maxWidth - 2 * _outSidePadding;
    //     }
    //   }
    // }
    //
    // void calcMinMaxHeight() {
    //   if (_top != null && _bottom != null) {
    //     calcMaxHeight = constraints.maxHeight - (_top + _bottom);
    //   } else if ((_top != null && _bottom == null) ||
    //       (_top == null && _bottom != null)) {
    //     // make sure that the sum of top, bottom + maxHeight isn't bigger than the screen Height.
    //     final sideDelta = (_top ?? 0.0) + (_bottom ?? 0.0) + _outSidePadding;
    //     if (calcMaxHeight > constraints.maxHeight - sideDelta) {
    //       calcMaxHeight = constraints.maxHeight - sideDelta;
    //     }
    //   } else {
    //     if (calcMaxHeight > constraints.maxHeight - 2 * _outSidePadding) {
    //       calcMaxHeight = constraints.maxHeight - 2 * _outSidePadding;
    //     }
    //   }
    // }
    //
    // switch (_popupDirection) {
    //   //
    //   case TooltipDirection.bottom:
    //   case TooltipDirection.bottomLeft:
    //   case TooltipDirection.bottomRight:
    //     calcMinMaxWidth();
    //     if (_bottom != null) {
    //       calcMinHeight = calcMaxHeight =
    //           constraints.maxHeight - _bottom - _targetCenter.dy;
    //     } else {
    //       calcMaxHeight = min(_maxHeight ?? constraints.maxHeight,
    //               constraints.maxHeight - _targetCenter.dy) -
    //           _outSidePadding;
    //     }
    //     break;
    //
    //   case TooltipDirection.top:
    //   case TooltipDirection.topLeft:
    //   case TooltipDirection.topRight:
    //     calcMinMaxWidth();
    //
    //     if (_top != null) {
    //       calcMinHeight = calcMaxHeight = _targetCenter.dy - _top;
    //     } else {
    //       calcMaxHeight =
    //           min(_maxHeight ?? constraints.maxHeight, _targetCenter.dy) -
    //               _outSidePadding;
    //     }
    //     break;
    //
    //   case TooltipDirection.right:
    //   case TooltipDirection.rightTop:
    //   case TooltipDirection.rightBottom:
    //     calcMinMaxHeight();
    //     if (_right != null) {
    //       calcMinWidth =
    //           calcMaxWidth = constraints.maxWidth - _right - _targetCenter.dx;
    //     } else {
    //       calcMaxWidth = min(_maxWidth ?? constraints.maxWidth,
    //               constraints.maxWidth - _targetCenter.dx) -
    //           _outSidePadding;
    //     }
    //     break;
    //
    //   case TooltipDirection.left:
    //   case TooltipDirection.leftTop:
    //   case TooltipDirection.leftBottom:
    //     calcMinMaxHeight();
    //     if (_left != null) {
    //       calcMinWidth = calcMaxWidth = _targetCenter.dx - _left;
    //     } else {
    //       calcMaxWidth =
    //           min(_maxWidth ?? constraints.maxWidth, _targetCenter.dx) -
    //               _outSidePadding;
    //     }
    //     break;
    //
    //   default:
    //     logger.info('err $_popupDirection');
    //     throw AssertionError(_popupDirection);
    // }
    //
    // final childConstraints = BoxConstraints(
    //     minWidth: calcMinWidth > calcMaxWidth ? calcMaxWidth : calcMinWidth,
    //     maxWidth: calcMaxWidth,
    //     minHeight:
    //         calcMinHeight > calcMaxHeight ? calcMaxHeight : calcMinHeight,
    //     maxHeight: calcMaxHeight);

    // logger.info("Child constraints: $childConstraints");
    return BoxConstraints(
        maxHeight: _maxHeight ?? constraints.maxHeight,
        maxWidth: _maxWidth ?? constraints.maxWidth);
  }

  @override
  bool shouldRelayout(SingleChildLayoutDelegate oldDelegate) {
    return false;
  }
}

////////////////////////////////////////////////////////////////////////////////////////////////////

class _BubbleShape extends ShapeBorder {
  final Offset? targetCenter;
  final double arrowBaseWidth;
  final double arrowTipDistance;
  final double borderRadius;
  final Color borderColor;
  final double borderWidth;
  final double? left, top, right, bottom;
  final TooltipDirection popupDirection;

  const _BubbleShape(
      this.popupDirection,
      this.targetCenter,
      this.borderRadius,
      this.arrowBaseWidth,
      this.arrowTipDistance,
      this.borderColor,
      this.borderWidth,
      this.left,
      this.top,
      this.right,
      this.bottom);

  @override
  EdgeInsetsGeometry get dimensions => const EdgeInsets.all(0);

  @override
  Path getInnerPath(Rect rect, {TextDirection? textDirection}) {
    return Path()
      ..fillType = PathFillType.evenOdd
      ..addPath(getOuterPath(rect), Offset.zero);
  }

  @override
  Path getOuterPath(Rect rect, {TextDirection? textDirection}) {
    //
    late double topLeftRadius, topRightRadius, bottomLeftRadius, bottomRightRadius;

    Path _getLeftTopPath(Rect rect) {
      return Path()
        ..moveTo(rect.left, rect.bottom - bottomLeftRadius)
        ..lineTo(rect.left, rect.top + topLeftRadius)
        ..arcToPoint(Offset(rect.left + topLeftRadius, rect.top),
            radius: Radius.circular(topLeftRadius))
        ..lineTo(rect.right - topRightRadius, rect.top)
        ..arcToPoint(Offset(rect.right, rect.top + topRightRadius),
            radius: Radius.circular(topRightRadius));
    }

    Path _getBottomRightPath(Rect rect) {
      return Path()
        ..moveTo(rect.left + bottomLeftRadius, rect.bottom)
        ..lineTo(rect.right - bottomRightRadius, rect.bottom)
        ..arcToPoint(Offset(rect.right, rect.bottom - bottomRightRadius),
            radius: Radius.circular(bottomRightRadius), clockwise: false)
        ..lineTo(rect.right, rect.top + topRightRadius)
        ..arcToPoint(Offset(rect.right - topRightRadius, rect.top),
            radius: Radius.circular(topRightRadius), clockwise: false);
    }

    topLeftRadius = (left == 0 || top == 0) ? 0.0 : borderRadius;
    topRightRadius = (right == 0 || top == 0) ? 0.0 : borderRadius;
    bottomLeftRadius = (left == 0 || bottom == 0) ? 0.0 : borderRadius;
    bottomRightRadius = (right == 0 || bottom == 0) ? 0.0 : borderRadius;
    switch (popupDirection) {
      case TooltipDirection.bottom:
      case TooltipDirection.bottomLeft:
      case TooltipDirection.bottomRight:
        return _getBottomRightPath(rect)
          // ..lineTo(
          //     min(
          //         max(targetCenter.dx + arrowBaseWidth / 2,
          //             rect.left + borderRadius + arrowBaseWidth),
          //         rect.right - topRightRadius),
          //     rect.top)
          // ..lineTo(targetCenter.dx,
          //     targetCenter.dy + arrowTipDistance) // up to arrow tip   \
          // ..lineTo(
          //     max(
          //         min(targetCenter.dx - arrowBaseWidth / 2,
          //             rect.right - topLeftRadius - arrowBaseWidth),
          //         rect.left + topLeftRadius),
          //     rect.top) //  down /
          ..lineTo(rect.left + topLeftRadius, rect.top)
          ..arcToPoint(Offset(rect.left, rect.top + topLeftRadius),
              radius: Radius.circular(topLeftRadius), clockwise: false)
          ..lineTo(rect.left, rect.bottom - bottomLeftRadius)
          ..arcToPoint(Offset(rect.left + bottomLeftRadius, rect.bottom),
              radius: Radius.circular(bottomLeftRadius), clockwise: false);

      case TooltipDirection.top:
      case TooltipDirection.topLeft:
      case TooltipDirection.topRight:
        return _getLeftTopPath(rect)
          ..lineTo(rect.right, rect.bottom - bottomRightRadius)
          ..arcToPoint(Offset(rect.right - bottomRightRadius, rect.bottom),
              radius: Radius.circular(bottomRightRadius))
          ..lineTo(
              min(
                  max(targetCenter!.dx + arrowBaseWidth / 2,
                      rect.left + bottomLeftRadius + arrowBaseWidth),
                  rect.right - bottomRightRadius),
              rect.bottom)

          // up to arrow tip   \
          ..lineTo(targetCenter!.dx, targetCenter!.dy - arrowTipDistance)

          //  down /
          ..lineTo(
              max(
                  min(targetCenter!.dx - arrowBaseWidth / 2,
                      rect.right - bottomRightRadius - arrowBaseWidth),
                  rect.left + bottomLeftRadius),
              rect.bottom)
          ..lineTo(rect.left + bottomLeftRadius, rect.bottom)
          ..arcToPoint(Offset(rect.left, rect.bottom - bottomLeftRadius),
              radius: Radius.circular(bottomLeftRadius))
          ..lineTo(rect.left, rect.top + topLeftRadius)
          ..arcToPoint(Offset(rect.left + topLeftRadius, rect.top),
              radius: Radius.circular(topLeftRadius));

      case TooltipDirection.left:
      case TooltipDirection.leftTop:
      case TooltipDirection.leftBottom:
        return _getLeftTopPath(rect)
          // ..lineTo(
          //     rect.right,
          //     max(
          //         min(targetCenter.dy - arrowBaseWidth / 2,
          //             rect.bottom - bottomRightRadius - arrowBaseWidth),
          //         rect.top + topRightRadius))
          // ..lineTo(targetCenter.dx - arrowTipDistance,
          //     targetCenter.dy) // right to arrow tip   \
          //  left /
          // ..lineTo(
          //     rect.right,
          //     min(targetCenter.dy + arrowBaseWidth / 2,
          //         rect.bottom - bottomRightRadius))
          ..lineTo(rect.right, rect.bottom - borderRadius)
          ..arcToPoint(Offset(rect.right - bottomRightRadius, rect.bottom),
              radius: Radius.circular(bottomRightRadius))
          ..lineTo(rect.left + bottomLeftRadius, rect.bottom)
          ..arcToPoint(Offset(rect.left, rect.bottom - bottomLeftRadius),
              radius: Radius.circular(bottomLeftRadius));

      case TooltipDirection.right:
      case TooltipDirection.rightTop:
      case TooltipDirection.rightBottom:
      case TooltipDirection.followMouse:
      case TooltipDirection.auto:
        return _getBottomRightPath(rect)
          ..lineTo(rect.left + topLeftRadius, rect.top)
          ..arcToPoint(Offset(rect.left, rect.top + topLeftRadius),
              radius: Radius.circular(topLeftRadius), clockwise: false)
          // ..lineTo(
          //     rect.left,
          //     max(
          //         min(targetCenter.dy - arrowBaseWidth / 2,
          //             rect.bottom - bottomLeftRadius - arrowBaseWidth),
          //         rect.top + topLeftRadius))
          //
          // //left to arrow tip   /
          // ..lineTo(targetCenter.dx + arrowTipDistance, targetCenter.dy)
          //
          // //  right \
          // ..lineTo(
          //     rect.left,
          //     min(targetCenter.dy + arrowBaseWidth / 2,
          //         rect.bottom - bottomLeftRadius))
          ..lineTo(rect.left, rect.bottom - bottomLeftRadius)
          ..arcToPoint(Offset(rect.left + bottomLeftRadius, rect.bottom),
              radius: Radius.circular(bottomLeftRadius), clockwise: false);

      default:
        throw AssertionError(popupDirection);
    }
  }

  @override
  void paint(Canvas canvas, Rect rect, {TextDirection? textDirection}) {
    Paint paint = Paint()
      ..color = borderColor
      ..style = PaintingStyle.stroke
      ..strokeWidth = borderWidth;

    canvas.drawPath(getOuterPath(rect), paint);
    paint = Paint()
      ..color = Colors.white
      ..style = PaintingStyle.stroke
      ..strokeWidth = borderWidth;

    if (right == 0.0) {
      if (top == 0.0 && bottom == 0.0) {
        canvas.drawPath(
            Path()
              ..moveTo(rect.right, rect.top)
              ..lineTo(rect.right, rect.bottom),
            paint);
      } else {
        canvas.drawPath(
            Path()
              ..moveTo(rect.right, rect.top + borderWidth / 2)
              ..lineTo(rect.right, rect.bottom - borderWidth / 2),
            paint);
      }
    }
    if (left == 0.0) {
      if (top == 0.0 && bottom == 0.0) {
        canvas.drawPath(
            Path()
              ..moveTo(rect.left, rect.top)
              ..lineTo(rect.left, rect.bottom),
            paint);
      } else {
        canvas.drawPath(
            Path()
              ..moveTo(rect.left, rect.top + borderWidth / 2)
              ..lineTo(rect.left, rect.bottom - borderWidth / 2),
            paint);
      }
    }
    if (top == 0.0) {
      if (left == 0.0 && right == 0.0) {
        canvas.drawPath(
            Path()
              ..moveTo(rect.right, rect.top)
              ..lineTo(rect.left, rect.top),
            paint);
      } else {
        canvas.drawPath(
            Path()
              ..moveTo(rect.right - borderWidth / 2, rect.top)
              ..lineTo(rect.left + borderWidth / 2, rect.top),
            paint);
      }
    }
    if (bottom == 0.0) {
      if (left == 0.0 && right == 0.0) {
        canvas.drawPath(
            Path()
              ..moveTo(rect.right, rect.bottom)
              ..lineTo(rect.left, rect.bottom),
            paint);
      } else {
        canvas.drawPath(
            Path()
              ..moveTo(rect.right - borderWidth / 2, rect.bottom)
              ..lineTo(rect.left + borderWidth / 2, rect.bottom),
            paint);
      }
    }
  }

  @override
  ShapeBorder scale(double t) {
    return _BubbleShape(
        popupDirection,
        targetCenter,
        borderRadius,
        arrowBaseWidth,
        arrowTipDistance,
        borderColor,
        borderWidth,
        left,
        top,
        right,
        bottom);
  }
}

////////////////////////////////////////////////////////////////////////////////////////////////////

class _ShapeOverlay extends ShapeBorder {
  final Rect? clipRect;
  final Color outsideBackgroundColor;
  final ClipAreaShape clipAreaShape;
  final double clipAreaCornerRadius;

  const _ShapeOverlay(this.clipRect, this.clipAreaShape,
      this.clipAreaCornerRadius, this.outsideBackgroundColor);

  @override
  EdgeInsetsGeometry get dimensions => const EdgeInsets.all(10);

  @override
  Path getInnerPath(Rect rect, {TextDirection? textDirection}) {
    return Path()..addOval(clipRect!);
  }

  @override
  Path getOuterPath(Rect rect, {TextDirection? textDirection}) {
    final Path outer = Path()..addRect(rect);

    if (clipRect == null) {
      return outer;
    }
    Path exclusion;
    if (clipAreaShape == ClipAreaShape.oval) {
      exclusion = Path()..addOval(clipRect!);
    } else {
      exclusion = Path()
        ..moveTo(clipRect!.left + clipAreaCornerRadius, clipRect!.top)
        ..lineTo(clipRect!.right - clipAreaCornerRadius, clipRect!.top)
        ..arcToPoint(
            Offset(clipRect!.right, clipRect!.top + clipAreaCornerRadius),
            radius: Radius.circular(clipAreaCornerRadius))
        ..lineTo(clipRect!.right, clipRect!.bottom - clipAreaCornerRadius)
        ..arcToPoint(
            Offset(clipRect!.right - clipAreaCornerRadius, clipRect!.bottom),
            radius: Radius.circular(clipAreaCornerRadius))
        ..lineTo(clipRect!.left + clipAreaCornerRadius, clipRect!.bottom)
        ..arcToPoint(
            Offset(clipRect!.left, clipRect!.bottom - clipAreaCornerRadius),
            radius: Radius.circular(clipAreaCornerRadius))
        ..lineTo(clipRect!.left, clipRect!.top + clipAreaCornerRadius)
        ..arcToPoint(Offset(clipRect!.left + clipAreaCornerRadius, clipRect!.top),
            radius: Radius.circular(clipAreaCornerRadius))
        ..close();
    }

    return Path.combine(ui.PathOperation.difference, outer, exclusion);
  }

  @override
  void paint(Canvas canvas, Rect rect, {TextDirection? textDirection}) {
    canvas.drawPath(
        getOuterPath(rect), Paint()..color = outsideBackgroundColor);
  }

  @override
  ShapeBorder scale(double t) {
    return _ShapeOverlay(
        clipRect, clipAreaShape, clipAreaCornerRadius, outsideBackgroundColor);
  }
}

typedef FadeBuilder = Widget Function(BuildContext, double);

////////////////////////////////////////////////////////////////////////////////////////////////////

class _AnimationWrapper extends StatefulWidget {
  final FadeBuilder? builder;

  const _AnimationWrapper({this.builder});

  @override
  _AnimationWrapperState createState() => _AnimationWrapperState();
}

////////////////////////////////////////////////////////////////////////////////////////////////////

class _AnimationWrapperState extends State<_AnimationWrapper> {
  double opacity = 0;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance!.addPostFrameCallback((_) {
      if (mounted) {
        setState(() {
          opacity = 1.0;
        });
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return widget.builder!(context, opacity);
  }
}
