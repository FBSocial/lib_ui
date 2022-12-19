import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:lib_theme/const.dart';
import 'package:lib_theme/custom_color.dart';
import 'package:lib_utils/loggers.dart';

import '../icon_font.dart';
import 'url_input.dart';
import 'wx_program_input.dart';

abstract class InputWidget extends StatefulWidget {
  final ValueChanged<LinkBean>? onChanged;
  final LinkBean? linkBean;
  final ClearCallback? clearCallback;

  const InputWidget({
    Key? key,
    this.onChanged,
    this.linkBean,
    this.clearCallback,
  }) : super(key: key);
}

class LinkInput extends StatefulWidget {
  final ValueChanged<LinkBean>? onChanged;
  final LinkBean? linkBean;
  final Color? bgColor;

  //将焦点交给外部
  final FocusNode? focusNode;

  //是否点击聚集
  final bool? clickAutoFocus;

  const LinkInput({
    Key? key,
    this.onChanged,
    this.linkBean,
    this.bgColor = Colors.white,
    this.focusNode,
    this.clickAutoFocus,
  }) : super(key: key);

  @override
  _LinkInputState createState() => _LinkInputState();
}

class _LinkInputState extends State<LinkInput> {
  String? linkType;
  ClearCallback clearCallback = ClearCallback();
  String _url = '';
  LinkBean? _linkBean;
  FocusNode? wxFocusNode;
  FocusNode? urlFocusNode;

  @override
  void initState() {
    _linkBean = widget.linkBean;
    linkType = widget.linkBean?.type ?? _LinkTypes.url;
    if (linkType == _LinkTypes.url) {
      urlFocusNode = widget.focusNode ?? FocusNode();
      wxFocusNode = FocusNode();
    } else {
      urlFocusNode = FocusNode();
      wxFocusNode = widget.focusNode ?? FocusNode();
    }
    super.initState();
  }

  void refresh() {
    if (mounted) setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final color1 = theme.disabledColor;

    ///TODO:这个颜色暂时没有对应的theme参数
    const color2 = Color(0xff576B95);
    return Container(
        color: widget.bgColor,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: const EdgeInsets.fromLTRB(16, 8, 16, 8),
              child: Row(
                children: [
                  buildChooseButton(context,
                      choosing: linkType == _LinkTypes.url, onTap: () {
                    if (linkType == _LinkTypes.url) return;
                    linkType = _LinkTypes.url;
                    updateLinkBean(linkType);
                    widget.onChanged?.call(UrlBean(''));
                    if (widget.clickAutoFocus ?? false) {
                      urlFocusNode?.requestFocus();
                    }
                    refresh();
                  }),
                  sizeWidth12,
                  buildChooseButton(context,
                      choosing: linkType == _LinkTypes.wxProgram,
                      text: '小程序'.tr,
                      iconData: IconFont.channelLink, onTap: () {
                    if (linkType == _LinkTypes.wxProgram) return;
                    linkType = _LinkTypes.wxProgram;
                    updateLinkBean(linkType);
                    widget.onChanged?.call(WxProgramBean(''));
                    if (widget.clickAutoFocus ?? false) {
                      wxFocusNode?.requestFocus();
                    }
                    refresh();
                  }),
                  const Spacer(),
                  GestureDetector(
                    onTap: hasLink ? clearCallback.clear : null,
                    child: Text(
                      '清空'.tr,
                      style: theme.textTheme.bodyText1!.copyWith(
                          fontSize: 13, color: hasLink ? color2 : color1),
                    ),
                  )
                ],
              ),
            ),
            Divider(
              height: 1,
              color: color1.withOpacity(0.2),
            ),
            buildInput()
          ],
        ));
  }

  void updateLinkBean(String? type) {
    if (widget.linkBean?.type == type) {
      _linkBean = widget.linkBean;
      return;
    }
    switch (type) {
      case _LinkTypes.url:
        _linkBean = UrlBean('');
        break;
      case _LinkTypes.wxProgram:
        _linkBean = WxProgramBean('');
        break;
    }
  }

  Widget buildInput() {
    if (linkType == _LinkTypes.url) {
      return UrlInput(
        urlBean: _linkBean as UrlBean? ?? UrlBean(''),
        clearCallback: clearCallback,
        onChanged: (bean) {
          widget.onChanged?.call(bean);
          _url = (bean as UrlBean).path;
          refresh();
        },
        focusNode: urlFocusNode,
      );
    } else {
      return WxProgramInput(
        wxProgramBean: _linkBean as WxProgramBean? ?? WxProgramBean(''),
        focusNode: wxFocusNode,
        clearCallback: clearCallback,
        onChanged: (bean) {
          widget.onChanged?.call(bean);
          _url = (bean as WxProgramBean).url;
          refresh();
        },
      );
    }
  }

  Widget buildChooseButton(
    BuildContext context, {
    bool choosing = true,
    String text = 'URL',
    IconData? iconData,
    VoidCallback? onTap,
  }) {
    final theme = Theme.of(context);
    final bgColor = choosing
        ? theme.primaryColor.withOpacity(0.15)
        : CustomColor(context).disableColor.withOpacity(0.15);
    final iconColor = choosing ? theme.primaryColor : theme.iconTheme.color;
    return GestureDetector(
      onTap: onTap,
      child: Stack(
        children: [
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 7.5),
            decoration: BoxDecoration(
              color: bgColor,
              borderRadius: BorderRadius.circular(6),
            ),
            child: Row(
              children: [
                Icon(
                  iconData ?? IconFont.channelLink2,
                  size: 16,
                  color: iconColor,
                ),
                sizeWidth4,
                Text(
                  text,
                  style: TextStyle(color: iconColor, fontSize: 15, height: 1.4),
                ),
              ],
            ),
          ),
          if (choosing)
            Positioned(
              right: 0,
              bottom: 0,
              child: CustomPaint(
                painter:
                    TriangleShape(borderRadius: 6, color: theme.primaryColor),
                child: Container(
                  width: 20,
                  height: 20,
                  alignment: Alignment.bottomRight,
                  padding: const EdgeInsets.only(bottom: 1.5, right: 1.5),
                  child: const Icon(
                    Icons.check,
                    size: 10,
                    color: Colors.white,
                  ),
                ),
              ),
            ),
        ],
      ),
    );
  }

  bool get hasLink => _url.isNotEmpty;

  @override
  void dispose() {
    clearCallback.dispose();
    super.dispose();
  }
}

class TriangleShape extends CustomPainter {
  final double borderRadius;
  final Color color;

  TriangleShape({
    this.borderRadius = 4,
    this.color = Colors.grey,
  });

  @override
  void paint(Canvas canvas, Size size) {
    final w = size.width;
    final h = size.height;

    final Paint paint = Paint();
    paint.color = color;
    paint.strokeWidth = 0;

    final Path path = Path();
    path.moveTo(w, 0);
    path.lineTo(0, h);
    path.lineTo(w - borderRadius, h);
    path.cubicTo(w - borderRadius, h, w, h, w, h - borderRadius);
    path.lineTo(w, 0);
    path.close();
    if (size.width == 0 || size.height == 0) {
      canvas.drawPath(Path(), paint);
    } else {
      canvas.drawPath(path, paint);
    }
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) => false;
}

class ClearCallback {
  final Set<VoidCallback> _clears = {};

  void addCallback(VoidCallback callback) {
    _clears.add(callback);
  }

  void removeCallback(VoidCallback callback) {
    _clears.remove(callback);
  }

  void dispose() => _clears.clear();

  void clear() {
    for (var element in _clears) {
      element.call();
    }
  }
}

enum LinkType { url, miniProgram }

///[LinkType] 为 [LinkType.url] 时候的跳转类型
enum UrlLinkType { webView, fanBookMiniProgram }

class UrlLinkTypes {
  static const String fanBookHost = 'fanbook.mobi';
  static const String fanBookMiniPath = 'mp';
}

class _LinkTypes {
  static const url = 'url';

  ///这里使用小写，避免转换问题
  static const wxProgram = 'wxminiprogram';
}

abstract class LinkBean {
  LinkBean(this.type);

  String type;

  Map toJson();

  String toLinkString();

  static LinkBean fromStringLink(String link) {
    Uri uri;
    try {
      uri = Uri.parse(link);
      final scheme = uri.scheme;
      switch (scheme) {
        case _LinkTypes.wxProgram:
          final map = uri.queryParameters;
          final appId = map['appId'];
          final path = map['path'];
          return WxProgramBean(appId, path: path);
        case _LinkTypes.url:
        default:
          return UrlBean(link);
      }
    } catch (e) {
      ///parse失败说明链接有问题，这时候默认跳转到webview
      logger.finer('链接频道转换失败:$link');
      return UrlBean(link);
    }
  }
}

class UrlBean extends LinkBean {
  String path;

  UrlBean(this.path, {String linkType = _LinkTypes.url}) : super(linkType);

  factory UrlBean.fromJson(Map<String, dynamic> json) =>
      UrlBean(json["path"].toString());

  @override
  Map<String, dynamic> toJson() => {
        "path": path,
        "type": type,
      };

  @override
  String toLinkString() => path;
}

class WxProgramBean extends LinkBean {
  String? appId;
  String? path;

  WxProgramBean(this.appId, {this.path, String linkType = _LinkTypes.wxProgram})
      : super(linkType);

  factory WxProgramBean.fromJson(Map<String, dynamic> json) => WxProgramBean(
        json["appId"].toString(),
        path: json["path"].toString(),
      );

  String get url => appId! + path!;

  @override
  Map<String, dynamic> toJson() => {
        "type": type,
        "appId": appId,
        "path": path ?? '',
      };

  @override
  String toLinkString() =>
      Uri(scheme: _LinkTypes.wxProgram, queryParameters: toJson()).toString();
}
