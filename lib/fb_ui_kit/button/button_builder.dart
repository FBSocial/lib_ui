// ignore_for_file: must_be_immutable

/*
 * @FilePath       : /social/lib/widgets/lib_ui_kit/button/button_builder.dart
 * 
 * @Info           : 统一组件：图标（可选）+ 文字 按钮
 * 
 *        详细说明地址： [https://idreamsky.feishu.cn/wiki/wikcnV26O1T6CuOHDrlyZkkVbJQ]
 *        UI设计稿地址： [https://lanhuapp.com/web/#/item/project/detailDetach?pid=5218aaca-eb1f-445b-acc9-84885113b30b&image_id=43088c96-d845-475d-9218-abfbcb1dfaf3&project_id=5218aaca-eb1f-445b-acc9-84885113b30b&fromEditor=true]
 *        交互规范：    [https://idreamsky.feishu.cn/wiki/wikcn1JqxPhAlhcDMNbsUVFkxKf]
 * 
 * @Author         : Whiskee Chan
 * @Date           : 2022-02-23 15:55:35
 * @Version        : 1.0.0
 * 
 * Copyright 2022 iDreamSky FanBook, All Rights Reserved.
 * 
 * @LastEditors    : Whiskee Chan
 * @LastEditTime   : 2022-03-01 16:18:07
 * 
 */

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:lib_theme/app_theme.dart';
import 'package:lib_theme/get_theme.dart';

/// 枚举 - 按钮类型
enum FbButtonType {
  text, // 无底色无边框
  elevated, // 底色填充
  subElevated, // 灰度底填充
  lightElevated, // 浅色底填充
  outlined, // 带边框无底色
  subOutlined, // 灰度边框无底色
  warning, // 警告
}

/// 枚举 - 按钮状态
enum FbButtonStatus {
  normal, // 正常
  unable, // 不可用
  disable, // 禁用
  finish, // 完成
  loading, // 加载中
}

/// 枚举 - 按钮大小
enum FbButtonSize {
  small, // 小按钮
  middle, // 中按钮
  big, // 大按钮
  free, // 自由（可扩展width和height）
}

/// 全局基础参数
//  大小：小按钮
const Size kFbButtonSmallSize = Size(60, 32);
//  大小：中按钮
const Size kFbButtonMiddleSize = Size(184, 36);
//  大小：大按钮
const Size kFbButtonBigSize = Size(240, 44);

class FbButton extends StatelessWidget {
  // ====== Properties: Constant ====== //
  //  按钮文案
  final String? text;

  //  按钮类型
  final FbButtonType type;

  //  按钮状态
  final FbButtonStatus status;

  //  设计规范按钮大小
  final FbButtonSize size;

  //  宽度：仅在size为free的时候生效
  final double? width;

  //  高度：尽在size为free的时候生效
  final double? height;

  //  圆角
  final double? radius;

  //  是否使用半圆角
  final bool isOval;

  //  按钮文案大小
  final double? textSize;

  //  图标
  final IconData? icon;

  //  主色
  final Color? primaryColor;

  //  单击回调
  final VoidCallback? onPressed;

  //  长按回调
  final VoidCallback? onLongPress;

  //  焦点节点
  final FocusNode? focusNode;

  //  自动焦点
  final bool autofocus;

  //  边界裁剪模式
  final Clip clipBehavior;

  // ====== Properties: Variable ====== //
  //  点击正在执行
  bool _isPressNow = false;

  // ====== Properties: Get ====== //
  //  获取正确颜色
  Color get _primaryColor => primaryColor ?? Get.themeToken.fg.blue1;

  FbButton(
    this.text, {
    Key? key,
    this.type = FbButtonType.text,
    this.status = FbButtonStatus.normal,
    this.size = FbButtonSize.small,
    this.width = double.infinity,
    this.height = double.infinity,
    this.radius = 8,
    this.isOval = true,
    this.textSize,
    this.icon,
    this.primaryColor,
    this.onPressed,
    this.onLongPress,
    this.focusNode,
    this.autofocus = false,
    this.clipBehavior = Clip.none,
  })  : assert(text != null && text.isNotEmpty),
        super(key: key);

  // 工厂函数: 生产纯文字按钮
  factory FbButton.text(
    String text, {
    Key? key,
    FbButtonStatus? status,
    FbButtonSize? size,
    double? textSize,
    Color? primaryColor,
    VoidCallback onPressed,
    VoidCallback? onLongPress,
  }) = _FbTextButton;

  // 工厂函数: 生产背景填充按钮
  factory FbButton.elevated(
    String text, {
    Key? key,
    FbButtonStatus? status,
    FbButtonSize? size,
    double? width,
    double? height,
    double? radius,
    bool? isOval,
    double? textSize,
    IconData? icon,
    Color? primaryColor,
    VoidCallback onPressed,
    VoidCallback? onLongPress,
  }) = _FbElevatedButton;

  // 工厂函数: 生产背景次填充按钮
  factory FbButton.subElevated(
    String text, {
    Key? key,
    FbButtonStatus? status,
    FbButtonSize? size,
    double? width,
    double? height,
    double? radius,
    bool? isOval,
    double? textSize,
    IconData? icon,
    Color? primaryColor,
    VoidCallback onPressed,
    VoidCallback? onLongPress,
  }) = _FbSubElevatedButton;

  // 工厂函数: 生产背景浅色填充按钮
  factory FbButton.lightElevated(
    String text, {
    Key? key,
    FbButtonStatus? status,
    FbButtonSize? size,
    double? width,
    double? height,
    double? radius,
    bool? isOval,
    double? textSize,
    IconData? icon,
    Color? primaryColor,
    VoidCallback onPressed,
    VoidCallback? onLongPress,
  }) = _FbLightElevatedButton;

  // 工厂函数: 生产线性按钮
  factory FbButton.outlined(
    String text, {
    Key? key,
    FbButtonStatus? status,
    FbButtonSize? size,
    double? width,
    double? height,
    double? radius,
    bool? isOval,
    double? textSize,
    IconData? icon,
    Color? primaryColor,
    VoidCallback onPressed,
    VoidCallback? onLongPress,
  }) = _FbOutlinedButton;

  // 工厂函数: 生产次线性（灰色）按钮
  factory FbButton.subOutlined(
    String text, {
    Key? key,
    FbButtonStatus? status,
    FbButtonSize? size,
    double? width,
    double? height,
    double? radius,
    bool? isOval,
    double? textSize,
    IconData? icon,
    Color? primaryColor,
    VoidCallback onPressed,
    VoidCallback? onLongPress,
  }) = _FbSubOutlinedButton;

  // 工厂函数: 警告按钮
  factory FbButton.warning(
    String text, {
    Key? key,
    FbButtonStatus? status,
    FbButtonSize? size,
    double? width,
    double? height,
    double? radius,
    bool isOval,
    double? textSize,
    IconData? icon,
    VoidCallback onPressed,
    VoidCallback? onLongPress,
  }) = _FbWarningButton;

  @override
  Widget build(BuildContext context) {
    //  根据size获取按钮大小
    Size btnSize = Size.zero;
    switch (size) {
      case FbButtonSize.small:
        btnSize = kFbButtonSmallSize;
        break;
      case FbButtonSize.middle:
        btnSize = kFbButtonMiddleSize;
        break;
      case FbButtonSize.big:
        btnSize = kFbButtonBigSize;
        break;
      default:
        btnSize = Size(width ?? 0, height ?? kFbButtonBigSize.height);
        break;
    }
    //  文本按钮宽度随文字变化
    if (type == FbButtonType.text) {
      btnSize = Size(0, btnSize.height);
    }
    return _assembleChild(context, btnSize);
  }

  // ====== Method: Private ====== //

  /// 组装：按钮视图
  Widget _assembleChild(BuildContext context, Size btnSize) {
    //  按钮样式
    final ButtonStyle buttonStyle = _getButtonStyle(context, btnSize);
    //  按钮大小
    final double iconSize = size != FbButtonSize.big ? 14.67 : 20;
    //  按钮视图：文字/加载圈
    Widget child = status != FbButtonStatus.loading
        ? Text(
            text!,
            style: TextStyle(
              fontSize: textSize ?? (size == FbButtonSize.big ? 16 : 14),
            ),
          )
        : SizedBox(
            width: iconSize,
            height: iconSize,
            child: CircularProgressIndicator(
              backgroundColor: type == FbButtonType.elevated
                  ? Colors.white
                  : type == FbButtonType.subOutlined
                      ? AppTheme.of(context).fg.b60
                      : _primaryColor,
              strokeWidth: 1.5,
            ),
          );
    //  设置子视图大小 - 文字按钮不处理
    if (type != FbButtonType.text) {
      child = SizedBox(
        width: btnSize.width,
        height: btnSize.height,
        child: Center(child: child),
      );
    }
    //  根据类型选择创建相应的按钮
    switch (type) {
      case FbButtonType.elevated:
      case FbButtonType.subElevated:
      case FbButtonType.lightElevated:
      case FbButtonType.warning:
        if (size == FbButtonSize.small ||
            status == FbButtonStatus.loading ||
            icon == null) {
          return ElevatedButton(
            onPressed: _onThrottlePressed,
            onLongPress: onLongPress,
            style: buttonStyle,
            child: child,
          );
        }
        return ElevatedButton.icon(
          onPressed: _onThrottlePressed,
          onLongPress: onLongPress,
          style: buttonStyle,
          icon: Icon(
            icon,
            size: iconSize,
          ),
          label: child,
        );
      case FbButtonType.outlined:
      case FbButtonType.subOutlined:
        if (size == FbButtonSize.small ||
            status == FbButtonStatus.loading ||
            icon == null) {
          return OutlinedButton(
            onPressed: _onThrottlePressed,
            onLongPress: onLongPress,
            style: buttonStyle,
            child: child,
          );
        }
        return OutlinedButton.icon(
          onPressed: _onThrottlePressed,
          onLongPress: onLongPress,
          style: buttonStyle,
          icon: Icon(
            icon,
            size: iconSize,
          ),
          label: child,
        );
      default:
        //  纯文字按钮不需要加载圈
        return TextButton(
          onPressed: _onThrottlePressed,
          onLongPress: onLongPress,
          style: buttonStyle,
          child: child,
        );
    }
  }

  /// 获取按钮样式
  ButtonStyle _getButtonStyle(BuildContext context, Size btnSize) =>
      ButtonStyle(
        //  背景色
        backgroundColor: MaterialStateProperty.resolveWith((states) {
          //  纯文字按钮不需要展示背景变化
          if (type == FbButtonType.text) {
            return Colors.transparent;
          }
          return _getBackgroundColor(context);
        }),
        //  前景色
        foregroundColor: MaterialStateProperty.resolveWith((states) {
          final Color? fgColor = _getForegroundColor(context);
          //  非normal状态下不变化文字样式
          if (status == FbButtonStatus.normal) {
            //  文字状态变化：
            //  1、按压颜色要变深
            if (states.contains(MaterialState.pressed)) {
              return Color.alphaBlend(
                  AppTheme.of(context).fg.b10.withOpacity(0.1), fgColor!);
            }
            //  2、戍边经过要变浅
            if (states.contains(MaterialState.hovered)) {
              return Color.alphaBlend(
                  AppTheme.of(context).bg.bg1.withOpacity(0.1), fgColor!);
            }
          }
          return fgColor;
        }),
        //  点击效果
        overlayColor: MaterialStateProperty.resolveWith((states) {
          //  1、不可展示情况：
          //  - 纯文字按钮
          //  - normal状态下
          if (type != FbButtonType.text && status == FbButtonStatus.normal) {
            //  -- 按压状态：
            if (states.contains(MaterialState.pressed)) {
              return AppTheme.of(context).fg.b10.withOpacity(0.1);
            }
            //  -- 鼠标经过状态：
            if (states.contains(MaterialState.hovered)) {
              return AppTheme.of(context).bg.bg1.withOpacity(0.1);
            }
          }
          //  2、其它情况：透明
          return Colors.transparent;
        }),
        minimumSize: MaterialStateProperty.all(
            type == FbButtonType.text ? Size.zero : btnSize),
        padding: MaterialStateProperty.all(
          const EdgeInsets.symmetric(horizontal: 2),
        ),
        //  边框
        side: MaterialStateProperty.all(_getBorderSide(context)),
        //  圆角：按钮高度 / 6 （规范提供公式）
        shape: MaterialStateProperty.all(
          RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(
              isOval == true
                  ? btnSize.height / 2
                  : radius ?? (btnSize.height / 8),
            ),
          ),
        ),
        tapTargetSize: MaterialTapTargetSize.padded,
      );

  ///  获取按钮颜色
  Color _getBackgroundColor(BuildContext context) {
    Color bgColor = Colors.transparent;
    switch (type) {
      case FbButtonType.elevated:
      case FbButtonType.warning:
        bgColor = _primaryColor;
        break;
      case FbButtonType.subElevated:
        bgColor = AppTheme.of(context).fg.b5;
        break;
      case FbButtonType.lightElevated:
        bgColor = _primaryColor.withOpacity(0.1);
        break;
      default:
        break;
    }
    switch (status) {
      case FbButtonStatus.unable:
        return type == FbButtonType.elevated
            ? bgColor.withOpacity(0.4)
            : bgColor;
      case FbButtonStatus.disable:
      case FbButtonStatus.finish:
        if (type == FbButtonType.text) {
          return bgColor;
        }
        return AppTheme.of(context).fg.b10;
      default:
        return bgColor;
    }
  }

  ///  获取按钮姿势图样式
  Color? _getForegroundColor(BuildContext context) {
    Color? _getFgColor = _primaryColor;
    switch (type) {
      case FbButtonType.elevated:
      case FbButtonType.warning:
        _getFgColor = Colors.white;
        break;
      case FbButtonType.subOutlined:
        _getFgColor = AppTheme.of(context).fg.b100;
        break;
      default:
        break;
    }
    switch (status) {
      case FbButtonStatus.unable:
        _getFgColor = _getFgColor.withOpacity(0.4);
        break;
      case FbButtonStatus.disable:
        _getFgColor = AppTheme.of(context).fg.b20;
        break;
      case FbButtonStatus.finish:
        _getFgColor = AppTheme.of(context).fg.b40;
        break;
      default:
        break;
    }
    return _getFgColor;
  }

  /// 获取按钮边框
  BorderSide _getBorderSide(BuildContext context) {
    //  只有outlined和subOutlined才需要边框
    if (type != FbButtonType.outlined && type != FbButtonType.subOutlined) {
      return BorderSide.none;
    }
    //  边框颜色
    Color borderColor = type == FbButtonType.outlined
        ? _primaryColor
        : AppTheme.of(context).fg.b20;
    switch (status) {
      case FbButtonStatus.unable:
        if (type == FbButtonType.outlined) {
          borderColor.withOpacity(0.4);
        }
        break;
      case FbButtonStatus.disable:
      case FbButtonStatus.finish:
        borderColor = Colors.transparent;
        break;
      default:
        break;
    }
    return BorderSide(color: borderColor, width: 0.5);
  }

  /// 点击防抖
  void _onThrottlePressed() {
    if (onPressed == null || _isPressNow) {
      return;
    }
    _isPressNow = true;
    Future.delayed(const Duration(milliseconds: 300)).whenComplete(() {
      _isPressNow = false;
      if (status != FbButtonStatus.normal && status != FbButtonStatus.finish) {
        return;
      }
      onPressed!();
    });
  }
}

/// 统一按钮样式：文字按钮
class _FbTextButton extends FbButton {
  _FbTextButton(
    String text, {
    Key? key,
    FbButtonStatus? status,
    FbButtonSize? size,
    double? textSize,
    Color? primaryColor,
    VoidCallback? onPressed,
    VoidCallback? onLongPress,
  }) : super(text,
            key: key,
            status: status ?? FbButtonStatus.normal,
            size: size ?? FbButtonSize.small,
            textSize: textSize,
            primaryColor: primaryColor,
            onPressed: onPressed,
            onLongPress: onLongPress);
}

/// 统一按钮样式：背景填充按钮
class _FbElevatedButton extends FbButton {
  _FbElevatedButton(
    String text, {
    Key? key,
    FbButtonStatus? status,
    FbButtonSize? size,
    double? width,
    double? height,
    double? radius,
    bool? isOval,
    double? textSize,
    IconData? icon,
    Color? primaryColor,
    VoidCallback? onPressed,
    VoidCallback? onLongPress,
  }) : super(
          text,
          key: key,
          type: FbButtonType.elevated,
          status: status ?? FbButtonStatus.normal,
          icon: icon,
          size: size ?? FbButtonSize.small,
          width: width,
          height: height,
          radius: radius,
          isOval: isOval ?? true,
          textSize: textSize,
          primaryColor: primaryColor,
          onPressed: onPressed,
          onLongPress: onLongPress,
        );
}

/// 统一按钮样式：次背景填充(灰色)按钮
class _FbSubElevatedButton extends FbButton {
  _FbSubElevatedButton(
    String text, {
    Key? key,
    FbButtonStatus? status,
    FbButtonSize? size,
    double? width,
    double? height,
    double? radius,
    bool? isOval,
    double? textSize,
    IconData? icon,
    Color? primaryColor,
    VoidCallback? onPressed,
    VoidCallback? onLongPress,
  }) : super(
          text,
          key: key,
          type: FbButtonType.subElevated,
          status: status ?? FbButtonStatus.normal,
          icon: icon,
          size: size ?? FbButtonSize.small,
          width: width,
          height: height,
          radius: radius,
          isOval: isOval ?? true,
          textSize: textSize,
          primaryColor: primaryColor,
          onPressed: onPressed,
          onLongPress: onLongPress,
        );
}

/// 统一按钮样式：背景填充(浅色)按钮
class _FbLightElevatedButton extends FbButton {
  _FbLightElevatedButton(
    String text, {
    Key? key,
    FbButtonStatus? status,
    FbButtonSize? size,
    double? width,
    double? height,
    double? radius,
    bool? isOval,
    double? textSize,
    IconData? icon,
    Color? primaryColor,
    VoidCallback? onPressed,
    VoidCallback? onLongPress,
  }) : super(
          text,
          key: key,
          type: FbButtonType.lightElevated,
          status: status ?? FbButtonStatus.normal,
          icon: icon,
          size: size ?? FbButtonSize.small,
          width: width,
          height: height,
          radius: radius,
          isOval: isOval ?? true,
          textSize: textSize,
          primaryColor: primaryColor,
          onPressed: onPressed,
          onLongPress: onLongPress,
        );
}

/// 统一按钮样式：线性按钮
class _FbOutlinedButton extends FbButton {
  _FbOutlinedButton(
    String text, {
    Key? key,
    FbButtonStatus? status,
    FbButtonSize? size,
    double? width,
    double? height,
    double? radius,
    bool? isOval,
    double? textSize,
    IconData? icon,
    Color? primaryColor,
    VoidCallback? onPressed,
    VoidCallback? onLongPress,
  }) : super(
          text,
          key: key,
          type: FbButtonType.outlined,
          status: status ?? FbButtonStatus.normal,
          icon: icon,
          size: size ?? FbButtonSize.small,
          width: width,
          height: height,
          radius: radius,
          isOval: isOval ?? true,
          textSize: textSize,
          primaryColor: primaryColor,
          onPressed: onPressed,
          onLongPress: onLongPress,
        );
}

/// 统一按钮样式：次线性按钮
class _FbSubOutlinedButton extends FbButton {
  _FbSubOutlinedButton(
    String text, {
    Key? key,
    FbButtonStatus? status,
    FbButtonSize? size,
    double? width,
    double? height,
    double? radius,
    bool? isOval,
    double? textSize,
    IconData? icon,
    Color? primaryColor,
    VoidCallback? onPressed,
    VoidCallback? onLongPress,
  }) : super(
          text,
          key: key,
          status: status ?? FbButtonStatus.normal,
          type: FbButtonType.subOutlined,
          icon: icon,
          size: size ?? FbButtonSize.small,
          width: width,
          height: height,
          radius: radius,
          isOval: isOval ?? true,
          textSize: textSize,
          primaryColor: primaryColor,
          onPressed: onPressed,
          onLongPress: onLongPress,
        );
}

/// 统一按钮样式：警告按钮
class _FbWarningButton extends FbButton {
  _FbWarningButton(
    String text, {
    Key? key,
    FbButtonStatus? status,
    FbButtonSize? size,
    double? width,
    double? height,
    double? radius,
    bool? isOval,
    double? textSize,
    IconData? icon,
    VoidCallback? onPressed,
    VoidCallback? onLongPress,
  }) : super(
          text,
          key: key,
          status: status ?? FbButtonStatus.normal,
          type: FbButtonType.warning,
          icon: icon,
          size: size ?? FbButtonSize.small,
          width: width,
          height: height,
          radius: radius,
          isOval: isOval ?? true,
          textSize: textSize,
          primaryColor: Get.themeToken.auxiliary.red,
          onPressed: onPressed,
          onLongPress: onLongPress,
        );
}
