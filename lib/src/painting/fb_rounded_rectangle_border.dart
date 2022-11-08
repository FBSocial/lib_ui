import 'dart:math';

import 'package:flutter/material.dart';

/// Fb 主题的绝大多数边框的最大半径都是 12
const double _kMaxBorderRadius = 12;

/// [FbRoundedRectangleBorder] 的圆角半径为组件高度除以 8，一旦超出 [_kMaxBorderRadius]，将会被设置为 [_kMaxBorderRadius]
class FbRoundedRectangleBorder extends OutlinedBorder {
  const FbRoundedRectangleBorder({BorderSide side = BorderSide.none}) : super(side: side);

  @override
  EdgeInsetsGeometry get dimensions {
    Table;
    return EdgeInsets.all(side.width);
  }

  @override
  ShapeBorder scale(double t) {
    return FbRoundedRectangleBorder(
      side: side.scale(t),
    );
  }

  @override
  ShapeBorder? lerpFrom(ShapeBorder? a, double t) {
    if (a is FbRoundedRectangleBorder) {
      return FbRoundedRectangleBorder(
        side: BorderSide.lerp(a.side, side, t),
      );
    }
    return super.lerpFrom(a, t);
  }

  @override
  ShapeBorder? lerpTo(ShapeBorder? b, double t) {
    RoundedRectangleBorder;
    if (b is FbRoundedRectangleBorder) {
      return FbRoundedRectangleBorder(
        side: BorderSide.lerp(side, b.side, t),
      );
    }
    return super.lerpTo(b, t);
  }

  /// Returns a copy of this RoundedRectangleBorder with the given fields
  /// replaced with the new values.
  @override
  FbRoundedRectangleBorder copyWith(
      {BorderSide? side, BorderRadiusGeometry? borderRadius}) {
    return FbRoundedRectangleBorder(
      side: side ?? this.side,
    );
  }

  /// 圆角计算规则是高度除以 8
  BorderRadius getRadius(double height) =>
      BorderRadius.circular(min(height / 8, _kMaxBorderRadius));

  @override
  Path getInnerPath(Rect rect, {TextDirection? textDirection}) {
    return Path()
      ..addRRect(getRadius(rect.height)
          .resolve(textDirection)
          .toRRect(rect)
          .deflate(side.width));
  }

  @override
  Path getOuterPath(Rect rect, {TextDirection? textDirection}) {
    return Path()
      ..addRRect(getRadius(rect.height).resolve(textDirection).toRRect(rect));
  }

  @override
  void paint(Canvas canvas, Rect rect, {TextDirection? textDirection}) {
    switch (side.style) {
      case BorderStyle.none:
        break;
      case BorderStyle.solid:
        final double width = side.width;
        if (width == 0.0) {
          canvas.drawRRect(
              getRadius(rect.height).resolve(textDirection).toRRect(rect),
              side.toPaint());
        } else {
          final RRect outer =
              getRadius(rect.height).resolve(textDirection).toRRect(rect);
          final RRect inner = outer.deflate(width);
          final Paint paint = Paint()..color = side.color;
          canvas.drawDRRect(outer, inner, paint);
        }
    }
  }

  @override
  bool operator ==(Object other) {
    if (other.runtimeType != runtimeType) return false;
    return other is FbRoundedRectangleBorder && other.side == side;
  }

  @override
  int get hashCode => side.hashCode;
}
