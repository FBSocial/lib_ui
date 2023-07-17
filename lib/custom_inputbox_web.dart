import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:lib_theme/app_theme.dart';
import 'package:lib_theme/const.dart';
import 'package:lib_ui/icon_font.dart';

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
  final bool closeButtonEnable; //是否开启清空按钮
  final double? closeButtonIconSize; //清空按钮图标大小

  // final int maxLines;
  final bool autofocus;
  final VoidCallback? onEditingComplete;
  final bool needCounter;
  final EdgeInsets? contentPadding;
  final TextInputType keyboardType;

  final List<TextInputFormatter>? inputFormatters;

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
    this.closeButtonEnable = false,
    this.closeButtonIconSize,
    this.inputFormatters,
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
    final borderColor = widget.borderColor ?? AppTheme.of(context).fg.b10;
    final inputPadding =
        EdgeInsets.only(right: 40, bottom: _isMultiline ? 15 : 0);
    return ClipRect(
        child: Stack(
      children: [
        Opacity(
          opacity: widget.readOnly ? 0.5 : 1,
          child: Container(
            padding: _closeButtonShow
                ? inputPadding.copyWith(right: 8)
                : inputPadding,
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
              inputFormatters: widget.inputFormatters,
            ),
          ),
        ),
        if (!widget.readOnly)
          Positioned.fill(
            child: Container(
              alignment:
                  _isMultiline ? Alignment.bottomRight : Alignment.centerRight,
              padding: const EdgeInsets.all(5),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  if (_closeButtonShow) _getCloseButton,
                  RichText(
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
                ],
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

  Widget get _getCloseButton => Container(
        margin: const EdgeInsets.only(right: 4),
        width: widget.closeButtonIconSize ?? 20,
        height: widget.closeButtonIconSize ?? 20,
        child: IconButton(
          hoverColor: Colors.transparent,
          highlightColor: Colors.transparent,
          splashColor: Colors.transparent,
          padding: EdgeInsets.zero,
          icon: Icon(
            IconFont.close,
            size: widget.closeButtonIconSize ?? 20,
            color: AppTheme.of(context).fg.b40,
          ),
          onPressed: () {
            widget.controller.clear();
            _onTextChange('');
          },
        ),
      );

  bool get _closeButtonShow =>
      (widget.closeButtonEnable && _isShowClear && !widget.readOnly);

  bool get _isShowClear => widget.controller.text.trim().isNotEmpty;
}
