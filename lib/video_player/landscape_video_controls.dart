import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:lib_ui/button/fade_button.dart';
import 'package:lib_ui/video_player/unstyled_video_progress_slider.dart';
import 'package:lib_ui/video_player/video_player_event_tracker.dart';
import 'package:simple_shadow/simple_shadow.dart';
import 'package:video_player/video_player.dart';

import '../icon_font.dart';

class LandscapeVideoControls extends StatefulWidget {
  final VideoPlayerController controller;
  final VideoPlayerEventTracker? eventTracker;

  const LandscapeVideoControls(this.controller, {Key? key, this.eventTracker})
      : super(key: key);

  @override
  State<LandscapeVideoControls> createState() => _LandscapeVideoControlsState();
}

class _LandscapeVideoControlsState extends State<LandscapeVideoControls>
    with SingleTickerProviderStateMixin {
  late ValueNotifier<bool> _isPlaying;
  bool _showControls = true;
  Timer? _hideControlsTimer;
  late Duration _videoProgress;

  // animations
  late AnimationController _controlsFadeAnimation;
  late Animation<double> _opacityAnimation;

  @override
  void initState() {
    widget.eventTracker?.onEnterFullscreen();

    _isPlaying = ValueNotifier(widget.controller.value.isPlaying);
    _videoProgress = widget.controller.value.position;
    widget.controller.addListener(_updateVideoProgress);

    // animations
    _controlsFadeAnimation = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 500),
    );
    _controlsFadeAnimation.value = 1;
    _opacityAnimation = CurvedAnimation(
      parent: _controlsFadeAnimation,
      curve: Curves.easeInOut,
    );

    // 刚进入横屏模式，会显示控制栏，5秒后自动隐藏
    _startHideControlsCountdown();

    SystemChrome.setEnabledSystemUIMode(SystemUiMode.manual, overlays: []);
    super.initState();
  }

  @override
  void dispose() {
    widget.eventTracker?.onExitFullscreen();

    SystemChrome.setPreferredOrientations([
      DeviceOrientation.portraitUp,
      DeviceOrientation.portraitDown,
    ]);
    _controlsFadeAnimation.dispose();
    _isPlaying.dispose();
    widget.controller.removeListener(_updateVideoProgress);
    _hideControlsTimer!.cancel();
    SystemChrome.setEnabledSystemUIMode(SystemUiMode.manual,
        overlays: SystemUiOverlay.values);
    super.dispose();
  }

  _updateVideoProgress() {
    setState(() {
      _videoProgress = widget.controller.value.position;
    });
  }

  _startHideControlsCountdown() {
    _hideControlsTimer?.cancel();
    _hideControlsTimer = Timer(const Duration(seconds: 5), () {
      if (mounted) {
        setState(() {
          _showControls = false;
          _controlsFadeAnimation.reverse();
        });
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final mq = MediaQuery.of(context);
    return GestureDetector(
      behavior: HitTestBehavior.translucent,
      onTap: () {
        setState(() {
          _showControls = !_showControls;
        });
        if (_showControls) {
          _startHideControlsCountdown();
          _controlsFadeAnimation.forward();
        } else {
          _hideControlsTimer?.cancel();
          _controlsFadeAnimation.reverse();
        }
      },
      child: Stack(
        fit: StackFit.expand,
        alignment: Alignment.center,
        children: [
          Positioned(
              top: 0,
              left: 0,
              right: 0,
              height: 64 + mq.viewPadding.top,
              child: DecoratedBox(
                  decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                  colors: [
                    Colors.black.withOpacity(0.2),
                    Colors.black.withOpacity(0)
                  ],
                ),
              ))),
          Positioned(
              bottom: 0,
              left: 0,
              right: 0,
              height: 43 + mq.viewPadding.bottom,
              child: DecoratedBox(
                  decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                  colors: [
                    Colors.black.withOpacity(0),
                    Colors.black.withOpacity(.2),
                  ],
                ),
              ))),
          // 屏幕中心的播放按钮
          ValueListenableBuilder<bool>(
              valueListenable: _isPlaying,
              builder: (context, playing, child) =>
                  Visibility(visible: !playing, child: child!),
              child: UnconstrainedBox(
                child: FadeButton(
                  onTap: _togglePlay,
                  child: const Icon(
                    IconFont.play,
                    size: 50,
                    color: Colors.white,
                  ),
                ),
              )),

          Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              // status bar and app bar
              FadeTransition(
                opacity: _opacityAnimation,
                child: Column(
                  children: [
                    const SizedBox(height: 14),
                    SizedBox(
                      height: 44,
                      child: Padding(
                        padding: mq.viewPadding,
                        child: Row(
                          children: [
                            FadeButton(
                              padding: const EdgeInsets.symmetric(
                                  horizontal: 16, vertical: 10),
                              child: SimpleShadow(
                                sigma: 12,
                                color: Colors.black,
                                opacity: 0.1,
                                child: const Icon(
                                  IconFont.navBarBackItem,
                                  size: 24,
                                  color: Colors.white,
                                ),
                              ),
                              onTap: () {
                                SystemChrome.setPreferredOrientations([
                                  DeviceOrientation.portraitUp,
                                  DeviceOrientation.portraitDown,
                                ]);
                              },
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              // status bar

              const Spacer(),
              // 底部的控制栏
              FadeTransition(
                opacity: _opacityAnimation,
                child: Padding(
                  padding: mq.viewPadding,
                  child: Row(
                    children: [
                      // 播放/暂停按钮
                      ValueListenableBuilder<bool>(
                          valueListenable: _isPlaying,
                          builder: (context, isPlaying, child) {
                            return FadeButton(
                              onTap: _togglePlay,
                              child: Padding(
                                padding:
                                    const EdgeInsets.fromLTRB(16, 12, 12, 12),
                                child: Icon(
                                  isPlaying ? IconFont.pause : IconFont.play,
                                  color: Colors.white,
                                  size: 24,
                                ),
                              ),
                            );
                          }),
                      // 当前播放进度
                      Container(
                        width: 30 + 12,
                        alignment: Alignment.centerLeft,
                        child: Text(
                          _formatDuration(_videoProgress),
                          style: const TextStyle(
                              color: Colors.white,
                              fontSize: 12,
                              fontWeight: FontWeight.w500),
                        ),
                      ),
                      // 进度调整 Slider
                      Expanded(
                          child: SliderTheme(
                        data: const SliderThemeData().copyWith(
                          trackShape: RoundedVideoSliderTrackShape(),
                          trackHeight: 2,
                          thumbColor: const Color.fromRGBO(255, 255, 255, 1),
                          thumbShape: const RoundSliderThumbShape(
                            disabledThumbRadius: 4,
                            enabledThumbRadius: 4,
                            elevation: 0,
                            pressedElevation: 0,
                          ),
                          overlayColor: Colors.transparent,
                          activeTrackColor: Colors.white.withOpacity(0.4),
                          inactiveTrackColor: Colors.white.withOpacity(0.2),
                        ),
                        child: UnStyledVideoProgressSlider(
                          widget.controller,
                          onChangeStart: (_) {
                            _hideControlsTimer?.cancel();
                          },
                          onChangeEnd: (v) {
                            _startHideControlsCountdown();
                            widget.eventTracker?.onSeek(v);
                          },
                        ),
                      )),
                      // 视频总时长
                      Container(
                        width: 30 + 12,
                        alignment: Alignment.centerRight,
                        child: Text(
                          _formatDuration(widget.controller.value.duration),
                          style: const TextStyle(
                              color: Colors.white,
                              fontSize: 12,
                              fontWeight: FontWeight.w500),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  void _togglePlay() {
    _startHideControlsCountdown();

    if (widget.controller.value.isPlaying) {
      _isPlaying.value = false;
      widget.controller.pause();
      widget.eventTracker?.onPause();
    } else {
      _isPlaying.value = true;
      widget.controller.play();
      widget.eventTracker?.onResume(false, widget.controller.value.size);
    }
  }

  String _formatDuration(Duration duration) {
    return "${duration.inMinutes.toString().padLeft(2, '0')}:${duration.inSeconds.remainder(60).toString().padLeft(2, '0')}";
  }
}
