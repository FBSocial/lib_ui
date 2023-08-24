import 'package:flutter/material.dart';
import 'package:lib_theme/const.dart';
import 'package:lib_theme/get_theme.dart';
import 'package:lib_ui/lib_ui.dart';
import 'package:get/get.dart';

mixin FbButtonMixin {
  double getFontSize(FbButtonSize size) {
    switch (size) {
      case FbButtonSize.mini:
        return 12;
      case FbButtonSize.small:
      case FbButtonSize.medium:
        return 14;
      case FbButtonSize.large:
        return 16;
    }
  }

  double getLoadingIconSize(FbButtonSize size) {
    switch (size) {
      case FbButtonSize.mini:
      case FbButtonSize.small:
      case FbButtonSize.medium:
        return 14;
      case FbButtonSize.large:
        return 16;
    }
  }

  Widget buildLabelWidget(
      FbButtonState state, FbButtonSize size, String label) {
    final showLoading = state == FbButtonState.loading && size.canLoading();
    final showText = !(size == FbButtonSize.small && showLoading);
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        if (showLoading)
          Builder(builder: (context) {
            final color = DefaultTextStyle.of(context).style.color!;
            return FbLoadingIndicator(
              size: getLoadingIconSize(size),
              strokeWidth: size.loadingIconThickness,
              color: color,
            );
          }),
        if (showLoading && showText) SizedBox(width: size.gapOfIconAndText),
        if (showText)
          Text(label,
              style: TextStyle(
                  fontWeight: FontWeight.w500,
                  fontSize: 14,
                  fontFamilyFallback: defaultFontFamilyFallback)),
      ],
    );
  }

  Size getButtonSize(FbButtonSize size) {
    switch (size) {
      case FbButtonSize.mini:
        return const Size(56, 28);

      case FbButtonSize.small:
        return const Size(60, 32);
      case FbButtonSize.medium:
        return const Size(184, 36);
      case FbButtonSize.large:
        return const Size(240, 44);
    }
  }

  Widget constrain(Widget widget, FbButtonSize size, bool widthUnlimited) {
    final s = getButtonSize(size);

    widget = SizedBox(
      width: s.width,
      height: s.height,
      child: widget,
    );

    if (!widthUnlimited) {
      widget = UnconstrainedBox(
        child: widget,
      );
    }
    return widget;
  }

  VoidCallback? wrapTapCallback(VoidCallback? callback, FbButtonState state) {
    if (state == FbButtonState.disabled ||
        state == FbButtonState.deactivated ||
        state == FbButtonState.loading) {
      return null;
    }
    return callback;
  }

  Color getOverlayColor(
    FbButtonState state,
    Set<MaterialState> states,
  ) {
    if (state != FbButtonState.normal) {
      return Colors.transparent;
    }
    if (states.contains(MaterialState.pressed)) {
      return Get.themeToken.fg.b5;
    }
    if (states.contains(MaterialState.hovered)) {
      return Get.themeToken.fg.white1.withOpacity(0.15);
    }

    return Colors.transparent;
  }

  Widget addIcon(
    Widget label,
    IconData icon,
    bool placeIconAfterLabel,
    FbButtonSize size,
  ) {
    double space;
    double iconSize;
    switch (size) {
      case FbButtonSize.mini:
        assert(false, "size 'mini' cannot display icons");
        space = 0;
        iconSize = 0;
        break;
      case FbButtonSize.small:
        space = 6;
        iconSize = 16;
        break;
      case FbButtonSize.medium:
        space = 6;
        iconSize = 16;
        break;
      case FbButtonSize.large:
        space = 8;
        iconSize = 18;
        break;
    }
    final children = [
      Icon(icon, size: iconSize),
      SizedBox(width: space),
      label,
    ];
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: placeIconAfterLabel ? children.reversed.toList() : children,
    );
  }
}
