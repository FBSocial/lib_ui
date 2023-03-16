import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_cache_manager/flutter_cache_manager.dart';
import 'package:lib_image/fb_image_show_widget.dart';
import 'package:lib_theme/app_theme.dart';
import 'package:lib_ui/texture_image.dart';
import 'package:lib_utils/universal_platform.dart';

class Avatar extends StatelessWidget {
  final String? url;
  final double radius;
  final File? file;
  final Key? widgetKey;
  final BaseCacheManager? cacheManager;
  final double? size;
  final bool? showBorder;
  final bool useTexture;
  final Color? decorationColor;

  const Avatar(
      {this.url,
      this.file,
      this.radius = 15,
      this.widgetKey,
      this.cacheManager,
      this.size,
      this.showBorder,
      this.useTexture = true,
      this.decorationColor,
      Key? key})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    if (UniversalPlatform.isMobileDevice &&
        useTexture &&
        TextureImage.useTexture) {
      return TextureAvatar(
          url: url,
          file: file,
          radius: radius,
          widgetKey: widgetKey,
          cacheManager: cacheManager,
          size: size,
          showBorder: showBorder);
    } else {
      return FlutterAvatar(
        url: url,
        file: file,
        radius: radius,
        widgetKey: widgetKey,
        cacheManager: cacheManager,
        size: size,
        showBorder: showBorder,
        decorationColor: decorationColor,
      );
    }
  }
}

class TextureAvatar extends StatelessWidget {
  final String? url;
  final double radius;
  final File? file;
  final Key? widgetKey;
  final BaseCacheManager? cacheManager;
  final double? size;
  final bool? showBorder;

  const TextureAvatar(
      {this.url,
      this.file,
      this.radius = 15,
      this.widgetKey,
      this.cacheManager,
      this.size,
      this.showBorder,
      Key? key})
      : super(key: key);

// : assert((file == null && url != null && url != '') || (file != null),
//       'file and url cannot be empty at the same time');
  @override
  Widget build(BuildContext context) {
    final _size = size ?? radius * 2;
    final borderColor = AppTheme.of(context).fg.b20;
    final _showBorder = showBorder ?? true;
    final foregroundDecoration = BoxDecoration(
      border: _showBorder ? Border.all(color: borderColor, width: 0.5) : null,
      shape: BoxShape.circle,
    );
    final innerDecoration = BoxDecoration(
      color: AppTheme.of(context).bg.bg1,
      shape: BoxShape.circle,
    );
    final devicePixelRatio = MediaQuery.of(context).devicePixelRatio;
    if (file == null && (url == null || url == '')) {
      return Container(
        width: _size,
        height: _size,
        decoration: BoxDecoration(
          color: Theme.of(context).dividerColor,
          shape: BoxShape.circle,
        ),
      );
    }
    if (file != null) {
      return Container(
        width: _size,
        height: _size,
        decoration: BoxDecoration(
          image: DecorationImage(image: FileImage(file!), fit: BoxFit.cover),
          shape: BoxShape.circle,
        ),
        foregroundDecoration: foregroundDecoration,
      );
    }
    return Container(
      width: _size,
      height: _size,
      decoration: innerDecoration,
      foregroundDecoration: foregroundDecoration,
      child: TextureImage(url,
          key: widgetKey,
          width: _size * devicePixelRatio,
          height: _size * devicePixelRatio,
          radius: radius * devicePixelRatio),
    );
  }
}

/// 圆形头像
class FlutterAvatar extends StatelessWidget {
  final String? url;
  final double radius;
  final File? file;
  final Key? widgetKey;
  final BaseCacheManager? cacheManager;
  final double? size;
  final bool? showBorder;
  final Color? decorationColor;

  const FlutterAvatar(
      {this.url,
      this.file,
      this.radius = 15,
      this.widgetKey,
      this.cacheManager,
      this.size,
      this.showBorder,
      this.decorationColor,
      Key? key})
      : super(key: key);

  // : assert((file == null && url != null && url != '') || (file != null),
  //       'file and url cannot be empty at the same time');
  @override
  Widget build(BuildContext context) {
    final _size = size ?? radius * 2;
    final borderColor = AppTheme.of(context).fg.b10.withOpacity(0.2);
    final _showBorder = showBorder ?? true;
    final foregroundDecoration = BoxDecoration(
      border: _showBorder ? Border.all(color: borderColor, width: 0.5) : null,
      shape: BoxShape.circle,
    );
    if (file == null && (url == null || url == '')) {
      return Container(
        width: _size,
        height: _size,
        decoration: const BoxDecoration(
          shape: BoxShape.circle,
        ),
      );
    }
    if (file != null) {
      return Container(
        width: _size,
        height: _size,
        decoration: BoxDecoration(
          image: DecorationImage(image: FileImage(file!), fit: BoxFit.cover),
          shape: BoxShape.circle,
        ),
        foregroundDecoration: foregroundDecoration,
      );
    }
    return Container(
      width: _size,
      height: _size,
      key: widgetKey,
      alignment: Alignment.center,
      decoration: BoxDecoration(
        color: decorationColor ?? AppTheme.of(context).bg.bg1,
        shape: BoxShape.circle,
      ),
      foregroundDecoration: foregroundDecoration,
      child: FBImageShowWidget.network(
        url!,
        radius: radius,
        width: _size,
        height: _size,
        memCacheWidth: 225,
        cacheManager: cacheManager,
      ),
    );
  }
}
