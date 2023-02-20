import 'package:flutter/material.dart';

typedef FadeBuilder = Widget Function(BuildContext, double);

////////////////////////////////////////////////////////////////////////////////////////////////////

class AnimationFadeWrapper extends StatefulWidget {
  // final FadeBuilder builder;
  final FadeBuilder? builder;

  const AnimationFadeWrapper({
    this.builder,
    Key? key,
  }) : super(key: key);

  @override
  _AnimationFadeWrapperState createState() => _AnimationFadeWrapperState();
}

////////////////////////////////////////////////////////////////////////////////////////////////////

class _AnimationFadeWrapperState extends State<AnimationFadeWrapper> {
  double opacity = 0;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (mounted) {
        setState(() {
          opacity = 0;
        });
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return widget.builder!(context, opacity);
  }
}
