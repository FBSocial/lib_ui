import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:lib_theme/app_theme.dart';
import 'package:lib_theme/const.dart';
import 'package:lib_ui/text_field/native_input.dart';

class NormalTextInput extends StatefulWidget {
  final String? initText;
  final String? placeHolder;
  final int? maxCnt;
  final ValueChanged<String>? onChanged;
  final double? height;
  final double fontSize;
  final EdgeInsetsGeometry? contentPadding;
  final Color? backgroundColor;

  const NormalTextInput({
    Key? key,
    this.initText,
    this.placeHolder,
    this.maxCnt,
    this.onChanged,
    this.height,
    this.fontSize = 17,
    this.contentPadding,
    this.backgroundColor,
  }) : super(key: key);

  @override
  _NormalTextInputState createState() => _NormalTextInputState();
}

class _NormalTextInputState extends State<NormalTextInput> {
  String? _name;
  int? _maxCnt;
  TextEditingController? _textEditController;

  int get _currentCount {
    if (_name == null) {
      return 0;
    } else {
      return _name!.characters.length;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      height: widget.height ?? 52,
      color: widget.backgroundColor ?? Colors.white,
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Expanded(
            child: NativeInput(
              style: TextStyle(
                  fontSize: widget.fontSize,
                  color: AppTheme.of(context).fg.b100),
              decoration: InputDecoration(
                  border: InputBorder.none,
                  counterText: "",
                  hintText: widget.placeHolder,
                  hintStyle: TextStyle(
                      fontSize: widget.fontSize,
                      color: AppTheme.of(context).fg.b40),
                  contentPadding: widget.contentPadding),
              maxLength: _maxCnt,
              maxLengthEnforcement: MaxLengthEnforcement.none,
              controller: _textEditController,
              onChanged: (value) {
                if (mounted) setState(() => _name = value);
                if (widget.onChanged != null) {
                  widget.onChanged!(value);
                }
              },
            ),
          ),
          sizeWidth8,
          RichText(
            text: TextSpan(
                text: '$_currentCount',
                style: TextStyle(
                    fontSize: 14,
                    color: _currentCount > _maxCnt!
                        ? AppTheme.of(context).function.red1.withOpacity(0.5)
                        : AppTheme.of(context).fg.b30),
                children: [
                  TextSpan(
                    text: '/$_maxCnt',
                    style: TextStyle(
                        fontSize: 14, color: AppTheme.of(context).fg.b30),
                  )
                ]),
          ),
        ],
      ),
    );
  }

  @override
  void initState() {
    super.initState();
    _textEditController = TextEditingController();
    _textEditController!.text = widget.initText!;
    _name = widget.initText;
    _maxCnt = widget.maxCnt ?? 30;
  }
}
