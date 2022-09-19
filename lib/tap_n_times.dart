import 'dart:async';
import 'dart:math';

import 'package:flutter/material.dart';

class TapNTimes extends StatefulWidget {
  final Widget? child;
  final int? times;

  final VoidCallback? onFinish;

  const TapNTimes({
    this.child,
    this.times,
    this.onFinish,
    Key? key,
  }) : super(key: key);

  @override
  _TapNTimesState createState() => _TapNTimesState();
}

class _TapNTimesState extends State<TapNTimes> {
  int counter = 0;
  Timer? timer;

  @override
  void initState() {
    counter = 0;
    super.initState();
  }

  @override
  void dispose() {
    timer?.cancel();
    timer = null;
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
        onTap: () {
          timer ??= Timer(Duration(seconds: max(widget.times! ~/ 3, 1)), () {
            counter = 0;
            timer!.cancel();
            timer = null;
          });
          if (++counter >= widget.times!) {
            widget.onFinish!();
          }
        },
        child: widget.child);
  }
}
