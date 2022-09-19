import 'dart:io';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';

/// 裁剪圆形图片
class CircleImage extends StatelessWidget {
  /// 圆形半径
  final double radius;

  /// 图片的asset路径（从资源加载）
  final String? asset;

  /// 图片url链接（从网络加载）
  final String? url;

  /// 图片本地路径（从磁盘加载）
  final String? path;

  final BoxFit fit;

  final bool hasBorder;
  final Color? borderColor;

  /// 加载网络图片的占位组件
  final PlaceholderWidgetBuilder? placeholder;

  const CircleImage({
    Key? key,
    required this.radius,
    this.asset,
    this.url,
    this.path,
    this.fit = BoxFit.cover,
    this.hasBorder = false,
    this.borderColor,
    this.placeholder,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final size = radius * 2;
    Widget? img;

    if (asset != null) {
      img = Image.asset(
        asset!,
        fit: fit,
        width: size,
        height: size,
      );
    } else if (path != null) {
      img = Image.file(
        File(path!),
        fit: fit,
        width: size,
        height: size,
      );
    } else if (url != null) {
      img = CachedNetworkImage(
        imageUrl: url!,
        fit: fit,
        width: size,
        height: size,
        placeholder: placeholder,
      );
    }

    if (img == null) {
      return const SizedBox();
    }

    final circleImg = ClipOval(child: img);
    if (hasBorder) {
      return Container(
        decoration: BoxDecoration(
          border: Border.all(
              color: borderColor ?? Theme.of(context).primaryColor, width: 0.5),
          borderRadius: BorderRadius.circular(radius),
        ),
        child: circleImg,
      );
    }
    return circleImg;
  }
}
