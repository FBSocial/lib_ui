import 'package:flutter/material.dart';
import 'package:lib_theme/app_theme.dart';

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
            color: iconBackgroundColor ?? AppTheme.of(context).bg.bg1,
          ),
          child: Icon(
            icon,
            size: iconSize ?? 40,
            color: iconColor ?? AppTheme.of(context).fg.b40,
          ),
        ),
        const SizedBox(
          height: 22,
        ),
        Text(
          text,
          textAlign: TextAlign.center,
          style: TextStyle(
            color: textColor ?? AppTheme.of(context).fg.b40,
            fontSize: textSize ?? 14,
          ),
        ),
      ],
    );
  }
}
