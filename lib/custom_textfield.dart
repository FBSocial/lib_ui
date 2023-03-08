import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:lib_theme/app_theme.dart';
import 'package:lib_ui/text_field/native_input.dart';
import 'package:lib_utils/config/config.dart';
import 'package:lib_utils/universal_platform.dart';

class CustomTextField extends StatefulWidget {
  final String placeHolder;
  final String? title;
  final int? maxLength;
  final void Function(String title)? onChanged;

  const CustomTextField(
      {required this.placeHolder,
      this.title,
      this.onChanged,
      this.maxLength = 20,
      Key? key})
      : super(key: key);

  @override
  _CustomTextFieldState createState() => _CustomTextFieldState();
}

class _CustomTextFieldState extends State<CustomTextField> {
  TextEditingController? _textEditingController;
  String _title = "";

  @override
  void initState() {
    _title = widget.title ?? "";
    _textEditingController = TextEditingController.fromValue(TextEditingValue(
        text: _title,
        selection:
            TextSelection.fromPosition(TextPosition(offset: _title.length))));
    super.initState();
  }

  @override
  void dispose() {
    _textEditingController!.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final bool compatibilityPadding =
        UniversalPlatform.isAndroid && !Config.useNativeInput;
    return Material(
      child: SizedBox(
        height: 40,
        child: NativeInput(
          style: const TextStyle(fontSize: 16, color: Color(0xFF363940)),
          autofocus: true,
          height: 40,
          decoration: InputDecoration(
              fillColor: const Color(0xfff2f3f5),
              filled: true,
              contentPadding: const EdgeInsets.only(left: 12, top: 4),
              hintStyle: TextStyle(
                  fontSize: 16,
                  color: const Color(0xFF8F959E).withOpacity(0.7)),
              border: const OutlineInputBorder(
                  borderRadius: BorderRadius.all(Radius.circular(6)),
                  borderSide: BorderSide.none),
              counterText: "",
              hintText: widget.placeHolder,
              suffixIcon: Container(
                padding: EdgeInsets.only(
                  left: compatibilityPadding ? 4 : 0,
                  top: compatibilityPadding ? 14 : 6,
                  right: compatibilityPadding ? 0 : 4,
                ),
                child: RichText(
                  text: TextSpan(
                      text: '${_title.trim().characters.length}',
                      style: Theme.of(context).textTheme.bodyText1!.copyWith(
                            fontSize: 12,
                            color: _title.trim().characters.length >
                                    widget.maxLength!
                                ? AppTheme.of(context).auxiliary.red
                                : const Color(0xFF8F959E),
                          ),
                      children: [
                        TextSpan(
                          text: '/${widget.maxLength}',
                          style: const TextStyle(
                            fontSize: 12,
                            color: Color(0xFF8F959E),
                          ),
                        )
                      ]),
                ),
              )),
          maxLength: widget.maxLength,
          maxLengthEnforcement: widget.maxLength != null
              ? MaxLengthEnforcement.none
              : MaxLengthEnforcement.enforced,
          controller: _textEditingController,
          onChanged: (value) {
            setState(() {
              _title = value;
            });
            widget.onChanged!(value);
          },
        ),
      ),
    );
  }
}
