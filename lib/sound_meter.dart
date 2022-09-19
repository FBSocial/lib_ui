import 'package:flutter/material.dart';

import 'icon_font.dart';

class SoundMic extends StatefulWidget {
  final Color? color;
  final double? size;

  const SoundMic(
    this.color, {
    this.size,
    Key? key,
  }) : super(key: key);

  @override
  _SoundMicState createState() => _SoundMicState();
}

class _SoundMicState extends State<SoundMic> {
  // StreamSubscription<NoiseReading> _noiseSubscription;
  final int _height = 0;
  final _round1 = const BorderRadius.vertical(bottom: Radius.circular(6));
  final _round2 = BorderRadius.circular(6);

  @override
  Widget build(BuildContext context) {
    final bgColor = Theme.of(context).primaryColor;
    return Center(
      child: Stack(
        children: <Widget>[
          Icon(
            IconFont.moduleMic,
            color: widget.color,
            size: widget.size,
          ),
          Positioned(
            bottom: 10,
            left: 9,
            child: Container(
              decoration: BoxDecoration(
                borderRadius: _height < 10 ? _round1 : _round2,
                color: bgColor,
              ),
              width: 6,
              height: _height * 1.0,
            ),
          ),
        ],
      ),
    );
  }
}
