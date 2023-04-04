import 'package:flutter/material.dart';

double kBottomSheetDragTagHeight = 20;

class BottomSheetDragTag extends StatelessWidget {
  const BottomSheetDragTag({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      height: kBottomSheetDragTagHeight,
      alignment: Alignment.center,
      child: Container(
        width: 36,
        height: 4,
        decoration: BoxDecoration(
            color:
                Theme.of(context).textTheme.bodyLarge!.color!.withOpacity(0.2),
            borderRadius: const BorderRadius.all(Radius.circular(4))),
      ),
    );
  }
}
