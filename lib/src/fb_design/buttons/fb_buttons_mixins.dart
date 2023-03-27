import 'package:flutter/material.dart';
import 'package:lib_ui/lib_ui.dart';

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

  Widget buildLabelWidget(FbButtonState state, String label) {
    if (state == FbButtonState.loading) {
      return Builder(builder: (context) {
        final color = DefaultTextStyle.of(context).style.color!;
        return FbLoadingIndicator(
          size: 16,
          strokeWidth: 1.33,
          color: color,
        );
      });
    } else {
      return Text(label);
    }
  }

  Size getButtonSize(FbButtonSize size) {
    switch (size) {
      case FbButtonSize.mini:
        return const Size(48, 24);

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

  Color? getOverlayForegroundColor(
    Color color,
    FbButtonState state,
    Set<MaterialState> states,
  ) {
    // 完成态不需要任何交互态
    if (state == FbButtonState.completed) return color;

    if (states.contains(MaterialState.pressed)) {
      return Color.alphaBlend(Colors.black.withOpacity(0.15), color);
    }
    if (states.contains(MaterialState.hovered)) {
      return Color.alphaBlend(Colors.white.withOpacity(0.15), color);
    }
    return color;
  }

  Color? getOverlayBackgroundColor(
      Color color, FbButtonState state, Set<MaterialState> states) {
    // 完成态不需要任何交互态
    if (state == FbButtonState.completed) return color;

    if (states.contains(MaterialState.pressed)) {
      return Color.alphaBlend(Colors.black.withOpacity(0.15), color);
    }
    if (states.contains(MaterialState.hovered)) {
      return Color.alphaBlend(Colors.white.withOpacity(0.15), color);
    }
    return color;
  }

  Widget addLeadingIcon(Widget label, IconData icon, FbButtonSize size) {
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
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Icon(icon, size: iconSize),
        SizedBox(width: space),
        label,
      ],
    );
  }
}
