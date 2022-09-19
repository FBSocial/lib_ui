import 'package:flutter/material.dart';
import 'package:get/get.dart';

class ActionConfirmDialog extends StatelessWidget {
  final String title;
  final String content;
  final String confirmText;
  final String cancelText;
  final VoidCallback? onConfirm;
  final VoidCallback? onCancel;

  const ActionConfirmDialog(
      {this.title = "提示",
      this.content = "",
      this.confirmText = "确定",
      this.cancelText = "取消",
      this.onConfirm,
      this.onCancel,
      Key? key})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Dialog(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
      elevation: 0,
      child: SizedBox(
        width: 280,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            if (title.isNotEmpty)
              Container(
                padding: const EdgeInsets.only(
                    left: 36, right: 36, top: 30, bottom: 30),
                child: Text(
                  title.tr,
                  textAlign: TextAlign.center,
                  style: const TextStyle(
                      fontSize: 17,
                      fontWeight: FontWeight.w600,
                      height: 1.35,
                      color: Colors.black),
                ),
              ),
            if (content.isNotEmpty)
              Container(
                padding: const EdgeInsets.only(
                    left: 36, right: 36, top: 10, bottom: 10),
                child: Text(content.tr,
                    style: const TextStyle(fontSize: 16, color: Colors.grey)),
              ),
            Divider(
              height: 0.5,
              color: const Color(0xFF8F959E).withOpacity(0.2),
            ),
            SizedBox(
              height: 55,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  if (onCancel != null)
                    TextButton(
                        onPressed: onCancel,
                        child: Text(
                          cancelText.tr,
                          style: const TextStyle(
                              fontSize: 17,
                              fontWeight: FontWeight.w600,
                              color: Color(0xFF363940)),
                        )),
                  if (onCancel != null)
                    VerticalDivider(
                      width: 1,
                      color: const Color(0xFF8F959E).withOpacity(0.2),
                    ),
                  TextButton(
                      onPressed: onConfirm,
                      child: Text(
                        confirmText.tr,
                        style: const TextStyle(
                            fontSize: 17,
                            fontWeight: FontWeight.w600,
                            color: Color(0xFF6179F2)),
                      )),
                ],
              ),
            )
          ],
        ),
      ),
    );
  }
}
