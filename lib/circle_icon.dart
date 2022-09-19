import 'package:flutter/material.dart';

// 圆形icon
class CircleIcon extends StatelessWidget {
  final IconData icon;
  final double radius;
  final Color? color;
  final Color backgroundColor;
  final double size;
  final Function? onTap;
  final Border? border;

  const CircleIcon({
    required this.icon,
    this.radius = 10,
    this.color = Colors.grey,
    this.backgroundColor = Colors.white,
    this.size = 13,
    this.onTap,
    this.border,
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap as void Function()?,
      child: Container(
        alignment: Alignment.center,
        width: radius * 2,
        height: radius * 2,
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          color: backgroundColor,
          border: border,
        ),
        child: Icon(
          icon,
          size: size,
          color: color,
        ),
      ),
    );
  }
}
