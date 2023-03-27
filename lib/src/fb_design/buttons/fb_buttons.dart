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
}
