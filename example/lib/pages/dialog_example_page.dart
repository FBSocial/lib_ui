import 'package:lib_ui/lib_ui.dart';
import 'package:flutter/material.dart';

class DialogExamplePage extends StatelessWidget {
  const DialogExamplePage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Wrap(
        children: [
          FbTextButton.primary("选项列表", onTap: () async {
            final result = await ActionSheet.showCustomActionSheet([
              const ActionSheetItem("one", value: 'one'),
              const ActionSheetItem("two", value: 'two'),
              const ActionSheetItem("three", value: 'three'),
            ]);
            if (result == null) {
              Toast.iconToast(icon: ToastIcon.success, label: "取消选择");
            } else {
              Toast.iconToast(icon: ToastIcon.success, label: "你的选项是: $result");
            }
          }),
        ],
      ),
    );
  }
}
