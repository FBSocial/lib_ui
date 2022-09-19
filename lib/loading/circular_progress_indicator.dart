import 'dart:math';

import 'package:flutter/material.dart';

class CircularProgress extends StatefulWidget {
  final double size;
  final Color secondaryColor;
  final Color primaryColor;
  final int lapDuration;
  final double strokeWidth;

  const CircularProgress(
      {required this.size,
      this.secondaryColor = Colors.white,
      this.primaryColor = Colors.orange,
      this.lapDuration = 1000,
      this.strokeWidth = 5.0,
      Key? key})
      : super(key: key);

  @override
  _CircularProgress createState() => _CircularProgress();
}

class _CircularProgress extends State<CircularProgress>
    with SingleTickerProviderStateMixin {
  late AnimationController controller;
  late Animation animation;

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
    return RotationTransition(
      turns: animation as Animation<double>,
      child: CustomPaint(
        painter: CirclePaint(
            secondaryColor: widget.secondaryColor,
            primaryColor: widget.primaryColor,
            strokeWidth: widget.strokeWidth),
        size: Size(widget.size, widget.size),
      ),
    );
  }

  @override
  void dispose() {
    controller.dispose();
    super.dispose();
  }
}

class CirclePaint extends CustomPainter {
  final Color secondaryColor;
  final Color primaryColor;
  final double strokeWidth;

  double _degreeToRad(double degree) => degree * pi / 180;

  CirclePaint(
      {this.secondaryColor = Colors.grey,
      this.primaryColor = Colors.blue,
      this.strokeWidth = 15});

  @override
  void paint(Canvas canvas, Size size) {
    final centerPoint = size.height / 2;

    final paint = Paint()
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

    final startAngle = _degreeToRad(0);
    final sweepAngle = _degreeToRad(360);

    canvas.drawArc(Offset.zero & Size(size.width, size.width), startAngle,
        sweepAngle, false, paint..color = primaryColor);
  }

  @override
  bool shouldRepaint(CirclePaint oldDelegate) {
    return true;
  }
}
