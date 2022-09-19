import 'dart:math';

import 'package:flutter/material.dart';
import 'package:lib_utils/config/config.dart';

import 'message_tooltip.dart';

class PopupBallonLayoutDelegate extends SingleChildLayoutDelegate {
  // TooltipDirection _popupDirection;
  final Offset? _targetCenter;

  // final double _minWidth;
  // final double _maxWidth;
  final double? _minHeight;

  // final double _maxHeight;
  // final double _top;
  // final double _bottom;
  final double? _left;
  final double? _right;
  final double? _outSidePadding;
  final BuildContext? _context;
  final Size? _renderBoxSize;
  TooltipDirection _popupDirection = TooltipDirection.up;

  TooltipDirection get popupDirection => _popupDirection;

  PopupBallonLayoutDelegate({
    Offset? targetCenter,
    // double minWidth,
    // double maxWidth,
    double? minHeight,
    // double maxHeight,
    double? outSidePadding,
    // double top,
    // double bottom,
    double? left,
    double? right,
    BuildContext? context,
    Size? renderBoxSize,
  })  : _targetCenter = targetCenter,
        // _popupDirection = popupDirection,
        // _minWidth = minWidth,
        // _maxWidth = maxWidth,
        _minHeight = minHeight,
        // _maxHeight = maxHeight,
        // _top = top,
        // _bottom = bottom,
        _left = left,
        _right = right,
        _outSidePadding = outSidePadding,
        _context = context,
        _renderBoxSize = renderBoxSize;

  @override
  Offset getPositionForChild(Size size, Size childSize) {
    double? calcLeftMostXtoTarget() {
      double? leftMostXtoTarget;
      if (_left != null) {
        leftMostXtoTarget = _left;
      } else if (_right != null) {
        leftMostXtoTarget = max(
            size.topLeft(Offset.zero).dx + _outSidePadding!,
            size.topRight(Offset.zero).dx -
                _outSidePadding! -
                childSize.width -
                _right!);
      } else {
        leftMostXtoTarget = max(
            _outSidePadding!,
            min(
                _targetCenter!.dx - childSize.width / 2,
                size.topRight(Offset.zero).dx -
                    _outSidePadding! -
                    childSize.width));
      }
      return leftMostXtoTarget;
    }

    // double calcTopMostYtoTarget() {
    //   double topmostYtoTarget;
    //   if (_top != null) {
    //     topmostYtoTarget = _top;
    //   } else if (_bottom != null) {
    //     topmostYtoTarget = max(
    //         size.topLeft(Offset.zero).dy + _outSidePadding,
    //         size.bottomRight(Offset.zero).dy -
    //             _outSidePadding -
    //             childSize.height -
    //             _bottom);
    //   } else {
    //     topmostYtoTarget = max(
    //         _outSidePadding,
    //         min(
    //             _targetCenter.dy - childSize.height / 2,
    //             size.bottomRight(Offset.zero).dy -
    //                 _outSidePadding -
    //                 childSize.height));
    //   }
    //   return topmostYtoTarget;
    // }

    // 优先在上面展示
    if (_targetCenter!.dy - (_minHeight ?? childSize.height) >
        MediaQuery.of(_context!).padding.top) {
      _popupDirection = TooltipDirection.up;
      return Offset(
          calcLeftMostXtoTarget()!, _targetCenter!.dy - childSize.height);
    }
    // 否则居中展示
    if (_targetCenter!.dy +
            _renderBoxSize!.height +
            (_minHeight ?? childSize.height) >=
        size.height) {
      _popupDirection = TooltipDirection.center;

      return Offset(
          calcLeftMostXtoTarget()!,
          MediaQuery.of(Config.navigatorKey.currentContext!).size.height / 2 -
              (_minHeight ?? childSize.height) / 2);
    }
    // 超过则在下面展示
    if (_targetCenter!.dy - (_minHeight ?? childSize.height) <=
        MediaQuery.of(_context!).padding.top) {
      _popupDirection = TooltipDirection.down;

      return Offset(
          calcLeftMostXtoTarget()!, _targetCenter!.dy + _renderBoxSize!.height);
    }
    return Offset(calcLeftMostXtoTarget()!,
        _targetCenter!.dy - (_minHeight ?? childSize.height));

    // switch (_popupDirection) {
    //   //
    //   case TooltipDirection.down:
    //     return new Offset(calcLeftMostXtoTarget(), _targetCenter.dy);

    //   case TooltipDirection.up:
    //     var top = _top ?? _targetCenter.dy - childSize.height;
    //     return new Offset(calcLeftMostXtoTarget(), top);

    //   case TooltipDirection.left:
    //     var left = _left ?? _targetCenter.dx - childSize.width;
    //     return new Offset(left, calcTopMostYtoTarget());

    //   case TooltipDirection.right:
    //     return new Offset(
    //       _targetCenter.dx,
    //       calcTopMostYtoTarget(),
    //     );

    //   default:
    // throw AssertionError(_popupDirection);
  }

  @override
  bool shouldRelayout(SingleChildLayoutDelegate oldDelegate) {
    return false;
  }

  @override
  BoxConstraints getConstraintsForChild(BoxConstraints constraints) {
    // logger.info("ParentConstraints: $constraints");

    // var calcMinWidth = _minWidth ?? 0.0;
    // var calcMaxWidth = _maxWidth ?? double.infinity;
    // var calcMinHeight = _minHeight ?? 0.0;
    // var calcMaxHeight = _maxHeight ?? double.infinity;

    // void calcMinMaxWidth() {
    //   if (_left != null && _right != null) {
    //     calcMaxWidth = constraints.maxWidth - (_left + _right);
    //   } else if ((_left != null && _right == null) ||
    //       (_left == null && _right != null)) {
    //     // make sure that the sum of left, right + maxwidth isn't bigger than the screen width.
    //     var sideDelta = (_left ?? 0.0) + (_right ?? 0.0) + _outSidePadding;
    //     if (calcMaxWidth > constraints.maxWidth - sideDelta) {
    //       calcMaxWidth = constraints.maxWidth - sideDelta;
    //     }
    //   } else {
    //     if (calcMaxWidth > constraints.maxWidth - 2 * _outSidePadding) {
    //       calcMaxWidth = constraints.maxWidth - 2 * _outSidePadding;
    //     }
    //   }
    // }

    // void calcMinMaxHeight() {
    //   if (_top != null && _bottom != null) {
    //     calcMaxHeight = constraints.maxHeight - (_top + _bottom);
    //   } else if ((_top != null && _bottom == null) ||
    //       (_top == null && _bottom != null)) {
    //     // make sure that the sum of top, bottom + maxHeight isn't bigger than the screen Height.
    //     var sideDelta = (_top ?? 0.0) + (_bottom ?? 0.0) + _outSidePadding;
    //     if (calcMaxHeight > constraints.maxHeight - sideDelta) {
    //       calcMaxHeight = constraints.maxHeight - sideDelta;
    //     }
    //   } else {
    //     if (calcMaxHeight > constraints.maxHeight - 2 * _outSidePadding) {
    //       calcMaxHeight = constraints.maxHeight - 2 * _outSidePadding;
    //     }
    //   }
    // }

    // switch (_popupDirection) {
    //   //
    //   case TooltipDirection.down:
    //     calcMinMaxWidth();
    //     if (_bottom != null) {
    //       calcMinHeight = calcMaxHeight =
    //           constraints.maxHeight - _bottom - _targetCenter.dy;
    //     } else {
    //       calcMaxHeight = min((_maxHeight ?? constraints.maxHeight),
    //               constraints.maxHeight - _targetCenter.dy) -
    //           _outSidePadding;
    //     }
    //     break;

    //   case TooltipDirection.up:
    //     calcMinMaxWidth();

    //     if (_top != null) {
    //       calcMinHeight = calcMaxHeight = _targetCenter.dy - _top;
    //     } else {
    //       calcMaxHeight =
    //           min((_maxHeight ?? constraints.maxHeight), _targetCenter.dy) -
    //               _outSidePadding;
    //     }
    //     break;

    //   case TooltipDirection.right:
    //     calcMinMaxHeight();
    //     if (_right != null) {
    //       calcMinWidth =
    //           calcMaxWidth = constraints.maxWidth - _right - _targetCenter.dx;
    //     } else {
    //       calcMaxWidth = min((_maxWidth ?? constraints.maxWidth),
    //               constraints.maxWidth - _targetCenter.dx) -
    //           _outSidePadding;
    //     }
    //     break;

    //   case TooltipDirection.left:
    //     calcMinMaxHeight();
    //     if (_left != null) {
    //       calcMinWidth = calcMaxWidth = _targetCenter.dx - _left;
    //     } else {
    //       calcMaxWidth =
    //           min((_maxWidth ?? constraints.maxWidth), _targetCenter.dx) -
    //               _outSidePadding;
    //     }
    //     break;

    //   default:
    //     throw AssertionError(_popupDirection);
    // }

    // var childConstraints = new BoxConstraints(
    //     minWidth: calcMinWidth > calcMaxWidth ? calcMaxWidth : calcMinWidth,
    //     maxWidth: calcMaxWidth,
    //     minHeight:
    //         calcMinHeight > calcMaxHeight ? calcMaxHeight : calcMinHeight,
    //     maxHeight: calcMaxHeight);

    // logger.info("Child constraints: $childConstraints");

    return BoxConstraints(maxWidth: constraints.maxWidth - _left! - _right!);
  }
}
