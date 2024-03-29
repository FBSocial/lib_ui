import 'package:flutter/material.dart';
import 'package:lib_theme/app_theme.dart';
import 'package:lib_theme/const.dart';
import 'package:lib_ui/button/fade_background_button.dart';
import 'package:lib_ui/button/more_icon.dart';

class LinkTile extends StatelessWidget {
  final BuildContext context;
  final Widget title;
  final Widget? trailing;
  final double? height;
  final GestureTapCallback? onTap;
  final bool? showTrailingIcon;
  final EdgeInsetsGeometry? padding;
  final double borderRadius;
  final Widget? trailingWidget;
  final bool titleExpanded;
  final Color? backgroundColor;
  final Color? tapDownBackgroundColor;

  const LinkTile(
    this.context,
    this.title, {
    this.trailing,
    this.height,
    this.onTap,
    this.showTrailingIcon = true,
    this.padding,
    this.borderRadius = 0,
    this.trailingWidget,
    this.titleExpanded = true,
    this.backgroundColor,
    this.tapDownBackgroundColor,
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return FadeBackgroundButton(
      onTap: onTap,
      height: height,
      backgroundColor: backgroundColor ?? AppTheme.of(context).bg.bg3,
      tapDownBackgroundColor:
          tapDownBackgroundColor ?? AppTheme.of(context).bg.bg2,
      borderRadius: borderRadius,
      child: Padding(
        padding: padding ??
            EdgeInsets.symmetric(
                vertical: height == null ? 16 : 0, horizontal: 12),
        child: Row(
          children: titleExpanded ? getTitleExpanded() : getTrailingExpanded(),
        ),
      ),
    );
  }

  List<Widget> getTitleExpanded() {
    return [
      Expanded(
        child: DefaultTextStyle(
          style: TextStyle(
            color: AppTheme.of(context).fg.b100,
            height: 1.35,
            fontSize: 17,
          ),
          child: title,
        ),
      ),
      sizeWidth8,
      if (trailing != null)
        DefaultTextStyle(
          style: TextStyle(
              color: AppTheme.of(context).fg.b60,
              fontWeight: FontWeight.normal,
              height: 1.35,
              fontFamilyFallback: defaultFontFamilyFallback,
              fontSize: 15),
          child: trailing!,
        ),
      if (showTrailingIcon!) ...[
        sizeWidth2,
        MoreIcon(
          color: AppTheme.of(context).fg.b20,
        )
      ],
    ];
  }

  List<Widget> getTrailingExpanded() {
    return [
      title,
      sizeWidth8,
      Expanded(
        child: trailing!,
      ),
      sizeWidth5,
      if (showTrailingIcon!) trailingWidget ?? const MoreIcon()
    ];
  }
}
