import 'dart:async';

import 'package:flutter/cupertino.dart';

class LoadingText extends StatefulWidget {
  final TextStyle? style;
  final String? text;

  @override
  _LoadingTextState createState() => _LoadingTextState();

  const LoadingText({
    this.text,
    this.style,
    Key? key,
  }) : super(key: key);
}

class _LoadingTextState extends State<LoadingText> {
  late Timer timer;
  ValueNotifier<int> tick = ValueNotifier(0);

  @override
  void initState() {
    timer = Timer.periodic(const Duration(milliseconds: 500), (_) {
      tick.value = timer.tick;
    });
    super.initState();
  }

  @override
  void dispose() {
    timer.cancel();
    tick.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Text(widget.text!, style: widget.style),
        ValueListenableBuilder<int>(
            valueListenable: tick,
            builder: (context, tick, child) {
              return Text(List.generate(1 + (tick % 3), (_) => ".").join(),
                  style: widget.style);
            }),
      ],
    );
  }
}
