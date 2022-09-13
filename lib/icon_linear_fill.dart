import 'package:flutter/material.dart';

class IconLinearFill extends StatefulWidget {
  final Duration loadDuration;
  final double boxHeight;
  final double boxWidth;
  final Widget icon;
  final Color boxBackgroundColor;
  final Color linearColor;
  const IconLinearFill({
    Key? key,
    required this.icon,
    this.loadDuration = const Duration(seconds: 1),
    this.boxHeight = 50,
    this.boxWidth = 50,
    this.boxBackgroundColor = Colors.transparent,
    this.linearColor = Colors.blueAccent,
  }) : super(key: key);

  @override
  _IconLinearFillState createState() => _IconLinearFillState();
}

class _IconLinearFillState extends State<IconLinearFill>
    with TickerProviderStateMixin {
  AnimationController? _loadController;

  late Animation<double> _loadValue;

  @override
  void initState() {
    super.initState();

    _loadController = AnimationController(
      vsync: this,
      duration: widget.loadDuration,
    );

    _loadValue = Tween<double>(begin: 0, end: 100).animate(_loadController!)
      ..addStatusListener((status) {
        switch (status) {
          case AnimationStatus.completed:
            _loadController!.reverse();
            break;
          case AnimationStatus.dismissed:
            _loadController!.forward();
            break;
          default:
            break;
        }
      });

    _loadController!.forward();
  }

  @override
  void dispose() {
    _loadController?.stop();
    _loadController?.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: <Widget>[
        SizedBox(
          height: widget.boxHeight,
          width: widget.boxWidth,
          child: Center(child: widget.icon),
        ),
        SizedBox(
          height: widget.boxHeight,
          width: widget.boxWidth,
          child: AnimatedBuilder(
            animation: _loadController!,
            builder: (context, child) {
              return CustomPaint(
                painter: LinearPainter(
                  linearAnimation: _loadController,
                  percentValue: _loadValue.value,
                  boxHeight: widget.boxHeight,
                  linearColor: widget.linearColor,
                ),
              );
            },
          ),
        ),
        SizedBox(
          height: widget.boxHeight,
          width: widget.boxWidth,
          child: ShaderMask(
            blendMode: BlendMode.srcOut,
            shaderCallback: (bounds) => LinearGradient(
              colors: [widget.boxBackgroundColor],
              stops: const [0],
            ).createShader(bounds),
            child: Container(
              color: Colors.transparent,
              child: Stack(
                children: [
                  Center(child: widget.icon),
                ],
              ),
            ),
          ),
        )
      ],
    );
  }
}

class LinearPainter extends CustomPainter {
  final Animation<double>? linearAnimation;
  final double? percentValue;
  final double? boxHeight;
  final Color? linearColor;

  LinearPainter({
    this.linearAnimation,
    this.percentValue,
    this.boxHeight,
    this.linearColor,
  });

  @override
  void paint(Canvas canvas, Size size) {
    final percent = percentValue! / 100.0;
    final baseHeight = boxHeight! - (percent * boxHeight!);

    final width = size.width;
    final height = size.height;
    final path = Path();
    path.moveTo(0, baseHeight);
    for (var i = 0.0; i < width; i++) {
      path.lineTo(
        i,
        baseHeight,
      );
    }

    path.lineTo(width, height);
    path.lineTo(0, height);
    path.close();
    final wavePaint = Paint()..color = linearColor!;
    canvas.drawPath(path, wavePaint);
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) {
    return true;
  }
}
