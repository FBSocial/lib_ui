import 'package:flutter/material.dart';

typedef OffsetBuilder = Widget Function(BuildContext, Offset, double);

////////////////////////////////////////////////////////////////////////////////////////////////////

class AnimationOffsetWrapper extends StatefulWidget {
  // final FadeBuilder builder;
  final OffsetBuilder? builder;

  const AnimationOffsetWrapper({
    this.builder,
    Key? key,
  }) : super(key: key);

  @override
  _AnimationOffsetWrapperState createState() => _AnimationOffsetWrapperState();
}

////////////////////////////////////////////////////////////////////////////////////////////////////

class _AnimationOffsetWrapperState extends State<AnimationOffsetWrapper> {
  double opacity = 0;
  Offset offset = const Offset(0, 20);

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (mounted) {
        setState(() {
          offset = Offset.zero;
          opacity = 1;
        });
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return widget.builder!(context, offset, opacity);
  }
}
