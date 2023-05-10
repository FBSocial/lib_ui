/*
 * @FilePath       : \social\lib\core\widgets\button\base_button.dart
 * 
 * @Info           : 
 * 
 * @Author         : Whiskee Chan
 * @Date           : 2021-12-06 16:49:02
 * @Version        : 1.0.0
 * 
 * Copyright 2021 iDreamSky FanBook, All Rights Reserved.
 * 
 * @LastEditors    : Whiskee Chan
 * @LastEditTime   : 2021-12-20 15:59:08
 * 
 */
import 'package:flutter/material.dart';
import 'package:just_throttle_it/just_throttle_it.dart';

class BaseButton extends StatefulWidget {
  final VoidCallback? onTap;
  final VoidCallback? onLongPress;
  final Widget? child;
  final Duration throttleDuration;

  const BaseButton({
    Key? key,
    this.onTap,
    this.onLongPress,
    required this.child,
    this.throttleDuration = const Duration(milliseconds: 300),
  }) : super(key: key);

  @override
  BaseButtonState createState() => BaseButtonState();
}

class BaseButtonState<T extends BaseButton> extends State<T> {
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      behavior: HitTestBehavior.translucent,
      onTap: widget.onTap == null ? null : onTap,
      onLongPress: widget.onLongPress == null ? null : onLongPress,
      child: widget.child,
    );
  }

  void onTap() {
    if (widget.onTap == null) return;
    Throttle.duration(widget.throttleDuration, widget.onTap!);
  }

  void onLongPress() {
    if (widget.onLongPress == null) return;
    Throttle.duration(widget.throttleDuration, widget.onLongPress!);
  }

  @override
  void dispose() {
    if (widget.onTap != null) Throttle.clear(widget.onTap!);
    super.dispose();
  }
}
