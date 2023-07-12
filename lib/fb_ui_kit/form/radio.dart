import 'package:flutter/material.dart';
import 'package:lib_base/icon_font/icon_font.dart';
import 'package:lib_theme/lib_theme.dart';

class FbRadio extends StatelessWidget {
  final bool selected;
  final double size;

  const FbRadio({super.key, required this.selected, this.size = 20});

  @override
  Widget build(BuildContext context) {
    final theme = AppTheme.of(context);
    if (selected) {
      return Icon(
        IconFont.buffSelectSingle,
        color: theme.fg.blue1,
        size: size,
      );
    }
    return Icon(
      IconFont.buffUnselectSingle,
      color: theme.fg.b30,
      size: 20,
    );
  }
}
