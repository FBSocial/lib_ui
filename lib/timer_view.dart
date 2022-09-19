import 'dart:async';

import 'package:flutter/material.dart';

class TimerView extends StatefulWidget {
  final TextStyle? style;
  final String prefix;
  final DateTime? start;

  const TimerView({
    this.start,
    this.style,
    this.prefix = "",
    Key? key,
  }) : super(key: key);

  @override
  _TimerViewState createState() => _TimerViewState();
}

class _TimerViewState extends State<TimerView> {
  Timer? _timer;
  late DateTime _start;

  @override
  void initState() {
    _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      setState(() {});
    });
    _start = widget.start ?? DateTime.now();
    super.initState();
  }

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    var timer = DateTime.now().difference(_start).toString();
    timer = timer.substring(0, timer.length - 7);
    return Text(widget.prefix + timer, style: widget.style);
  }
}
