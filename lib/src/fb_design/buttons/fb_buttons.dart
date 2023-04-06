export 'fb_filled_button.dart';
export 'fb_outlined_button.dart';
export 'fb_text_button.dart';

enum FbButtonSize {
  mini,
  small,
  medium,
  large,
}

extension FbButtonSizeX on FbButtonSize {
  bool canLoading() {
    return this != FbButtonSize.mini && this != FbButtonSize.small;
  }

  double get gapOfIconAndText {
    switch (this) {
      case FbButtonSize.mini:
        return 2;
      case FbButtonSize.small:
        return 4;
      case FbButtonSize.medium:
        return 6;
      case FbButtonSize.large:
        return 8;
    }
  }

  double get loadingIconThickness {
    switch (this) {
      case FbButtonSize.mini:
        return 1.16;
      case FbButtonSize.small:
        return 1.35;
      case FbButtonSize.medium:
        return 1.35;
      case FbButtonSize.large:
        return 1.5;
    }
  }
}
