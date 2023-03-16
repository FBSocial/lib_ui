import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:lib_theme/app_theme.dart';
import 'package:lib_ui/custom_inputbox_close.dart';

typedef TextFieldListener = void Function(String text);

class BlackListTextField extends StatefulWidget {
  static const int inputLength = 20;

  final TextFieldListener textFieldListener;
  final String? hintText;

  const BlackListTextField(this.textFieldListener, {this.hintText, Key? key})
      : super(key: key);

  @override
  _BlackListTextFieldState createState() => _BlackListTextFieldState();
}

class _BlackListTextFieldState extends State<BlackListTextField> {
  TextFieldListener get textFieldListener => widget.textFieldListener;

  String? get hintText => widget.hintText;

  final TextEditingController controller = TextEditingController();
  final FocusNode focusNode = FocusNode();

  @override
  void initState() {
    super.initState();
    focusNode.requestFocus(); //fix:ios手机可能拉起键盘显示异常，改为自动拉起键盘
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: AppTheme.of(context).bg.bg1,
        borderRadius: const BorderRadius.all(Radius.circular(6)),
      ),
      child: Row(
        children: [
          Expanded(
            child: CustomInputCloseBox(
              key: UniqueKey(),
              focusNode: focusNode,
              //autofocus: true,
              borderRadius: 6,
              fillColor: AppTheme.of(context).bg.bg1,
              controller: controller,
              hintText: hintText ?? '请输入原因(选填)'.tr,
              hintStyle:
                  TextStyle(color: AppTheme.of(context).fg.b40, fontSize: 16),
              maxLength: BlackListTextField.inputLength,
              onChange: (text) {
                textFieldListener.call(text);
              },
            ),
          ),
        ],
      ),
    );
  }
}
