import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:lib_theme/app_theme.dart';
import 'package:lib_theme/const.dart';

typedef OnChange = void Function(String);

///
/// 自定义输入框
///
class WebCustomInputBox extends StatefulWidget {
  final TextEditingController controller;
  final double fontSize;
  final String? hintText;
  final Color? textColor;
  final Color? placeholderColor;
  final Color? fillColor;
  final Color? borderColor;
  final OnChange? onChange;
  final int? maxLength;
  final bool readOnly;
  final FocusNode? focusNode;
  final double borderRadius;

  // final int maxLines;
  final bool autofocus;
  final VoidCallback? onEditingComplete;
  final bool needCounter;
  final EdgeInsets? contentPadding;
  final TextInputType keyboardType;

  const WebCustomInputBox({
    required this.controller,
    this.hintText,
    this.fontSize = 14,
    this.textColor,
    this.placeholderColor,
    this.fillColor,
    this.borderColor,
    this.maxLength,
    this.readOnly = false,
    this.focusNode,
    this.borderRadius = 4,
    this.autofocus = false,
    // this.maxLines = 1,
    this.onChange,
    this.onEditingComplete,
    this.needCounter = true,
    this.keyboardType = TextInputType.text,
    this.contentPadding,
    Key? key,
  }) : super(key: key);

  @override
  _WebCustomInputBoxState createState() => _WebCustomInputBoxState();
}

class _WebCustomInputBoxState extends State<WebCustomInputBox> {
  EdgeInsets? _contentPadding;
  late bool _isMultiline;

  @override
  void initState() {
    _isMultiline = widget.keyboardType == TextInputType.multiline;
    _contentPadding = widget.contentPadding ??
        EdgeInsets.fromLTRB(12, 12, _isMultiline ? 12 : 60, 12);

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final borderColor = widget.borderColor ?? AppTheme.of(context).fg.b10;
    return ClipRect(
        child: Stack(
      children: [
        Opacity(
          opacity: widget.readOnly ? 0.5 : 1,
          child: Container(
            padding: EdgeInsets.only(bottom: _isMultiline ? 15 : 0),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(widget.borderRadius),
              border: Border.all(color: borderColor),
            ),
            child: TextField(
              maxLines: _isMultiline ? null : 1,
              readOnly: widget.readOnly,
              focusNode: widget.focusNode,
              onChanged: _onTextChange,
              autofocus: widget.autofocus,
              controller: widget.controller,
              style: TextStyle(
                fontSize: widget.fontSize,
                color: widget.textColor ?? AppTheme.of(context).fg.b100,
              ),
              keyboardType: TextInputType.multiline,
              buildCounter: (
                context, {
                required currentLength,
                maxLength,
                required isFocused,
              }) {
                return null;
              },
              maxLength: widget.maxLength,
              maxLengthEnforcement: MaxLengthEnforcement.none,
              decoration: InputDecoration(
                isDense: true,
                contentPadding: _contentPadding,
                border: OutlineInputBorder(
                  borderSide: BorderSide.none,
                  borderRadius: BorderRadius.circular(widget.borderRadius),
                  gapPadding: 0,
                ),
                fillColor: widget.fillColor,
                filled: true,
                hintText: widget.hintText,
                hintStyle: TextStyle(
                  fontSize: widget.fontSize,
                  color: widget.placeholderColor ?? AppTheme.of(context).fg.b40,
                ),
              ),
              onEditingComplete: widget.onEditingComplete,
            ),
          ),
        ),
        if (!widget.readOnly)
          Positioned.fill(
            child: Container(
              alignment:
                  _isMultiline ? Alignment.bottomRight : Alignment.centerRight,
              padding: const EdgeInsets.all(5),
              child: RichText(
                text: TextSpan(
                    text: '${Characters(widget.controller.text).length}',
                    style: TextStyle(
                        fontWeight: FontWeight.normal,
                        height: 1.35,
                        fontFamilyFallback: defaultFontFamilyFallback,
                        fontSize: 12,
                        color: Characters(widget.controller.text).length >
                                widget.maxLength!
                            ? AppTheme.of(context).function.red1
                            : AppTheme.of(context).fg.b60),
                    children: [
                      TextSpan(
                        text: '/${widget.maxLength}',
                        style: TextStyle(
                          color: AppTheme.of(context).fg.b60,
                          fontWeight: FontWeight.normal,
                          height: 1.35,
                          fontFamilyFallback: defaultFontFamilyFallback,
                          fontSize: 12,
                        ),
                      )
                    ]),
              ),
            ),
          )
      ],
    ));
  }

  void _onTextChange(String val) {
    setState(() {});
    if (widget.onChange != null) widget.onChange!(val);
  }
}
