import 'package:flutter/material.dart';
import 'package:lib_theme/app_theme.dart';
import 'package:lib_ui/lib_ui.dart';

import 'fb_buttons_mixins.dart';

enum _ButtonType {
  primary,
  secondary,
}

class FbOutlinedButton extends StatelessWidget with FbButtonMixin {
  final VoidCallback? onTap;
  final VoidCallback? onLongPress;
  final String label;
  final IconData? icon;
  final FbButtonSize size;
  final _ButtonType type;
  final FbButtonState state;
  final bool widthUnlimited;

  const FbOutlinedButton.primary(
    this.label, {
    required this.onTap,
    this.onLongPress,
    this.state = FbButtonState.normal,
    this.size = FbButtonSize.small,
    this.widthUnlimited = false,
    this.icon,
    Key? key,
  })  : type = _ButtonType.primary,
        super(key: key);

  const FbOutlinedButton.secondary(
    this.label, {
    required this.onTap,
    this.onLongPress,
    this.state = FbButtonState.normal,
    this.size = FbButtonSize.small,
    this.widthUnlimited = false,
    this.icon,
    Key? key,
  })  : type = _ButtonType.secondary,
        super(key: key);

  Color? getBackgroundColor(BuildContext context, Set<MaterialState> states) {
    final theme = appThemeData;

    Color colorDistinguishedByButtonType() {
      switch (type) {
        case _ButtonType.primary:
          return theme.primaryColor;
        case _ButtonType.secondary:
          return theme.colorScheme.onSecondary;
      }
    }

    switch (state) {
      case FbButtonState.loading:
      case FbButtonState.normal:
      case FbButtonState.deactivated:
        break;
      case FbButtonState.disabled:
      case FbButtonState.completed:
        return theme.colorScheme.onSecondary.withOpacity(0.1);
    }

    if (states.contains(MaterialState.hovered)) {
      return colorDistinguishedByButtonType().withOpacity(0.1);
    }
    if (states.contains(MaterialState.pressed)) {
      return theme.backgroundColor.withOpacity(0.8);
    }

    return null;
  }

  Color getForegroundColor(BuildContext context, Set<MaterialState> states) {
    final theme = appThemeData;

    Color colorDistinguishedByButtonType() {
      switch (type) {
        case _ButtonType.primary:
          return theme.primaryColor;
        case _ButtonType.secondary:
          return theme.textTheme.bodyText2!.color!;
      }
    }

    switch (state) {
      case FbButtonState.loading:
      case FbButtonState.normal:
        return colorDistinguishedByButtonType();
      case FbButtonState.deactivated:
        return colorDistinguishedByButtonType().withOpacity(0.4);
      case FbButtonState.disabled:
        return appThemeData.iconTheme.color!.withOpacity(0.4);
      case FbButtonState.completed:
        return appThemeData.iconTheme.color!.withOpacity(0.8);
    }
  }

  @override
  Widget build(BuildContext context) {
    Widget child = buildLabelWidget(state, label);
    if (icon != null && state != FbButtonState.loading) {
      child = addLeadingIcon(child, icon!, size);
    }
    final buttonSize = getButtonSize(size);
    child = OutlinedButton(
      onPressed: wrapTapCallback(onTap, state),
      onLongPress: wrapTapCallback(onLongPress, state),
      style: ButtonStyle(
        splashFactory: NoSplash.splashFactory,
        side: MaterialStateProperty.resolveWith(
            (states) => getBorderSide(context, states)),
        padding: MaterialStateProperty.all(EdgeInsets.zero),
        shape: ButtonStyleButton.allOrNull<OutlinedBorder>(
            RoundedRectangleBorder(
                borderRadius: BorderRadius.all(
                    Radius.circular((buttonSize.height) / 6)))),
        foregroundColor: MaterialStateProperty.resolveWith((states) =>
            getOverlayForegroundColor(
                getForegroundColor(context, states), state, states)),
        backgroundColor: MaterialStateProperty.resolveWith((states) {
          final color = getBackgroundColor(context, states);
          if (color == null) return null;
          return getOverlayBackgroundColor(color, state, states);
        }),
        textStyle: MaterialStateProperty.all(
            Theme.of(context).textTheme.bodyText2!.copyWith(
                  fontSize: getFontSize(size),
                  fontWeight: FontWeight.w500,
                )),
      ),
      child: child,
    );
    child = constrain(child, size, widthUnlimited);
    return child;
  }

  BorderSide? getBorderSide(BuildContext context, Set<MaterialState> states) {
    final theme = appThemeData;
    Color colorDistinguishedByButtonType() {
      switch (type) {
        case _ButtonType.primary:
          return theme.primaryColor;
        case _ButtonType.secondary:
          return theme.colorScheme.onSecondary;
      }
    }

    switch (state) {
      case FbButtonState.normal:
        return BorderSide(color: colorDistinguishedByButtonType(), width: 0.5);
      case FbButtonState.deactivated:
        return BorderSide(
            color: colorDistinguishedByButtonType().withOpacity(0.4),
            width: 0.5);
      case FbButtonState.loading:
        return BorderSide(color: colorDistinguishedByButtonType(), width: 0.5);
      case FbButtonState.disabled:
      case FbButtonState.completed:
        return BorderSide.none;
    }
  }
}
