import 'package:flutter/material.dart';
import 'package:lib_extension/string_extension.dart';
import 'package:lib_theme/app_theme.dart';
import 'package:lib_theme/const.dart';
import 'package:websafe_svg/websafe_svg.dart';

class SvgTipWidget extends StatelessWidget {
  final String svgName;
  final double size;
  final String text;
  final double? textSize;
  final Color? textColor;
  final FontWeight? fontWeight;
  final String? desc;
  final Widget? bottomWidget;

  const SvgTipWidget({
    required this.svgName,
    this.text = '',
    this.size = 140,
    this.textSize,
    this.textColor,
    this.fontWeight,
    this.desc,
    this.bottomWidget,
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: <Widget>[
        SizedBox(
          width: size,
          height: size,
          child: WebsafeSvg.asset(svgName),
        ),
        const SizedBox(
          height: 18,
        ),
        if (text.hasValue)
          Text(
            text,
            textAlign: TextAlign.center,
            style: TextStyle(
                color: textColor ?? AppTheme.of(context).fg.b40,
                fontSize: textSize ?? 17,
                fontWeight: fontWeight ?? FontWeight.w500),
          ),
        if (desc != null) ...[
          sizeHeight16,
          Text(
            desc!,
            style:
                Theme.of(context).textTheme.bodyText1!.copyWith(fontSize: 14),
            textAlign: TextAlign.center,
          )
        ],
        if (bottomWidget != null) bottomWidget!,
      ],
    );
  }
}
