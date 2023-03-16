import 'dart:math' as math;

import 'package:flutter/material.dart';
import 'package:lib_theme/app_theme.dart';

class CirclePaint extends CustomPainter {
  final Color secondaryColor;
  final Color primaryColor;
  final double strokeWidth;

  double _degreeToRad(double degree) => degree * math.pi / 180;

  CirclePaint(
      {this.secondaryColor = Colors.grey,
      this.primaryColor = Colors.blue,
      this.strokeWidth = 15});

  @override
  void paint(Canvas canvas, Size size) {
    final double centerPoint = size.height / 2;
    final Paint paint = Paint()
      ..color = primaryColor
      ..strokeCap = StrokeCap.round
      ..style = PaintingStyle.stroke
      ..strokeWidth = strokeWidth;

    paint.shader = SweepGradient(
      colors: [secondaryColor, primaryColor],
      tileMode: TileMode.repeated,
      startAngle: _degreeToRad(270),
      endAngle: _degreeToRad(270 + 360.0),
    ).createShader(
        Rect.fromCircle(center: Offset(centerPoint, centerPoint), radius: 0));
    final scapSize = strokeWidth * 0.70;
    final double scapToDegree = scapSize / centerPoint;
    final double startAngle = _degreeToRad(270) + scapToDegree;
    final double sweepAngle = _degreeToRad(360) - (2 * scapToDegree);

    canvas.drawArc(const Offset(0, 0) & Size(size.width, size.width),
        startAngle, sweepAngle, false, paint..color = primaryColor);
  }

  @override
  bool shouldRepaint(CirclePaint oldDelegate) {
    return true;
  }
}

class CircularProgress extends StatefulWidget {
  const CircularProgress(
      {required this.size,
      this.secondaryColor = const Color(0x006179F2),
      this.primaryColor,
      this.lapDuration = 1000,
      this.strokeWidth = 1.67,
      Key? key})
      : super(key: key);

  final double size;
  final Color secondaryColor;
  final Color? primaryColor;
  final int lapDuration;
  final double strokeWidth;

  @override
  _CircularProgress createState() => _CircularProgress();
}

class _CircularProgress extends State<CircularProgress>
    with SingleTickerProviderStateMixin {
  late AnimationController controller;
  Animation? animation;

  @override
  void initState() {
    super.initState();

    controller = AnimationController(
        vsync: this, duration: Duration(milliseconds: widget.lapDuration))
      ..repeat();
  }

  @override
  void dispose() {
    controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return RotationTransition(
      turns: Tween(
        begin: 0.toDouble(),
        end: 1.toDouble(),
      ).animate(controller),
      child: CustomPaint(
        painter: CirclePaint(
            secondaryColor: widget.secondaryColor,
            primaryColor: widget.primaryColor ?? AppTheme.of(context).fg.blue1,
            strokeWidth: widget.strokeWidth),
        size: Size(widget.size, widget.size),
      ),
    );
  }
}
