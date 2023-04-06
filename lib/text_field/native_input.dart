import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:lib_theme/default_theme.dart';
import 'package:lib_ui/custom_text_selection.dart';
import 'package:lib_utils/config/config.dart';
import 'package:lib_utils/universal_platform.dart';
import 'package:native_text_field/native_text_field.dart';

class NativeInput extends StatefulWidget {
  final TextEditingController? controller;
  final NativeTextFieldController? nativeController;
  final FocusNode? focusNode;
  final InputDecoration decoration;
  final TextInputType?
      keyboardType; // iOS 支持的类型是 .text/.number/.phone/.emailAddress
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
      this.nativeController,
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
  int? _maxLength;

//  String _allowRegExp = '';
  Color? _fillColor;
  late EdgeInsets _contentPadding;
  late String _hintText;
  TextStyle? _hintStyle;

  final ValueNotifier<int> _currentLengthNotifier = ValueNotifier(0);

  /// 是否使用原生通用型输入框
  bool get _useNativeInput => Config.useNativeInput || widget.forceNative;

  @override
  void initState() {
    if (_useNativeInput) {
      final List<TextInputFormatter> formats = widget.inputFormatters ?? [];
      for (var element in formats) {
        if (element is LengthLimitingTextInputFormatter) {
          _maxLength = element.maxLength;
        } else if (element is FilteringTextInputFormatter) {
//          _allowRegExp = element.filterPattern.toString();
        }
      }
      _maxLength ??= widget.maxLength;
      _currentLengthNotifier.value =
          widget.controller?.text.characters.length ?? 0;

      _fillColor = widget.decoration.fillColor ?? Colors.transparent;
      _contentPadding = widget.decoration.contentPadding as EdgeInsets? ??
          const EdgeInsets.fromLTRB(8, 8, 8, 8);
      _hintText = widget.decoration.hintText ?? '';
      _hintStyle = widget.decoration.hintStyle;
    }
    super.initState();
  }

  @override
  void dispose() {
    _currentLengthNotifier.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    if (_useNativeInput) {
      final maxLength = _maxLength == 0 ||
              widget.maxLengthEnforcement == MaxLengthEnforcement.none
          ? null
          : _maxLength!;
      return Stack(
        alignment: Alignment.center,
        children: [
          Container(
            padding: _contentPadding.copyWith(
              right: widget.decoration.suffixIcon != null
                  ? (UniversalPlatform.isIOS ? 40 : 48)
                  : null,
              left: widget.decoration.prefixIcon != null ? 38 : null,
              bottom: widget.maxLines != 1 ? 20 : null,
            ),
            decoration: BoxDecoration(
                color: _fillColor,
                borderRadius: BorderRadius.circular(widget.borderRadius)),
            child: NativeTextField(
              text: widget.controller?.text ?? '',
              controller: widget.controller,
              nativeController: widget.nativeController,
              focusNode: widget.focusNode,
//              allowRegExp: _allowRegExp,
              keyboardType: widget.keyboardType ?? TextInputType.text,
              textStyle:
                  widget.style ?? Theme.of(context).textTheme.titleMedium,
              placeHolder: _hintText,
              placeHolderStyle:
                  _hintStyle ?? Theme.of(context).textTheme.bodyLarge,
              textAlign: widget.textAlign,
              onEditingComplete: widget.onEditingComplete,
              onSubmitted: widget.onSubmitted,
              onChanged: (string) {
                _currentLengthNotifier.value = string.characters.length;
                widget.onChanged?.call(string);
              },
              autoFocus: widget.autofocus,
              maxLength: maxLength,
              readOnly: widget.readOnly ?? false,
              height: widget.height,
              maxLines: widget.maxLines,
              disableFocusNodeListener: widget.disableFocusNodeListener,
              disableGesture: widget.disableGesture,
              cursorColor: primaryColor,
            ),
          ),
          if (widget.decoration.prefixIcon != null)
            Row(
              children: [
                widget.decoration.prefixIcon!,
              ],
            ),
          if (widget.decoration.suffixIcon != null)
            Positioned(
              right: 0,
              child: widget.decoration.suffixIcon!,
            )
          else if (widget.maxLength != 0 && widget.buildCounter != null)
            Positioned(
              right: 0,
              bottom: widget.maxLines != 1 ? 0 : null,
              child: ValueListenableBuilder<int>(
                  valueListenable: _currentLengthNotifier,
                  builder: (ctx, value, _) {
                    if (widget.buildCounter == null) {
                      return RichText(
                        text: TextSpan(
                            text:
                                '${widget.controller!.text.characters.length}',
                            style:
                                Theme.of(context).textTheme.bodyLarge!.copyWith(
                                      fontSize: 12,
                                      color: widget.controller!.text.characters
                                                  .length >
                                              maxLength!
                                          ? DefaultTheme.dangerColor
                                          : const Color(0xFF8F959E),
                                    ),
                            children: [
                              TextSpan(
                                text: '/$maxLength',
                                style: const TextStyle(
                                  fontSize: 12,
                                  color: Color(0xFF8F959E),
                                ),
                              )
                            ]),
                      );
                    } else {
                      return widget.buildCounter!(
                        context,
                        currentLength: value,
                        maxLength: widget.maxLength,
                        isFocused: false,
                      )!;
                    }
                  }),
            )
        ],
      );
    }
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
