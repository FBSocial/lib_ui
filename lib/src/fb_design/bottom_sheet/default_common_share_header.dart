import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:lib_extension/string_extension.dart';
import 'package:lib_theme/app_theme.dart';
import 'package:lib_theme/const.dart';

class DefaultCommonShareHeader extends StatelessWidget {
  final String? title;
  final String? subTitle;
  final TextStyle? titleStyle;
  final TextStyle? subTitleStyle;
  final Widget? actionWidget;
  final Color? appBarBg;
  final double headSpaceHeight;
  final double? titleBottomGap;
  final double marginLeft;
  final double marginRight;
  final Widget? titleWidget;
  final bool? showLeading;

  const DefaultCommonShareHeader({
    Key? key,
    this.title,
    this.appBarBg,
    this.actionWidget,
    this.subTitle,
    this.titleStyle,
    this.subTitleStyle,
    this.headSpaceHeight = 12,
    this.titleBottomGap,
    this.marginLeft = 12,
    this.marginRight = 14,
    this.titleWidget,
    this.showLeading = true,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final _titleStyle = titleStyle ??
        TextStyle(
          color: AppTheme.of(context).fg.b100,
          fontSize: 16,
          height: 20 / 16,
          fontFamilyFallback: defaultFontFamilyFallback,
          fontWeight: FontWeight.w500,
        );
    final _subTitleStyle = subTitleStyle ??
        TextStyle(
          color: AppTheme.of(context).fg.b40,
          fontSize: 12,
          height: 18 / 12,
        );
    const double iconSize = 24;
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        SizedBox(height: headSpaceHeight),
        AppBar(
          primary: false,
          leadingWidth: 36,
          toolbarHeight: 44,
          backgroundColor: appBarBg ?? AppTheme.of(context).bg.bg3,
          leading: (showLeading ?? true)
              ? GestureDetector(
                  onTap: Get.back,
                  child: Container(
                    width: iconSize,
                    height: iconSize,
                    margin: EdgeInsets.only(left: marginLeft),
                    decoration: BoxDecoration(
                      color: AppTheme.of(context).fg.b5,
                      shape: BoxShape.circle,
                    ),
                    child: Icon(
                      Icons.keyboard_arrow_down_outlined,
                      size: 22,
                      color: AppTheme.of(context).fg.b100,
                    ),
                  ),
                )
              : const SizedBox(width: iconSize),
          centerTitle: true,
          title: titleWidget ??
              Column(
                children: [
                  Text(title ?? '', style: _titleStyle),
                  if (subTitle.hasValue) ...[
                    SizedBox(height: titleBottomGap ?? 4),
                    Text(subTitle!, style: _subTitleStyle),
                  ],
                ],
              ),
          elevation: 0,
          actions: [
            if (actionWidget != null) actionWidget!,
            SizedBox(width: marginRight),
          ],
        ),
      ],
    );
  }
}
