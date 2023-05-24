import 'dart:io';
import 'dart:math';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_link_preview/link_fetch.dart';
import 'package:get/get.dart';
import 'package:lib_image/icon_font.dart';
import 'package:lib_image/image_collection.dart';
import 'package:lib_image/status_widget.dart';
import 'package:lib_theme/app_theme.dart';
import 'package:lib_theme/const.dart';
import 'package:lib_utils/loggers.dart';

/// 根据 URL 显示本地或者网络图片
// class LocalOrNetworkImage extends StatelessWidget {
//   final String url;
//   final ImageWidgetBuilder imageBuilder;
//
//   const LocalOrNetworkImage(this.url, {this.imageBuilder});
//
//   @override
//   Widget build(BuildContext context) {
//     if (url.startsWith("http")) {
//       return NetworkImageWithPlaceholder(url, imageBuilder: imageBuilder);
//     } else {
//       return Image.file(File(url));
//     }
//   }
// }

/// 带有 placeholder 的网络图片，失败后点击能够重试
/// 如果希望加载样式被全局管理可以使用这个类
/// 如果拥有特殊的加载占位符，则不适用
class NetworkImageWithPlaceholder extends StatefulWidget {
  final String? url;
  final ImageWidgetBuilder? imageBuilder;
  final BoxFit? fit;
  final Color? backgroundColor;
  final num? width;
  final num? height;
  final bool extend;
  final String? retryOriginUrl;

  const NetworkImageWithPlaceholder(this.url,
      {this.imageBuilder,
      this.fit,
      this.backgroundColor,
      this.width,
      this.height,
      this.extend = false,
      this.retryOriginUrl,
      Key? key})
      : super(key: key);

  @override
  _NetworkImageWithPlaceholderState createState() =>
      _NetworkImageWithPlaceholderState();

  @override
  void debugFillProperties(DiagnosticPropertiesBuilder properties) {
    super.debugFillProperties(properties);
    properties.add(ObjectFlagProperty<ImageWidgetBuilder>.has(
        'imageBuilder', imageBuilder));
    properties.add(StringProperty('url', url));
    properties.add(EnumProperty<BoxFit>('fit', fit));
    properties.add(ColorProperty('backgroundColor', backgroundColor));
    properties.add(DiagnosticsProperty<num>('width', width));
    properties.add(DiagnosticsProperty<num>('height', height));
    properties.add(DiagnosticsProperty<bool>('extend', extend));
  }
}

class _NetworkImageWithPlaceholderState
    extends State<NetworkImageWithPlaceholder> {
  ValueKey<int> _key = const ValueKey(0);

  String? retryUrl;

  @override
  Widget build(BuildContext context) {
    final String? requestUrl = retryUrl ?? widget.url;
    if (requestUrl == null || requestUrl.isEmpty) return Container();
    final memW = widget.width?.toInt();
    final memH = widget.height?.toInt();
    final image = ImageWidget.fromCachedNet(CachedImageBuilder(
      key: _key,
      imageUrl: requestUrl,
      fit: widget.fit,
      imageBuilder: widget.imageBuilder,
      memCacheWidth: memW,
      memCacheHeight: memH,
      // progressIndicatorBuilder: buildProgressLoading,
      placeholder: (context, _) => _buildPlaceHolderWidget(),
      errorWidget: (context, url, error) {
        logger.severe('图片加载失败', error.toString());
        return FutureBuilder<String>(
            future: urlContentType(url).timeout(const Duration(seconds: 3)),
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.done) {
                if (snapshot.data?.contains("image") ?? true) {
                  return _buildRetryWidget(url, memW!, memH);
                } else {
                  return _buildResizeErrorWidget(memW!, memH);
                }
              } else {
                return _buildPlaceHolderWidget();
              }
            });
      },
    ));
    if (widget.width == null && widget.height == null) {
      return image;
    }
    if (widget.width! > 0 && widget.height! > 0) {
      if (widget.extend) {
        return AspectRatio(
          aspectRatio: widget.width! / widget.height!,
          child: image,
        );
      } else {
        return SizedBox(
          width: widget.width!.toDouble(),
          height: widget.height!.toDouble(),
          child: image,
        );
      }
    }
    return image;
  }

  Widget _buildPlaceHolderWidget() {
    return Container(
        color: widget.backgroundColor,
        child: const Center(
          child: SizedBox(
            width: 16,
            height: 16,
            child: CircularProgressIndicator(strokeWidth: 2),
          ),
        ));
  }

  Widget _buildResizeErrorWidget(int width, int? height) {
    if (width <= 48 || height! <= 48) {
      return Padding(
        padding: const EdgeInsets.all(4),
        child: Center(
          child: Icon(
            IconFont.tupian,
            size: 24,
            color: AppTheme.of(context).fg.b60,
          ),
        ),
      );
    }

    return Padding(
      padding: const EdgeInsets.all(4),
      child: Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              IconFont.tupian,
              size: 24,
              color: AppTheme.of(context).fg.b60,
            ),
            sizeHeight8,
            Text('缩略图无法显示'.tr,
                textAlign: TextAlign.center,
                style: TextStyle(
                    fontSize: 12, color: AppTheme.of(context).fg.b60)),
            sizeHeight4,
            Text(
              '点击查看原图'.tr,
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 12,
                color: AppTheme.of(context).auxiliary.violet,
              ),
            )
          ],
        ),
      ),
    );
  }

  Widget _buildRetryWidget(String url, int width, int? height) {
    // 大于48，显示icon+文字
    Widget _commonWidget() {
      return Center(
          child: Column(mainAxisSize: MainAxisSize.min, children: [
        Icon(IconFont.imgLoadFail,
            size: 24, color: AppTheme.of(context).fg.b40),
        sizeHeight8,
        Text(
          '点击重新加载'.tr,
          textAlign: TextAlign.center,
          style: TextStyle(fontSize: 12, color: AppTheme.of(context).fg.b40),
        )
      ]));
    }

    //小于48，只显示icon
    Widget _onlyIconWidget() {
      return Center(
          child: Icon(IconFont.imgLoadFail,
              size: min(24, width.toDouble()),
              color: AppTheme.of(context).fg.b40));
    }

    return GestureDetector(
      behavior: HitTestBehavior.translucent,
      onTap: () async {
        if (widget.retryOriginUrl != null &&
            widget.retryOriginUrl!.isNotEmpty) {
          //失败后需要修改url才能重新显示，加上时间戳改变url
          retryUrl =
              "${widget.retryOriginUrl}?ts=${DateTime.now().millisecondsSinceEpoch}";
        }
        await evictImage(url, width, height);
        setState(() {
          _key = ValueKey(_key.value + 1);
        });
      },
      child: Container(
          color: widget.backgroundColor,
          child: (width <= 48 || height! <= 48)
              ? _onlyIconWidget()
              : _commonWidget()),
    );
  }

  Future<String> urlContentType(String url) async {
    if (Platform.isIOS) {
      final result = await LinkFetch.linkFetchHead(url: url);
      return result['content-type'] ?? "";
    } else {
      final httpClient = HttpClient();
      final HttpClientRequest request = await httpClient.getUrl(Uri.parse(url));
      final response = await request.close();
      httpClient.close();
      return response.headers.contentType?.mimeType ?? "";
    }
  }
}
