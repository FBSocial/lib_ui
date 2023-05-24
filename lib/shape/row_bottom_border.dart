import 'package:flutter/material.dart';

class RowBottomBorder extends ShapeBorder {
  final double leading;
  final double tail;
  final double width;
  final Color color;

  const RowBottomBorder(
      {this.leading = 40,
      this.width = 0.5,
      this.tail = 0,
      this.color = const Color(0x268F959E)});

  @override
  EdgeInsetsGeometry get dimensions => EdgeInsets.zero;

  @override
  Path getInnerPath(Rect rect, {TextDirection? textDirection}) {
    return Path();
  }

  @override
  Path getOuterPath(Rect rect, {TextDirection? textDirection}) {
    return Path();
  }

  @override
  void paint(Canvas canvas, Rect rect, {TextDirection? textDirection}) {
    final paint = Paint()
      ..color = color
      ..strokeWidth = width;
    final bottom = rect.bottom - width;
    canvas.drawLine(Offset(rect.left + leading, bottom),
        Offset(rect.right - tail, bottom), paint);
  }

  @override
  ShapeBorder scale(double t) {
    return const CircleBorder();
  }
}
