import 'package:flutter/material.dart';
import 'package:lib_theme/lib_theme.dart';

double kBottomSheetDragTagHeight = 20;

class BottomSheetDragTag extends StatelessWidget {
  final Color? backgroundColor;
  final Color? dragTagColor;

  const BottomSheetDragTag({Key? key, this.backgroundColor, this.dragTagColor})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      color: backgroundColor ?? AppTheme.of(context).bg.bg3,
      height: kBottomSheetDragTagHeight,
      alignment: Alignment.center,
      child: Container(
        width: 36,
        height: 4,
        decoration: BoxDecoration(
            color: dragTagColor ?? AppTheme.of(context).fg.b10,
            borderRadius: const BorderRadius.all(Radius.circular(4))),
      ),
    );
  }
}
