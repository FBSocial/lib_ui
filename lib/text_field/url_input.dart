import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:lib_theme/app_theme.dart';

import 'link_input.dart';

class UrlInput extends InputWidget {
  const UrlInput({
    required this.urlBean,
    ValueChanged<LinkBean>? onChanged,
    ClearCallback? clearCallback,
    Key? key,
    required this.focusNode,
  }) : super(
            onChanged: onChanged,
            linkBean: urlBean,
            clearCallback: clearCallback,
            key: key);

  final UrlBean urlBean;

  final FocusNode? focusNode;

  @override
  _UrlInputState createState() => _UrlInputState();
}

class _UrlInputState extends State<UrlInput> {
  TextEditingController? urlController;

  @override
  void initState() {
    urlController = TextEditingController(text: widget.urlBean.path);
    widget.clearCallback?.addCallback(urlController!.clear);
    urlController!.addListener(changeListener);
    super.initState();
  }

  void changeListener() {
    final url = urlController!.text;
    widget.onChanged?.call(UrlBean(url));
  }

  @override
  void dispose() {
    widget.clearCallback?.removeCallback(urlController!.clear);
    urlController!.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final color1 = AppTheme.of(context).fg.b60;
    return Container(
      height: 120,
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: TextFormField(
        controller: urlController,
        expands: true,
        maxLines: null,
        maxLength: 2000,
        focusNode: widget.focusNode,
        decoration: InputDecoration(
          border: InputBorder.none,
          counterText: '',
          hintText: '请输入URL，范例:https://www.baidu.com/'.tr,
          hintStyle: TextStyle(fontSize: 17, color: color1.withOpacity(0.5)),
        ),
      ),
    );
  }
}
