import 'dart:ui';

abstract class VideoPlayerEventTracker {
  void onPause();

  void onResume(bool autoPlay, Size size);

  void onSeek(double progressInMs);

  void onEnterFullscreen();

  void onExitFullscreen();
}
