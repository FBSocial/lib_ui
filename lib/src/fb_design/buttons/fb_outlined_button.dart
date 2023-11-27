import 'package:flutter/material.dart';
import 'package:lib_theme/lib_theme.dart';
import 'package:lib_ui/lib_ui.dart';

import 'fb_buttons_mixins.dart';

enum _ButtonType {
  primary,
  secondary,
  dangerous,
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
  final bool placeIconAfterLabel;
  final double? borderRadius;

  /// - 是否是圆角
  final bool isOval;

  const FbOutlinedButton.primary(
    this.label, {
    required this.onTap,
    this.onLongPress,
    this.state = FbButtonState.normal,
    this.size = FbButtonSize.small,
    this.widthUnlimited = false,
    this.icon,
    this.placeIconAfterLabel = false,
    this.isOval = false,
    this.borderRadius,
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
    this.placeIconAfterLabel = false,
    this.isOval = false,
    this.borderRadius,
    Key? key,
  })  : type = _ButtonType.secondary,
        super(key: key);

  const FbOutlinedButton.dangerous(
    this.label, {
    required this.onTap,
    this.onLongPress,
    this.state = FbButtonState.normal,
    this.size = FbButtonSize.small,
    this.widthUnlimited = false,
    this.icon,
    this.placeIconAfterLabel = false,
    this.isOval = false,
    this.borderRadius,
    Key? key,
  })  : type = _ButtonType.dangerous,
        super(key: key);

  Color? getBackgroundColor(BuildContext context, Set<MaterialState> states) {
    Color colorDistinguishedByButtonType() {
      switch (type) {
        case _ButtonType.primary:
          return FbButtonTheme.of(context)?.primaryColor ??
              AppTheme.of(context).fg.blue1;
        case _ButtonType.secondary:
          return AppTheme.of(context).fg.b40;

        case _ButtonType.dangerous:
          return AppTheme.of(context).function.red3;
      }
    }

    switch (state) {
      case FbButtonState.loading:
      case FbButtonState.normal:
      case FbButtonState.deactivated:
        break;
      case FbButtonState.disabled:
      case FbButtonState.completed:
        return AppTheme.of(context).fg.b20;
    }

    if (states.contains(MaterialState.hovered)) {
      return colorDistinguishedByButtonType().withOpacity(0.1);
    }
    if (states.contains(MaterialState.pressed)) {
      return AppTheme.of(context).fg.b20.withOpacity(0.8);
    }

    return null;
  }

  Color getForegroundColor(BuildContext context, Set<MaterialState> states) {
    Color colorDistinguishedByButtonType() {
      switch (type) {
        case _ButtonType.primary:
          return FbButtonTheme.of(context)?.primaryColor ??
              AppTheme.of(context).fg.blue1;
        case _ButtonType.secondary:
          return AppTheme.of(context).fg.b100;
        case _ButtonType.dangerous:
          return AppTheme.of(context).function.red1;
      }
    }

    switch (state) {
      case FbButtonState.loading:
      case FbButtonState.normal:
        return colorDistinguishedByButtonType();
      case FbButtonState.deactivated:
        return colorDistinguishedByButtonType().withOpacity(0.4);
      case FbButtonState.disabled:
        return AppTheme.of(context).fg.b60.withOpacity(0.4);
      case FbButtonState.completed:
        return AppTheme.of(context).fg.b60.withOpacity(0.8);
    }
  }

  @override
  Widget build(BuildContext context) {
    Widget child = buildLabelWidget(state, size, label);
    if (icon != null && state != FbButtonState.loading) {
      child = addIcon(child, icon!, placeIconAfterLabel, size);
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
        shape:
            ButtonStyleButton.allOrNull<OutlinedBorder>(RoundedRectangleBorder(
          borderRadius: BorderRadius.all(
            Radius.circular(borderRadius ??
                FbButtonTheme.of(context)?.borderRadius ??
                (buttonSize.height / (isOval ? 2 : 6))),
          ),
        )),
        foregroundColor: MaterialStateProperty.resolveWith(
            (states) => getForegroundColor(context, states)),
        overlayColor: MaterialStateProperty.resolveWith(
            (states) => getOverlayColor(state, states)),
        backgroundColor: MaterialStateProperty.resolveWith(
            (states) => getBackgroundColor(context, states)),
        textStyle: MaterialStateProperty.all(TextStyle(
            fontSize: getFontSize(size),
            fontWeight: FontWeight.w500,
            fontFamilyFallback: defaultFontFamilyFallback,
            color: AppTheme.of(context).fg.b100)),
      ),
      child: child,
    );
    child = constrain(child, size, widthUnlimited);
    return child;
  }

  BorderSide? getBorderSide(BuildContext context, Set<MaterialState> states) {
    Color colorDistinguishedByButtonType() {
      switch (type) {
        case _ButtonType.primary:
          return FbButtonTheme.of(context)?.primaryColor ??
              AppTheme.of(context).fg.blue1;
        case _ButtonType.secondary:
          return AppTheme.of(context).fg.b40;
        case _ButtonType.dangerous:
          return AppTheme.of(context).function.red1;
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
