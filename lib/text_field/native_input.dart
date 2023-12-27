import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:lib_ui/custom_text_selection.dart';

class NativeInput extends StatefulWidget {
  final TextEditingController? controller;
  final FocusNode? focusNode;
  final InputDecoration decoration;
  final TextInputType? keyboardType;
  // iOS 支持的类型是 .text/.number/.phone/.emailAddress
  final TextStyle? style;
  final TextAlign textAlign;
  final VoidCallback? onEditingComplete;
  final Function(String)? onSubmitted;
  final Function(String)? onChanged;
  final bool autofocus;
  final int? maxLength;
  final MaxLengthEnforcement? maxLengthEnforcement;
  final List<TextInputFormatter>? inputFormatters;
  final InputCounterWidgetBuilder? buildCounter;
  final bool? readOnly;
  final double borderRadius;
  final double? height; // 原生iOS 需要
  final int maxLines;
  final TextSelectionControls? selectionControls;
  final bool forceNative;
  final bool disableFocusNodeListener; // 禁用focusNode的listener监听
  final bool disableGesture;

  const NativeInput(
      {this.controller,
      this.focusNode,
      this.decoration = const InputDecoration(),
      this.keyboardType = TextInputType.text,
      this.style,
      this.textAlign = TextAlign.start,
      this.onEditingComplete,
      this.inputFormatters,
      this.buildCounter,
      this.onSubmitted,
      this.onChanged,
      this.autofocus = false,
      this.maxLength = 0,
      this.maxLengthEnforcement,
      this.borderRadius = 0,
      this.readOnly = false,
      this.height,
      this.maxLines = 1,
      this.selectionControls,
      this.forceNative = false,
      this.disableFocusNodeListener = false,
      this.disableGesture = false,
      Key? key})
      : super(key: key);

  @override
  _NativeInputState createState() => _NativeInputState();
}

class _NativeInputState extends State<NativeInput> {
  final ValueNotifier<int> _currentLengthNotifier = ValueNotifier(0);

  @override
  void dispose() {
    _currentLengthNotifier.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return ClipRect(
        child: Padding(
      padding: const EdgeInsets.only(left: 1),
      child: TextField(
        textAlignVertical: TextAlignVertical.center,
        controller: widget.controller,
        focusNode: widget.focusNode,
        decoration: widget.decoration,
        keyboardType: widget.keyboardType,
        style: widget.style,
        textAlign: widget.textAlign,
        onEditingComplete: widget.onEditingComplete,
        onSubmitted: widget.onSubmitted,
        onChanged: widget.onChanged,
        autofocus: widget.autofocus,
        maxLength: widget.maxLength == 0 ? null : widget.maxLength,
        inputFormatters: widget.inputFormatters,
        buildCounter: widget.buildCounter,
        maxLengthEnforcement: widget.maxLengthEnforcement,
        readOnly: widget.readOnly ?? false,
        maxLines: widget.maxLines,
        cursorHeight: 22,
        cursorWidth: 2,
        cursorRadius: const Radius.circular(1),
        selectionControls: widget.selectionControls ??
            (Theme.of(context).platform == TargetPlatform.android
                ? customMaterialTextSelectionControls
                : null),
      ),
    ));
  }
}
