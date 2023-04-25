import 'package:flutter/material.dart';
import 'package:lib_base/lib_base.dart';
import 'package:lib_theme/app_theme.dart';

/// - 描述：单选和多选的图标
///
/// - author: seven
/// - date: 2023/4/25 11:42
/// - 单选
Widget radioButton(double size, bool selected, BuildContext context) {
  return Container(
    height: size,
    width: size,
    decoration: BoxDecoration(
      color: selected
          ? AppTheme.of(context).fg.white1
          : AppTheme.of(context).bg.bg3,
      borderRadius: BorderRadius.all(Radius.circular(size / 2)),
      border: Border.all(
        width: selected ? 5 : 1,
        color: selected
            ? AppTheme.of(context).fg.blue1
            : AppTheme.of(context).fg.b30,
      ),
    ),
  );
}

/// - 多选
Widget checkBoxButton(double size, bool selected, BuildContext context) {
  return Container(
    height: size,
    width: size,
    decoration: BoxDecoration(
        color: selected
            ? AppTheme.of(context).fg.blue1
            : AppTheme.of(context).bg.bg3,
        borderRadius: BorderRadius.all(Radius.circular(selected ? 2 : 4)),
        border:
            !selected ? Border.all(color: AppTheme.of(context).fg.b30) : null),
    child: selected
        ? Icon(
            IconFont.buffDeviceSelected,
            color: AppTheme.of(context).fg.white1,
            size: size * 2 / 3,
          )
        : Container(),
  );
}
