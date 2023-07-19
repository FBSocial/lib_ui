import 'package:flutter/material.dart';
import 'package:lib_theme/app_theme.dart';
import 'package:lib_theme/const.dart';
import 'package:lib_theme/lib_theme.dart';
import 'package:lib_ui/lib_ui.dart';

import 'fb_buttons_mixins.dart';

enum _ButtonType {
  primary,
  secondary,
  tertiary,
  quaternary,
  dangerous,
  dangerous2,
}

class FbFilledButton extends StatelessWidget with FbButtonMixin {
  final VoidCallback? onTap;
  final VoidCallback? onLongPress;
  final String label;
  final IconData? icon;
  final FbButtonSize size;
  final _ButtonType type;
  final FbButtonState state;
  final bool widthUnlimited;
  final bool placeIconAfterLabel;

  const FbFilledButton.primary(
    this.label, {
    this.icon,
    this.placeIconAfterLabel = false,
    required this.onTap,
    this.onLongPress,
    this.widthUnlimited = false,
    this.state = FbButtonState.normal,
    this.size = FbButtonSize.small,
    Key? key,
  })  : type = _ButtonType.primary,
        super(key: key);

  const FbFilledButton.secondary(
    this.label, {
    this.icon,
    this.placeIconAfterLabel = false,
    required this.onTap,
    this.onLongPress,
    this.widthUnlimited = false,
    this.state = FbButtonState.normal,
    this.size = FbButtonSize.small,
    Key? key,
  })  : type = _ButtonType.secondary,
        super(key: key);

  const FbFilledButton.tertiary(
    this.label, {
    this.icon,
    this.placeIconAfterLabel = false,
    required this.onTap,
    this.onLongPress,
    this.widthUnlimited = false,
    this.state = FbButtonState.normal,
    this.size = FbButtonSize.small,
    Key? key,
  })  : type = _ButtonType.tertiary,
        super(key: key);

  const FbFilledButton.quaternary(
    this.label, {
    this.icon,
    this.placeIconAfterLabel = false,
    required this.onTap,
    this.onLongPress,
    this.widthUnlimited = false,
    this.state = FbButtonState.normal,
    this.size = FbButtonSize.small,
    Key? key,
  })  : type = _ButtonType.quaternary,
        super(key: key);

  const FbFilledButton.dangerous(
    this.label, {
    required this.onTap,
    this.onLongPress,
    this.widthUnlimited = false,
    this.state = FbButtonState.normal,
    this.size = FbButtonSize.small,
    this.icon,
    this.placeIconAfterLabel = false,
    Key? key,
  })  : type = _ButtonType.dangerous,
        super(key: key);

  const FbFilledButton.dangerous2(
    this.label, {
    required this.onTap,
    this.onLongPress,
    this.widthUnlimited = false,
    this.state = FbButtonState.normal,
    this.size = FbButtonSize.small,
    this.icon,
    this.placeIconAfterLabel = false,
    Key? key,
  })  : type = _ButtonType.dangerous2,
        super(key: key);

  @override
  Widget build(BuildContext context) {
    Widget child = buildLabelWidget(state, size, label);
    if (icon != null && state != FbButtonState.loading) {
      child = addIcon(child, icon!, placeIconAfterLabel, size);
    }
    Size? buttonSize = getButtonSize(size);
    child = ElevatedButton(
      onPressed: wrapTapCallback(onTap, state),
      onLongPress: wrapTapCallback(onLongPress, state),
      style: ButtonStyle(
        elevation: MaterialStateProperty.all(0),
        animationDuration: Duration.zero,
        splashFactory: NoSplash.splashFactory,
        foregroundColor: MaterialStateProperty.resolveWith(
            (states) => getForegroundColor(context, states)),
        overlayColor: MaterialStateProperty.resolveWith(
            (states) => getOverlayColor(state, states)),
        backgroundColor: MaterialStateProperty.resolveWith(
            (states) => getBackgroundColor(context, states)),
        padding: MaterialStateProperty.all(EdgeInsets.zero),
        //圆角：按钮高度 / 6 （规范提供公式）
        shape: ButtonStyleButton.allOrNull<OutlinedBorder>(
            RoundedRectangleBorder(
                borderRadius: BorderRadius.all(Radius.circular(
                    FbButtonTheme.of(context)?.borderRadius ??
                        (buttonSize.height / 6))))),
        textStyle: MaterialStateProperty.all(TextStyle(
          fontFamilyFallback: defaultFontFamilyFallback,
          fontSize: getFontSize(size),
          fontWeight: FontWeight.w500,
        )),
      ),
      child: child,
    );
    child = constrain(child, size, widthUnlimited);
    return child;
  }

  Color getForegroundColor(BuildContext context, Set<MaterialState> states) {
    final newTheme = AppTheme.of(context);

    Color colorDistinguishedByButtonType() {
      switch (type) {
        case _ButtonType.primary:
          return AppTheme.of(context).fg.white1;
        case _ButtonType.tertiary:
          return AppTheme.of(context).fg.b100;
        case _ButtonType.secondary:
        case _ButtonType.quaternary:
          return FbButtonTheme.of(context)?.primaryColor ??
              AppTheme.of(context).fg.blue1;
        case _ButtonType.dangerous:
          return newTheme.fg.white1;
        case _ButtonType.dangerous2:
          return newTheme.function.red1;
      }
    }

    switch (state) {
      case FbButtonState.normal:
        if (states.contains(MaterialState.pressed)) {
          return colorDistinguishedByButtonType().withOpacity(0.7);
        } else {
          return colorDistinguishedByButtonType();
        }
      case FbButtonState.loading:
        return colorDistinguishedByButtonType();
      case FbButtonState.disabled:
        return AppTheme.of(context).fg.b10.withOpacity(0.4);
      case FbButtonState.completed:
        return AppTheme.of(context).fg.b10.withOpacity(0.8);
      case FbButtonState.deactivated:
        final color = colorDistinguishedByButtonType();
        if (type == _ButtonType.dangerous2) {
          return color.withOpacity(0.3);
        } else {
          return color.withOpacity(0.7);
        }
    }
  }

  Color getBackgroundColor(BuildContext context, Set<MaterialState> states) {
    final newTheme = AppTheme.of(context);

    Color colorDistinguishedByButtonType() {
      switch (type) {
        case _ButtonType.primary:
          return FbButtonTheme.of(context)?.primaryColor ??
              AppTheme.of(context).fg.blue1;
        case _ButtonType.secondary:
        case _ButtonType.tertiary:
          return AppTheme.of(context).fg.b5;
        case _ButtonType.quaternary:
          return (FbButtonTheme.of(context)?.primaryColor ??
                  AppTheme.of(context).fg.blue1)
              .withOpacity(0.1);
        case _ButtonType.dangerous:
          return AppTheme.of(context).function.red1;
        case _ButtonType.dangerous2:
          return newTheme.bg.bg3;
      }
    }

    switch (state) {
      case FbButtonState.normal:
        return colorDistinguishedByButtonType();
      case FbButtonState.loading:
        return colorDistinguishedByButtonType();
      case FbButtonState.disabled:
      case FbButtonState.completed:
        return AppTheme.of(context).fg.b5;
      case FbButtonState.deactivated:
        final color = colorDistinguishedByButtonType();

        // 禁用态有些特殊，次按钮的背景色是 0.1，其他类型按钮的背景色是 0.4 透明度
        if (type == _ButtonType.secondary || type == _ButtonType.tertiary) {
          return color.withOpacity(0.1);
        } else if (type == _ButtonType.dangerous2) {
          return color;
        } else {
          return color.withOpacity(0.4);
        }
    }
  }
}
