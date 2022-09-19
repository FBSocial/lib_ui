import 'package:flutter/material.dart';

class BubbleShapeBorder extends ShapeBorder {
  final double angleHeight;
  final double angleWidth;
  final double anglePositionX;
  final double radius;

  const BubbleShapeBorder(
      {this.angleHeight = 6,
      this.angleWidth = 12,
      this.anglePositionX = 20,
      this.radius = 3});

  @override
  EdgeInsetsGeometry get dimensions => EdgeInsets.zero;

  @override
  Path getInnerPath(Rect rect, {TextDirection? textDirection}) {
    return Path();
  }

  @override
  Path getOuterPath(Rect rect, {TextDirection? textDirection}) {
    final top = rect.top + angleHeight;
    final path = Path()
      ..moveTo(rect.left, top + radius)
      ..arcToPoint(
        Offset(rect.left + radius, rect.top + angleHeight),
        radius: Radius.circular(radius),
      )

      /// arrow
      ..lineTo(rect.left + anglePositionX - angleWidth / 2, top)
      ..lineTo(rect.left + anglePositionX, rect.top)
      ..lineTo(rect.left + anglePositionX + angleWidth / 2, top)

      /// 接着画
      ..lineTo(rect.right - radius, top)
      ..arcToPoint(
        Offset(rect.right, rect.top + angleHeight + radius),
        radius: Radius.circular(radius),
      )
      ..lineTo(rect.right, rect.bottom - radius)
      ..arcToPoint(
        Offset(rect.right - radius, rect.bottom),
        radius: Radius.circular(radius),
      )
      ..lineTo(rect.left + radius, rect.bottom)
      ..arcToPoint(
        Offset(rect.left, rect.bottom - radius),
        radius: Radius.circular(radius),
      )
      ..lineTo(rect.left, top);
    path.fillType = PathFillType.evenOdd;
    return path;
  }

  @override
  void paint(Canvas canvas, Rect rect, {TextDirection? textDirection}) {}

  @override
  ShapeBorder scale(double t) {
    return const CircleBorder();
  }
}
