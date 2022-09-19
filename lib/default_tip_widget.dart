import 'package:flutter/material.dart';
import 'package:lib_theme/custom_color.dart';

class DefaultTipWidget extends StatelessWidget {
  final IconData icon;
  final double? iconSize;
  final Color? iconBackgroundColor;
  final Color? iconColor;
  final String text;
  final double? textSize;
  final Color? textColor;

  const DefaultTipWidget({
    required this.icon,
    required this.text,
    this.iconSize,
    this.iconBackgroundColor,
    this.iconColor,
    this.textSize,
    this.textColor,
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: <Widget>[
        Container(
          width: 96,
          height: 96,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            color: iconBackgroundColor ??
                Theme.of(context).scaffoldBackgroundColor,
          ),
          child: Icon(
            icon,
            size: iconSize ?? 40,
            color: iconColor ?? CustomColor(context).disableColor,
          ),
        ),
        const SizedBox(
          height: 22,
        ),
        Text(
          text,
          textAlign: TextAlign.center,
          style: TextStyle(
            color: textColor ?? CustomColor(context).disableColor,
            fontSize: textSize ?? 14,
          ),
        ),
      ],
    );
  }
}
