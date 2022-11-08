import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
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
    final theme = Theme.of(context);
    return GestureDetector(
      onTap: () {
        Clipboard.setData(ClipboardData(text: username));
        showToast("#号已复制".tr);
        copyClickCallback?.call();
      },
      child: Row(
        children: [
          Text(
            '#$username',
            style: theme.textTheme.bodyText1!.copyWith(
              fontSize: OrientationUtil.portrait ? 13 : 12,
              height: 1.25,
              color: theme.disabledColor,
            ),
          ),
          const SizedBox(width: 4),
          Icon(
            IconFont.copy,
            size: OrientationUtil.portrait ? 16 : 12,
            color: theme.disabledColor.withOpacity(0.7),
          ),
        ],
      ),
    );
  }
}
