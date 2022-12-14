import 'package:lib_ui/lib_ui.dart';
import 'package:lib_ui/src/fb_colors.dart';
import 'package:flutter/material.dart';

import 'fb_buttons_mixins.dart';

enum FbButtonState {
  normal,
  disabled,
  deactivated,
  completed,
  loading,
}
enum _FbTextButtonType {
  priamary,
  dangerous,
}

class FbTextButton extends StatelessWidget with FbButtonMixin {
  final _FbTextButtonType type;

  final String label;
  final VoidCallback? onTap;
  final VoidCallback? onLongPress;

  final FbButtonSize size;
  final FbButtonState state;

  const FbTextButton.primary(
    this.label, {
    required this.onTap,
    this.onLongPress,
    Key? key,
    this.size = FbButtonSize.small,
    this.state = FbButtonState.normal,
  })  : type = _FbTextButtonType.priamary,
        assert(state != FbButtonState.completed, "文字按钮没有完成态"),
        assert(state != FbButtonState.loading, "文字按钮没有加载态"),
        super(key: key);

  const FbTextButton.dangerous(
    this.label, {
    required this.onTap,
    this.onLongPress,
    Key? key,
    this.size = FbButtonSize.small,
    this.state = FbButtonState.normal,
  })  : type = _FbTextButtonType.dangerous,
        super(key: key);

  @override
  Widget build(BuildContext context) {
    Widget widget = TextButton(
      onPressed:
          state == FbButtonState.disabled || state == FbButtonState.deactivated
              ? null
              : onTap,
      onLongPress: onLongPress,
      style: ButtonStyle(
        backgroundColor: MaterialStateProperty.all(Colors.transparent),
        overlayColor: MaterialStateProperty.all(Colors.transparent),
        foregroundColor: MaterialStateProperty.resolveWith((states) =>
            getOverlayBackgroundColor(
                getForegroundColor(context, states), state, states)),
        splashFactory: NoSplash.splashFactory,
        padding: MaterialStateProperty.all(EdgeInsets.zero),
        textStyle: MaterialStateProperty.all(TextStyle(
          fontSize: size == FbButtonSize.small ? 14 : 16,
        )),
      ),
      child: Text(label),
    );
    return widget;
  }

  Color getForegroundColor(BuildContext context, Set<MaterialState> states) {
    final theme = fbTheme;

    Color colorDistinguishedByButtonType() {
      switch (type) {
        case _FbTextButtonType.priamary:
          return theme.primaryColor;
        case _FbTextButtonType.dangerous:
          return FbColors.destructiveRed;
      }
    }

    switch (state) {
      case FbButtonState.normal:
        return colorDistinguishedByButtonType();
      case FbButtonState.completed:
      case FbButtonState.loading:
        throw Exception("never be here");
      case FbButtonState.disabled:
        return theme.iconTheme.color!.withOpacity(0.4);
      case FbButtonState.deactivated:
        return colorDistinguishedByButtonType().withOpacity(0.4);
    }
  }
}
