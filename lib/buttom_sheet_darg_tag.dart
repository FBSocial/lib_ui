import 'package:flutter/material.dart';

class BottomSheetDragTag extends StatelessWidget {
  const BottomSheetDragTag({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Container(
        margin: const EdgeInsets.fromLTRB(0, 8, 0, 8),
        width: 36,
        height: 4,
        decoration: BoxDecoration(
            color: Theme.of(context).textTheme.bodyText1!.color!.withOpacity(0.2),
            borderRadius: const BorderRadius.all(Radius.circular(4))),
      ),
    );
  }
}
