import 'dart:async';

import 'package:flutter/material.dart';
import 'package:video_player/video_player.dart';

/// 一个平滑过渡的视频进度条，不带样式，可以通过 [SliderTheme] 设置样式
class UnStyledVideoProgressSlider extends StatefulWidget {
  final VideoPlayerController controller;
  final void Function(double)? onChangeStart;
  final void Function(double)? onChangeEnd;
  final void Function(double)? onChanged;

  const UnStyledVideoProgressSlider(
    this.controller, {
    Key? key,
    this.onChangeStart,
    this.onChangeEnd,
    this.onChanged,
  }) : super(key: key);

  @override
  State<UnStyledVideoProgressSlider> createState() =>
      _UnStyledVideoProgressSliderState();
}

class _UnStyledVideoProgressSliderState
    extends State<UnStyledVideoProgressSlider> {
  bool _dragging = false;
  double _progress = 0;
  Timer? _timer;

  @override
  void initState() {
    _progress = widget.controller.value.position.inMilliseconds.toDouble();

    const kFps = 16;
    double lastPosition = _progress;
    _timer = Timer.periodic(const Duration(milliseconds: kFps), (timer) {
      final videoValue = widget.controller.value;
      final nowPosition = videoValue.position.inMilliseconds.toDouble();
      if (_dragging) return;
      if (videoValue.isPlaying == false) return;

      if (nowPosition < lastPosition) {
        // 如果发生重播，需要重置进度条
        _progress = nowPosition.toDouble();
      }
      lastPosition = nowPosition.toDouble();

      setState(() {
        // 匀速滑动
        _progress = _progress + kFps;
      });
    });
    super.initState();
  }

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final max = widget.controller.value.duration.inMilliseconds.toDouble();
    return Slider(
      value: _progress.clamp(0, max),
      max: max,
      onChangeStart: (v) {
        _dragging = true;
        widget.onChangeStart?.call(v);
        setState(() {
          _progress = v;
        });
      },
      onChangeEnd: (v) async {
        _dragging = false;
        widget.onChangeEnd?.call(v);
        await widget.controller.seekTo(Duration(milliseconds: v.toInt()));
      },
      onChanged: (v) {
        widget.onChanged?.call(v);
        setState(() {
          _progress = v;
        });
      },
    );
  }
}

class RoundedVideoSliderTrackShape extends RoundedRectSliderTrackShape {
  @override
  void paint(
    PaintingContext context,
    Offset offset, {
    required RenderBox parentBox,
    required SliderThemeData sliderTheme,
    required Animation<double> enableAnimation,
    required TextDirection textDirection,
    required Offset thumbCenter,
    Offset? secondaryOffset,
    bool isDiscrete = false,
    bool isEnabled = false,
    double additionalActiveTrackHeight = 2,
  }) {
    super.paint(context, offset,
        parentBox: parentBox,
        sliderTheme: sliderTheme,
        enableAnimation: enableAnimation,
        textDirection: textDirection,
        thumbCenter: thumbCenter,
        isDiscrete: isDiscrete,
        isEnabled: isEnabled,
        additionalActiveTrackHeight: 0);
  }

  @override
  Rect getPreferredRect({
    required RenderBox parentBox,
    Offset offset = Offset.zero,
    required SliderThemeData sliderTheme,
    bool isEnabled = false,
    bool isDiscrete = false,
  }) {
    final double trackHeight = sliderTheme.trackHeight!;
    final double trackLeft = offset.dx;
    final double trackTop =
        offset.dy + (parentBox.size.height - trackHeight) / 2;
    final double trackWidth = parentBox.size.width;
    return Rect.fromLTWH(trackLeft, trackTop, trackWidth, trackHeight);
  }
}
