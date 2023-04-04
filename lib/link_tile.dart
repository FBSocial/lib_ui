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
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return FadeBackgroundButton(
      onTap: onTap,
      height: height,
      backgroundColor: theme.colorScheme.background,
      tapDownBackgroundColor: theme.colorScheme.background.withOpacity(0.5),
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
          style: Theme.of(context).textTheme.bodyMedium!.copyWith(fontSize: 17),
          child: title,
        ),
      ),
      sizeWidth8,
      if (trailing != null)
        DefaultTextStyle(
          style: Theme.of(context).textTheme.bodyLarge!.copyWith(fontSize: 15),
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
