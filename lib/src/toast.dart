import 'package:flutter/material.dart';
import 'package:oktoast/oktoast.dart';

import 'fb_colors.dart';
import 'icon_font.dart';

enum ToastIcon {
  success,
}

class Toast {
  static void text(String text) {
    showToast(text);
  }

  static void iconToast({
    required ToastIcon icon,
    required String label,
    Color? iconColor,
    bool? dismissOtherToast,
  }) {
    IconData iconData;
    Color iconColor;
    switch (icon) {
      case ToastIcon.success:
        iconColor = FbColors.successColor;
        iconData = IconFont.success;
        break;
    }
    customIconToast(
        icon: iconData,
        label: label,
        iconColor: iconColor,
        dismissOtherToast: dismissOtherToast);
  }

  static void customIconToast({
    required IconData icon,
    required String label,
    Color? iconColor,
    bool? dismissOtherToast,
  }) {
    showToastWidget(_IconToast(icon: icon, label: label, iconColor: iconColor),
        dismissOtherToast: dismissOtherToast);
  }
}

class _IconToast extends StatelessWidget {
  final IconData icon;
  final String label;
  final Color? iconColor;

  const _IconToast({
    required this.icon,
    required this.label,
    this.iconColor,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
      decoration: BoxDecoration(
        color: Theme.of(context).textTheme.bodyText2!.color!.withOpacity(0.95),
        borderRadius: BorderRadius.circular(8),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: 20, color: iconColor),
          const SizedBox(width: 8),
          Text(
            label,
            style: const TextStyle(fontWeight: FontWeight.w500),
          ),
        ],
      ),
    );
  }
}
