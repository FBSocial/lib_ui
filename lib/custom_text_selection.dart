import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class CustomMaterialTextSelectionControls
    extends MaterialTextSelectionControls {
  @override
  Future<void> handlePaste(TextSelectionDelegate delegate) async {
    final TextEditingValue value =
        delegate.textEditingValue; // Snapshot the input before using `await`.
    final ClipboardData? data = await Clipboard.getData(Clipboard.kTextPlain);
    if (data != null) {
      /// NOTE: 2022/1/17 添加`value.text.isNotEmpt`判断，解决https://github.com/flutter/flutter/issues/70257
      delegate.userUpdateTextEditingValue(
          TextEditingValue(
            text: (value.text.isNotEmpty
                    ? value.selection.textBefore(value.text)
                    : '') +
                data.text! +
                (value.text.isNotEmpty
                    ? value.selection.textAfter(value.text)
                    : ''),
            selection: TextSelection.collapsed(
                offset: value.selection.start + data.text!.length),
          ),
          SelectionChangedCause.toolbar);
    }
    delegate.bringIntoView(delegate.textEditingValue.selection.extent);
    delegate.hideToolbar();
  }
}

final TextSelectionControls customMaterialTextSelectionControls =
    CustomMaterialTextSelectionControls();
