import 'dart:math';

import 'package:flutter/material.dart';

class FbLoadingIndicator extends StatefulWidget {
  final double size;
  final Color? trailingColor;
  final Color? leadingColor;
  final int lapDuration;
  final double strokeWidth;

  const FbLoadingIndicator({
    this.size = 32,
    this.trailingColor,
    this.leadingColor,
    this.lapDuration = 1000,
    this.strokeWidth = 2,
    Key? key,
  }) : super(key: key);

  @override
  _FbLoadingIndicatorState createState() => _FbLoadingIndicatorState();
}

class _FbLoadingIndicatorState extends State<FbLoadingIndicator>
    with SingleTickerProviderStateMixin {
  late AnimationController controller;
  late Animation<double> animation;

  @override
  void initState() {
    controller = AnimationController(
        vsync: this, duration: Duration(milliseconds: widget.lapDuration))
      ..repeat();
    animation = Tween<double>(
      begin: 0,
      end: 1,
    ).animate(controller);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final trailing = widget.trailingColor ?? theme.primaryColor.withOpacity(0);
    final leading = widget.leadingColor ?? theme.primaryColor;

    return RotationTransition(
      turns: animation,
      child: CustomPaint(
        painter: _Painter(
            trailingColor: trailing,
            leadingColor: leading,
            strokeWidth: widget.strokeWidth),
        size: Size.square(widget.size),
      ),
    );
  }

  @override
  void dispose() {
    controller.dispose();
    super.dispose();
  }
}

const _deg2rad = pi / 180;

class _Painter extends CustomPainter {
  final Color trailingColor;
  final Color leadingColor;
  final double strokeWidth;

  Paint? painter;

  _Painter({
    required this.trailingColor,
    required this.leadingColor,
    required this.strokeWidth,
  });

  @override
  void paint(Canvas canvas, Size size) {
    double centerPoint = size.height / 2;

    double percentValue = 100 / 100;
    double radius = centerPoint;

    if (painter == null) {
      painter = Paint()
        ..color = Colors.white
        ..strokeCap = StrokeCap.round
        ..style = PaintingStyle.stroke
        ..strokeWidth = strokeWidth;

      painter!.shader = SweepGradient(
        colors: [leadingColor, trailingColor],
        tileMode: TileMode.repeated,
        startAngle: _deg2rad * 270,
        endAngle: _deg2rad * (270 + 360.0),
      ).createShader(
          Rect.fromCircle(center: Offset(centerPoint, centerPoint), radius: 0));
    }

    Rect rect = Rect.fromCircle(
        center: Offset(centerPoint, centerPoint), radius: radius);

    var scapSize = strokeWidth / 2;
    double scapToDegree = scapSize / radius;

    double startAngle = _deg2rad * 270 + scapToDegree;
    double sweepAngle = _deg2rad * 360 - (2 * scapToDegree);

    canvas.drawArc(
        rect, startAngle, percentValue * sweepAngle, false, painter!);
  }

  @override
  bool shouldRepaint(_Painter oldDelegate) {
    return true;
  }
}
