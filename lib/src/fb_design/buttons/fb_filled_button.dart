import 'package:flutter/material.dart';
import 'package:lib_ui/lib_ui.dart';
import 'package:lib_ui/src/fb_colors.dart';

import 'fb_buttons_mixins.dart';

enum _ButtonType {
  primary,
  secondary,
  tertiary,
  quaternary,
  dangerous,
}

class FbFilledButton extends StatelessWidget with FbButtonMixin {
  final VoidCallback? onTap;
  final VoidCallback? onLongPress;
  final String label;
  final IconData? icon;
  final FbButtonSize size;
  final _ButtonType type;
  final FbButtonState state;

  const FbFilledButton.primary(
    this.label, {
    this.icon,
    required this.onTap,
    this.onLongPress,
    this.state = FbButtonState.normal,
    this.size = FbButtonSize.small,
    Key? key,
  })  : type = _ButtonType.primary,
        super(key: key);

  const FbFilledButton.secondary(
    this.label, {
    this.icon,
    required this.onTap,
    this.onLongPress,
    this.state = FbButtonState.normal,
    this.size = FbButtonSize.small,
    Key? key,
  })  : type = _ButtonType.secondary,
        super(key: key);

  const FbFilledButton.tertiary(
    this.label, {
    this.icon,
    required this.onTap,
    this.onLongPress,
    this.state = FbButtonState.normal,
    this.size = FbButtonSize.small,
    Key? key,
  })  : type = _ButtonType.tertiary,
        super(key: key);

  const FbFilledButton.quaternary(
    this.label, {
    this.icon,
    required this.onTap,
    this.onLongPress,
    this.state = FbButtonState.normal,
    this.size = FbButtonSize.small,
    Key? key,
  })  : type = _ButtonType.quaternary,
        super(key: key);

  const FbFilledButton.dangerous(
    this.label, {
    required this.onTap,
    this.onLongPress,
    this.state = FbButtonState.normal,
    this.size = FbButtonSize.small,
    Key? key,
  })  : type = _ButtonType.dangerous,
        icon = null,
        super(key: key);

  @override
  Widget build(BuildContext context) {
    Widget child = buildLabelWidget(state, label);
    if (icon != null && state != FbButtonState.loading) {
      child = addLeadingIcon(child, icon!, size);
    }
    child = ElevatedButton(
      onPressed: wrapTapCallback(onTap, state),
      onLongPress: wrapTapCallback(onLongPress, state),
      style: ButtonStyle(
        elevation: MaterialStateProperty.all(0),
        animationDuration: Duration.zero,
        splashFactory: NoSplash.splashFactory,
        foregroundColor: MaterialStateProperty.resolveWith((states) =>
            getOverlayForegroundColor(
                getForegroundColor(context, states), state, states)),
        // 不知为何，直接使用 overlayColor 对于 pressed 无效，所以和 backgroundColor 进行叠加
        backgroundColor: MaterialStateProperty.resolveWith((states) =>
            getOverlayBackgroundColor(
                getBackgroundColor(context, states), state, states)),
        // overlayColor: MaterialStateProperty.resolveWith(getOverlayColor),
        padding: MaterialStateProperty.all(EdgeInsets.zero),
        textStyle: MaterialStateProperty.all(TextStyle(
          fontSize: getFontSize(size),
          fontWeight: FontWeight.w500,
        )),
      ),
      child: child,
    );
    child = constrain(child, size);
    return child;
  }

  Color getForegroundColor(BuildContext context, Set<MaterialState> states) {
    final theme = Theme.of(context);

    Color colorDistinguishedByButtonType() {
      switch (type) {
        case _ButtonType.primary:
          return Colors.white;
        case _ButtonType.tertiary:
          return theme.textTheme.bodyText2!.color!;
        case _ButtonType.secondary:
        case _ButtonType.quaternary:
          return theme.primaryColor;
        case _ButtonType.dangerous:
          return Colors.white;
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
        return theme.colorScheme.onSurface.withOpacity(0.4);
      case FbButtonState.completed:
        return theme.colorScheme.onSurface.withOpacity(0.8);
      case FbButtonState.deactivated:
        return colorDistinguishedByButtonType().withOpacity(0.7);
    }
  }

  Color getBackgroundColor(BuildContext context, Set<MaterialState> states) {
    final theme = Theme.of(context);

    Color colorDistinguishedByButtonType() {
      switch (type) {
        case _ButtonType.primary:
          return theme.primaryColor;
        case _ButtonType.secondary:
        case _ButtonType.tertiary:
          return theme.colorScheme.onSecondary.withOpacity(0.1);
        case _ButtonType.quaternary:
          return theme.primaryColor.withOpacity(0.1);
        case _ButtonType.dangerous:
          return FbColors.destructiveRed;
      }
    }

    switch (state) {
      case FbButtonState.normal:
        if (states.contains(MaterialState.pressed)) {
          return colorDistinguishedByButtonType().withOpacity(0.8);
        } else {
          return colorDistinguishedByButtonType();
        }
      case FbButtonState.loading:
        return colorDistinguishedByButtonType();
      case FbButtonState.disabled:
      case FbButtonState.completed:
        return theme.colorScheme.onSecondary.withOpacity(0.1);
      case FbButtonState.deactivated:
        final color = colorDistinguishedByButtonType();
        // 禁用态有些特殊，次按钮的背景色是 0.1，其他类型按钮的背景色是 0.4 透明度
        if (type == _ButtonType.secondary || type == _ButtonType.tertiary) {
          return color.withOpacity(0.1);
        } else {
          return color.withOpacity(0.4);
        }
    }
  }
}
