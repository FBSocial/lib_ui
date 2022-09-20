import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_cache_manager/flutter_cache_manager.dart';
import 'package:lib_image/image_collection.dart';
import 'package:lib_utils/utils.dart';

/// 圆角图片
class RoundImage extends StatelessWidget {
  final String? url;
  final double width;
  final double height;
  final double radius;
  final BoxFit fit;
  final PlaceholderWidgetBuilder? placeholder;
  final BaseCacheManager? cacheManager;

  const RoundImage(
      {this.url,
      this.width = 16,
      this.height = 10,
      this.radius = 5,
      this.placeholder,
      this.fit = BoxFit.cover,
      this.cacheManager,
      Key? key})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    if (!isNotNullAndEmpty(url)) return Container();
    final image = ImageWidget.fromCachedNet(CachedImageBuilder(
      cacheManager: cacheManager,
      fit: fit,
      imageUrl: url,
      placeholder: placeholder,
      imageBuilder: (_, image) {
        return Container(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(radius),
            image: DecorationImage(image: image, fit: fit),
          ),
        );
      },
    ));
    return AspectRatio(
      aspectRatio: width / height,
      child: image,
    );
  }
}

/// 圆角图片
class SizedRoundImage extends StatelessWidget {
  final String? url;
  final double? width;
  final double? height;
  final double radius;
  final Color? borderColor;
  final PlaceholderWidgetBuilder? placeholder;
  final BaseCacheManager? cacheManager;

  const SizedRoundImage(
      {this.url,
      this.width,
      this.height,
      this.borderColor,
      this.radius = 5,
      this.placeholder,
      this.cacheManager,
      Key? key})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    if (!isNotNullAndEmpty(url)) return Container();

    return LayoutBuilder(builder: (context, constrains) {
      double? w;
      double? h;

      if (width! < constrains.maxWidth) {
        w = width;
        h = height;
      } else {
        w = constrains.maxWidth;
        h = height! / width! * w;
      }

      return ImageWidget.fromCachedNet(CachedImageBuilder(
        cacheManager: cacheManager,
        imageUrl: url,
        placeholder: placeholder,
        imageBuilder: (_, image) {
          return Container(
            width: w,
            height: h,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(radius),
              image: DecorationImage(image: image, fit: BoxFit.cover),
            ),
          );
        },
      ));
    });
  }
}
