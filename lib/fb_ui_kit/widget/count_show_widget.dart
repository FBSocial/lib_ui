import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class CountShowWidget extends StatelessWidget {
  final int? currentCount;
  final int? allCount;

  const CountShowWidget(this.currentCount, this.allCount, {Key? key})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    const leftColor = Color(0xFFF5F5F8);
    const rightColor = Color(0xFFE0E2E6);
    return SizedBox(
      // padding: EdgeInsets.only(left: 6,right: 6),
      height: 20,

      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            alignment: Alignment.center,
            padding: const EdgeInsets.only(left: 6, right: 3),
            decoration: const BoxDecoration(
              color: leftColor,
              borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(10),
                  bottomLeft: Radius.circular(10)),
            ),
            child: Text(
              "$currentCount",
              textAlign: TextAlign.center,
              style: const TextStyle(
                  fontSize: 11, height: 1, color: Color(0xFF646A73)),
            ),
          ),
          const SizedBox(
              width: 6,
              height: 20,
              child: CustomPaint(painter: SplitPaint(leftColor, rightColor))),
          Container(
            alignment: Alignment.center,
            padding: const EdgeInsets.only(left: 3, right: 6),
            decoration: const BoxDecoration(
              color: rightColor,
              borderRadius: BorderRadius.only(
                  topRight: Radius.circular(10),
                  bottomRight: Radius.circular(10)),
            ),
            child: Text("$allCount",
                textAlign: TextAlign.center,
                style: const TextStyle(
                    fontSize: 11, height: 1, color: Color(0xFF646A73))),
          ),
        ],
      ),
    );
  }
}

// 只绘制中间分割线部分
class SplitPaint extends CustomPainter {
  final Color leftColor; //const Color(0xFFF5F5F8)
  final Color rightColor; //const Color(0xFF8F959E).withOpacity(0.15);
  // final int leftNumber;
  // final int rightNumber;

  const SplitPaint(this.leftColor, this.rightColor);

  @override
  void paint(Canvas canvas, Size size) {
    final Path pathLeft = Path()..moveTo(0, 0);
    pathLeft.lineTo(size.width, 0);
    pathLeft.lineTo(0, size.height);
    pathLeft.lineTo(0, 0);
    final paintLeft = Paint()..color = leftColor;
    canvas.drawPath(pathLeft, paintLeft);
    final Path pathRight = Path()..moveTo(size.width, 0);
    pathRight.lineTo(size.width, size.height);
    pathRight.lineTo(0, size.height);
    pathRight.lineTo(size.width, 0);
    final paintRight = Paint()..color = rightColor;
    canvas.drawPath(pathRight, paintRight);
  }

  // void paint(Canvas canvas, Size size) {
  //   const double tan = 20 / 6; //tan(x) h/w
  //   final offset = size.height / (2 * tan);
  //   final Path pathLeft = Path()..moveTo(0, 0);
  //   pathLeft.lineTo(size.width / 2 + offset, 0);
  //   pathLeft.lineTo(size.width / 2 - offset, size.height);
  //   pathLeft.lineTo(0, size.height);
  //   pathLeft.lineTo(0, 0);
  //   final paintLeft = Paint()..color = const Color(0xFFF5F5F8);
  //   canvas.drawPath(pathLeft, paintLeft);
  //
  //   final Path pathRight = Path()..moveTo(size.width / 2 + offset, 0);
  //   pathRight.lineTo(size.width, 0);
  //   pathRight.lineTo(size.width, size.height);
  //   pathRight.lineTo(size.width / 2 - offset, size.height);
  //   pathRight.lineTo(size.width / 2 + offset, 0);
  //   final paintRight = Paint()
  //     ..color = const Color(0xFF8F959E).withOpacity(0.15);
  //   canvas.drawPath(pathRight, paintRight);
  // }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}
