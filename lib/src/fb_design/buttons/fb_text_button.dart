import 'package:flutter/material.dart';
import 'package:lib_theme/app_theme.dart';
import 'package:lib_theme/lib_theme.dart';
import 'package:lib_ui/lib_ui.dart';

import 'fb_buttons_mixins.dart';

enum FbButtonState {
  normal,
  disabled,
  deactivated,
  completed,
  loading,
}

enum _FbTextButtonType {
  primary,
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
  })  : type = _FbTextButtonType.primary,
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
        minimumSize: MaterialStateProperty.all(Size.zero),
        visualDensity: const VisualDensity(horizontal: -4.0, vertical: -4.0),
        backgroundColor: MaterialStateProperty.all(Colors.transparent),
        overlayColor: MaterialStateProperty.all(Colors.transparent),
        foregroundColor: MaterialStateProperty.resolveWith((states) =>
            Color.alphaBlend(getOverlayColor(state, states),
                getForegroundColor(context, states))),
        splashFactory: NoSplash.splashFactory,
        padding: MaterialStateProperty.all(EdgeInsets.zero),
        textStyle: MaterialStateProperty.all(TextStyle(
          fontSize: size == FbButtonSize.small ? 14 : 16,
          fontWeight: FontWeight.w500,
        )),
      ),
      child: Text(label),
    );
    return widget;
  }

  Color getForegroundColor(BuildContext context, Set<MaterialState> states) {
    Color colorDistinguishedByButtonType() {
      switch (type) {
        case _FbTextButtonType.primary:
          return FbButtonTheme.of(context)?.primaryColor ??
              AppTheme.of(context).fg.blue1;
        case _FbTextButtonType.dangerous:
          return AppTheme.of(context).function.red1;
      }
    }

    switch (state) {
      case FbButtonState.normal:
        return colorDistinguishedByButtonType();
      case FbButtonState.completed:
      case FbButtonState.loading:
        throw Exception("never be here");
      case FbButtonState.disabled:
        return AppTheme.of(context).fg.b60;
      case FbButtonState.deactivated:
        return colorDistinguishedByButtonType().withOpacity(0.4);
    }
  }
}
