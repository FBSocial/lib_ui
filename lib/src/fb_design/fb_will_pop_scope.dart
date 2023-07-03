import 'dart:io';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:lib_fb_utils/system_permissions/show_confirm_popup.dart';
import 'package:lib_theme/lib_theme.dart';

const _iosSwipeSensitivity = 6;

/// 与 [WillPopScope] 不同的是，在 iOS 设备上，如果内容没有更改，依然可以手势侧滑返回路由
/// 并且保留原有的用户交互体验；如果内容更改了，在试图侧滑时会让用户确认
///
/// 这种做法并不太符合 iOS 的交互规范，能不使用尽量不使用。
class FbWillPopScope extends StatelessWidget {
  final bool enabled;
  final String tips;
  final Widget child;

  const FbWillPopScope({
    super.key,
    required this.child,
    this.enabled = true,
    this.tips = '退出后将撤销本次设置，确定退出吗？',
  });

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      child: GestureDetector(
        child: child,
        onHorizontalDragUpdate: enabled && Platform.isIOS
            ? (details) async {
                if (details.delta.dx > _iosSwipeSensitivity &&
                    await waitUserConfirm()) {
                  Get.back();
                }
              }
            : null,
      ),
      onWillPop: enabled
          ? () async {
              if (await waitUserConfirm()) {
                Get.back();
              }
              return false;
            }
          : null,
    );
  }

  Future<bool> waitUserConfirm() async {
    return showConfirmPopup(
      title: '退出后将撤销本次设置，确定退出吗？'.tr,
      confirmText: '确定'.tr,
      confirmStyle: TextStyle(
        fontSize: 16,
        color: AppTheme.of(Get.context!).fg.blue1,
      ),
    ).then((v) => v == true);
  }
}
