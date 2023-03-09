import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:lib_theme/app_theme.dart';
import 'package:lib_theme/const.dart';
import 'package:lib_utils/orientation_util.dart';
import 'package:oktoast/oktoast.dart';

import 'icon_font.dart';

class IdWithCopy extends StatelessWidget {
  final String? username;
  final VoidCallback? copyClickCallback;

  const IdWithCopy(this.username, {Key? key, this.copyClickCallback})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        Clipboard.setData(ClipboardData(text: username));
        showToast("复制成功".tr);
        copyClickCallback?.call();
      },
      child: Row(
        children: [
          Text(
            '#$username',
            style: TextStyle(
              color: AppTheme.of(context).fg.b60,
              fontWeight: FontWeight.normal,
              fontFamilyFallback: defaultFontFamilyFallback,
              fontSize: OrientationUtil.portrait ? 13 : 12,
              height: 1.25,
            ),
          ),
          const SizedBox(width: 4),
          Icon(
            IconFont.copy,
            size: OrientationUtil.portrait ? 16 : 12,
            color: AppTheme.of(context).fg.b40,
          ),
        ],
      ),
    );
  }
}

class IdWithButtonCopy extends StatelessWidget {
  final String? username;
  final VoidCallback? copyClickCallback;

  const IdWithButtonCopy(this.username, {Key? key, this.copyClickCallback})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        Clipboard.setData(ClipboardData(text: username));
        showToast("复制成功".tr);
        copyClickCallback?.call();
      },
      child: Row(
        children: [
          Text(
            'ID: $username',
            style: TextStyle(
              color: AppTheme.of(context).fg.b60,
              fontWeight: FontWeight.normal,
              fontFamilyFallback: defaultFontFamilyFallback,
              fontSize: OrientationUtil.portrait ? 13 : 12,
              height: 1.25,
            ),
          ),
          const SizedBox(width: 4),
          Container(
            width: 32,
            height: 16,
            decoration: BoxDecoration(
              color: const Color(0xFF1A2033).withOpacity(0.05),
              borderRadius: const BorderRadius.all(Radius.circular(3)),
            ),
            // alignment: Alignment.center,
            child: Center(
              child: Text(
                '复制'.tr,
                style: TextStyle(
                  fontSize: 10,
                  fontWeight: FontWeight.w500,
                  color: AppTheme.of(context).fg.b60,
                ),
                strutStyle: const StrutStyle(
                  fontSize: 10,
                  leading: 0,
                  height: 1.1, // 1.1更居中
                  forceStrutHeight: true,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
