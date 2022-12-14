import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class CountShowWidget extends StatelessWidget {
  final int currentCount;
  final int allCount;
  final IconData? prefix;

  final Color? color;
  final Color? backgroundColor;

  const CountShowWidget(
    this.currentCount,
    this.allCount, {
    Key? key,
    this.prefix,
    this.color,
    this.backgroundColor,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 16,
      alignment: Alignment.center,
      padding: const EdgeInsets.symmetric(horizontal: 5),
      decoration: ShapeDecoration(
        shape: const StadiumBorder(),
        color: backgroundColor,
      ),
      child: Row(
        children: [
          if (prefix != null)
            Padding(
              padding: const EdgeInsets.only(right: 2.0),
              child: Icon(
                prefix,
                size: 12,
                color: color,
              ),
            ),
          Text(
            allCount == -1 ? "$currentCount" : "$currentCount/$allCount",
            textAlign: TextAlign.center,
            style: TextStyle(
              fontSize: 10,
              height: 1.1,
              color: color,
              fontWeight: FontWeight.w500,
            ),
          ),
        ],
      ),
    );
  }
}
