import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:lib_theme/const.dart';
import 'package:lib_theme/default_theme.dart';
import 'package:lib_ui/text_field/native_input.dart';

import 'icon_font.dart';

typedef OnChange = void Function(String);

///
/// 自定义输入框，有close icon 与 buiderCounter, 横向
///
class CustomInputCloseBox extends StatefulWidget {
  final TextEditingController controller;
  final String? hintText;
  final TextStyle? hintStyle;
  final Color? fillColor;
  final OnChange? onChange;
  final int? maxLength;
  final bool readOnly;
  final FocusNode? focusNode;
  final double borderRadius;
  final int maxLines;
  final bool autofocus;
  final VoidCallback? onEditingComplete;
  final bool needCounter;
  final EdgeInsets contentPadding;
  final EdgeInsets? nativeContentPadding;
  final Widget? prefixIcon;
  final BoxConstraints? prefixIconConstraints;
  final double? height;
  final List<TextInputFormatter>? inputFormatters;
  final TextStyle? style;

  const CustomInputCloseBox({
    required this.controller,
    this.hintText,
    this.hintStyle,
    this.fillColor,
    this.maxLength,
    this.readOnly = false,
    this.focusNode,
    this.borderRadius = 4,
    this.autofocus = false,
    this.maxLines = 1,
    this.onChange,
    this.onEditingComplete,
    this.needCounter = true,
    this.contentPadding = const EdgeInsets.fromLTRB(16, 8, 16, 8),
    this.nativeContentPadding,
    this.prefixIcon,
    this.prefixIconConstraints,
    this.height,
    this.inputFormatters,
    this.style,
    Key? key,
  }) : super(key: key);

  @override
  _CustomInputCloseBoxState createState() => _CustomInputCloseBoxState();
}

class _CustomInputCloseBoxState extends State<CustomInputCloseBox> {
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final decoration = InputDecoration(
      contentPadding: widget.contentPadding,
      border: OutlineInputBorder(
        borderSide: BorderSide.none,
        borderRadius: BorderRadius.circular(widget.borderRadius),
        gapPadding: 0,
      ),
      fillColor: widget.fillColor,
      filled: true,
      counterText: '',
      hintText: widget.hintText,
      hintStyle: widget.hintStyle,
      prefixIcon: widget.prefixIcon,
      prefixIconConstraints: widget.prefixIconConstraints,
      suffixIconConstraints: const BoxConstraints(maxWidth: 32),
      suffixIcon: (_isShowClear && !widget.readOnly)
          ? IconButton(
              padding: EdgeInsets.zero,
              icon: const Icon(
                IconFont.close,
                size: 20,
                color: Color(0x7F8F959E),
              ),
              onPressed: () {
                widget.controller.clear();
                _onTextChange('');
              },
            )
          : const SizedBox(),
    );

    return ClipRect(
        child: Container(
      decoration: BoxDecoration(
        color: widget.fillColor,
        borderRadius: BorderRadius.all(Radius.circular(widget.borderRadius)),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Expanded(
            child: NativeInput(
              readOnly: widget.readOnly,
              focusNode: widget.focusNode,
              onChanged: _onTextChange,
              autofocus: widget.autofocus,
              controller: widget.controller,
              decoration: decoration.copyWith(
                contentPadding: widget.nativeContentPadding ??
                    const EdgeInsets.symmetric(horizontal: 16, vertical: 2),
              ),
              maxLength: widget.maxLength,
              maxLengthEnforcement: MaxLengthEnforcement.none,
              onEditingComplete: widget.onEditingComplete,
              borderRadius: widget.borderRadius,
              height: widget.height,
              inputFormatters: widget.inputFormatters,
              style: widget.style,
            ),
          ),
          SizedBox(
            child: RichText(
              text: TextSpan(
                  text: '${widget.controller.text.characters.length}',
                  style: Theme.of(context).textTheme.bodyText1!.copyWith(
                        fontSize: 14,
                        color: widget.controller.text.characters.length >
                                widget.maxLength!
                            ? DefaultTheme.dangerColor
                            : const Color(0xFF8F959E),
                      ),
                  children: [
                    TextSpan(
                      text: '/${widget.maxLength}',
                      style: const TextStyle(
                        fontSize: 14,
                        color: Color(0xFF8F959E),
                      ),
                    )
                  ]),
            ),
          ),
          sizeWidth16,
        ],
      ),
    ));
  }

  void _onTextChange(String val) {
    setState(() {});
    if (widget.onChange != null) widget.onChange!(val);
  }

  bool get _isShowClear => widget.controller.text.trim().isNotEmpty;
}
