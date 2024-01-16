import 'dart:math';

import 'package:flutter/material.dart';
import 'package:lib_utils/config/config.dart';

import 'message_tooltip.dart';

class PopupBallonLayoutDelegate extends SingleChildLayoutDelegate {
  // TooltipDirection _popupDirection;
  final Offset? _targetCenter;
  final double? _minHeight;
  final double? _left;
  final double? _right;
  final double? _outSidePadding;
  final BuildContext? _context;
  final Size? _renderBoxSize;
  TooltipDirection _popupDirection = TooltipDirection.up;

  TooltipDirection get popupDirection => _popupDirection;

  PopupBallonLayoutDelegate({
    Offset? targetCenter,
    double? minHeight,
    double? outSidePadding,
    double? left,
    double? right,
    BuildContext? context,
    Size? renderBoxSize,
  })  : _targetCenter = targetCenter,
        _minHeight = minHeight,
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
  }

  @override
  bool shouldRelayout(SingleChildLayoutDelegate oldDelegate) {
    return false;
  }

  @override
  BoxConstraints getConstraintsForChild(BoxConstraints constraints) {
    return BoxConstraints(maxWidth: constraints.maxWidth - _left! - _right!);
  }
}
