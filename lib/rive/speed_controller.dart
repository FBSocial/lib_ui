/*
 * @FilePath       : /social/lib/widgets/rive/speed_controller.dart
 * 
 * @Info           : Rive动画控制器：速度控制
 * 
 * @Author         : Whiskee Chan
 * @Date           : 2022-01-13 10:45:35
 * @Version        : 1.0.0
 * 
 * Copyright 2022 iDreamSky FanBook, All Rights Reserved.
 * 
 * @LastEditors    : Whiskee Chan
 * @LastEditTime   : 2022-01-13 15:57:52
 * 
 */

import 'package:rive/rive.dart';

class SpeedController extends SimpleAnimation {
  final double speedMultiplier;

  SpeedController(
    String animationName, {
    double mix = 1,
    bool autoplay = true,
    this.speedMultiplier = 1,
  }) : super(animationName, mix: mix, autoplay: autoplay);

  @override
  void apply(RuntimeArtboard artboard, double elapsedSeconds) {
    if (instance == null) {
      return;
    }
    if (instance == null || !instance!.keepGoing) {
      isActive = false;
    }
    instance!
      ..animation.apply(instance!.time, coreContext: artboard, mix: mix)
      ..advance(elapsedSeconds * speedMultiplier);
  }
}