import 'package:flutter/material.dart';
import 'package:get/get.dart';
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
      decoration: const BoxDecoration(
        color: Color(0xFFF5F6FA),
        borderRadius: BorderRadius.all(Radius.circular(6)),
      ),
      child: Row(
        children: [
          Expanded(
            child: CustomInputCloseBox(
              key: UniqueKey(),
              focusNode: focusNode,
              //autofocus: true,
              borderRadius: 6,
              fillColor: const Color(0xFFF5F5F8),
              controller: controller,
              hintText: hintText ?? '请输入原因(选填)'.tr,
              hintStyle:
              const TextStyle(color: Color(0x968F959E), fontSize: 16),
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
