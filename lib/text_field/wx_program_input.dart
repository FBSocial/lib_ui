import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:lib_theme/app_theme.dart';

import 'link_input.dart';

class WxProgramInput extends InputWidget {
  const WxProgramInput({
    required this.wxProgramBean,
    required this.focusNode,
    ValueChanged<LinkBean>? onChanged,
    ClearCallback? clearCallback,
    Key? key,
  }) : super(
            onChanged: onChanged,
            linkBean: wxProgramBean,
            clearCallback: clearCallback,
            key: key);

  final WxProgramBean wxProgramBean;
  final FocusNode? focusNode;
  @override
  _WxProgramInputState createState() => _WxProgramInputState();
}

class _WxProgramInputState extends State<WxProgramInput> {
  TextEditingController? usernameController;
  TextEditingController? pathController;

  @override
  void initState() {
    final bean = widget.wxProgramBean;
    usernameController = TextEditingController(text: bean.appId ?? '');
    pathController = TextEditingController(text: bean.path ?? '');
    widget.clearCallback?.addCallback(clear);
    usernameController!.addListener(changeListener);
    pathController!.addListener(changeListener);
    super.initState();
  }

  void changeListener() {
    final username = usernameController!.text;
    final path = pathController!.text;
    widget.onChanged?.call(WxProgramBean(username, path: path));
  }

  void clear() {
    usernameController!.clear();
    pathController!.clear();
  }

  @override
  void dispose() {
    widget.clearCallback?.removeCallback(clear);
    usernameController!.dispose();
    pathController!.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final color1 = AppTheme.of(context).fg.b60;
    return Column(
      children: [
        Container(
          height: 84,
          padding: const EdgeInsets.symmetric(horizontal: 16),
          child: TextFormField(
            controller: usernameController,
            focusNode: widget.focusNode,
            expands: true,
            maxLines: null,
            maxLength: 100,
            decoration: InputDecoration(
              border: InputBorder.none,
              counterText: '',
              hintText: '请输入小程序原始ID，范例：gh_d43f693ca31f'.tr,
              hintMaxLines: 2,
              hintStyle:
                  TextStyle(fontSize: 17, color: color1.withOpacity(0.5)),
            ),
          ),
        ),
        Divider(
          height: 1,
          color: color1.withOpacity(0.2),
        ),
        Container(
          height: 84,
          padding: const EdgeInsets.symmetric(horizontal: 16),
          child: TextFormField(
            controller: pathController,
            expands: true,
            maxLines: null,
            maxLength: 200,
            decoration: InputDecoration(
              border: InputBorder.none,
              counterText: '',
              hintMaxLines: 3,
              hintText: '请输入小程序路径和参数，范例：pages/index/index.html，不填默认拉起小程序首页'.tr,
              hintStyle:
                  TextStyle(fontSize: 17, color: color1.withOpacity(0.5)),
            ),
          ),
        ),
      ],
    );
  }
}
