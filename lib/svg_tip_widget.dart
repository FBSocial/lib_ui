import 'package:flutter/material.dart';
import 'package:lib_extension/string_extension.dart';
import 'package:lib_theme/app_theme.dart';
import 'package:lib_theme/const.dart';
import 'package:flutter_svg/flutter_svg.dart';

class SvgTipWidget extends StatelessWidget {
  final String svgName;
  final double size;
  final BoxFit? fit;
  final String text;
  final double? textSize;
  final Color? textColor;
  final FontWeight? fontWeight;
  final String? desc;
  final Widget? bottomWidget;
  final double? textPadding;
  final double? descPadding;

  const SvgTipWidget({
    required this.svgName,
    this.text = '',
    this.size = 140,
    this.fit,
    this.textSize,
    this.textColor,
    this.fontWeight,
    this.desc,
    this.bottomWidget,
    this.textPadding,
    this.descPadding,
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
          child: SvgPicture.asset(
            svgName,
            fit: fit ?? BoxFit.contain,
          ),
        ),
        SizedBox(height: textPadding ?? 18),
        if (text.hasValue)
          Text(
            text,
            textAlign: TextAlign.center,
            style: TextStyle(
                color: textColor ?? AppTheme.of(context).fg.b100,
                fontSize: textSize ?? 17,
                fontWeight: fontWeight ?? FontWeight.w500),
          ),
        if (desc != null) ...[
          SizedBox(height: descPadding ?? 16),
          Text(
            desc!,
            style: TextStyle(
              color: AppTheme.of(context).fg.b60,
              fontSize: 14,
              fontWeight: FontWeight.normal,
              height: 1.35,
              fontFamilyFallback: defaultFontFamilyFallback,
            ),
            textAlign: TextAlign.center,
          )
        ],
        if (bottomWidget != null) ...[
          sizeHeight24,
          bottomWidget!,
        ],
      ],
    );
  }
}
