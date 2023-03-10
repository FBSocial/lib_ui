import 'package:flutter/material.dart';
import 'package:lib_theme/lib_theme.dart';

double kBottomSheetDragTagHeight = 20;

class BottomSheetDragTag extends StatelessWidget {
  final Color? backgroundColor;

  const BottomSheetDragTag({Key? key, this.backgroundColor}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      color: backgroundColor ?? AppTheme.of(context).bg.bg2,
      height: kBottomSheetDragTagHeight,
      alignment: Alignment.center,
      child: Container(
        width: 36,
        height: 4,
        decoration: BoxDecoration(
            color: AppTheme.of(context).fg.b10,
            borderRadius: const BorderRadius.all(Radius.circular(4))),
      ),
    );
  }
}
