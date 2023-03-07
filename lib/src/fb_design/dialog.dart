import 'package:lib_theme/lib_theme.dart';
import 'package:lib_ui/lib_ui.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:sliding_sheet/sliding_sheet.dart';

@immutable
class ActionSheetItem<T> {
  static ActionSheetItem divider = const ActionSheetItem('');

  final T? value;
  final String label;

  const ActionSheetItem(this.label, {this.value});

  @override
  String toString() => 'ActionSheetItem(label: $label, value: $value)';
}

class ActionSheet<T> extends StatelessWidget {
  /// static methods

  /// 通用底部选项列表弹窗
  ///
  /// [T]只支持[int]和[ValueKey]<int>两种返回格式，不传默认返回[int]
  ///
  /// [actions] Widget选项列表
  ///
  /// 当[T]为[int]时，返回当前点击的选项索引，取消返回-1，点击空白处返回null
  ///
  /// 当[T]为[ValueKey]<int>时，每个action组件必须传入ValueKey，
  /// 返回当前点击的选项的key，取消返回ValueKey(-1)，点击空白处返回null，
  /// 示例：
  /// final actions = [Text('选项A',key: const ValueKey(1))];
  /// showCustomActionSheet<ValueKey<int>>(actions);
  ///
  /// [footerFixed] 是否固定底部取消按钮，当列表可以滚动时需固定
  static Future<T?> showCustomActionSheet<T>(
    List<ActionSheetItem<T>> actions, {
    bool footerFixed = false,
    String? title,
    VoidCallback? onCancel,
    void Function(T)? onConfirm,
    double firstDividerHeight = 1,
    String? cancelText = '取消',
  }) {
    return showSlidingBottomSheet<T>(Get.context!,
        resizeToAvoidBottomInset: false, builder: (context) {
      return SlidingSheetDialog(
        axisAlignment: 1,
        color: AppTheme.of(context).bg.bg3,
        extendBody: true,
        elevation: 8,
        cornerRadius: 12,
        padding: EdgeInsets.zero,
        duration: kThemeAnimationDuration,
        avoidStatusBar: true,
        snapSpec: SnapSpec(
          snappings: const [0.9],
          onSnap: (state, snap) {},
        ),
        footerBuilder: cancelText == null
            ? null
            : (context, state) {
                return Container(
                  height: 56,
                  margin: const EdgeInsets.only(top: 8),
                  child: FbTextButton.primary(
                    cancelText.tr,
                    onTap: onCancel ?? Get.back,
                  ),
                );
              },
        builder: (_, state) {
          return ActionSheet<T>(
            title: title,
            actions: actions,
            onConfirm: onConfirm,
          );
        },
      );
    });
  }

  final String? title;
  final List<ActionSheetItem<T>> actions;
  final void Function(T)? onConfirm;

  const ActionSheet({
    required this.actions,
    Key? key,
    this.title,
    this.onConfirm,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Material(
      color: AppTheme.of(context).bg.bg3,
      child: SafeArea(
        child: Column(
          children: [
            if (title != null)
              Container(
                width: MediaQuery.of(context).size.width,
                constraints: const BoxConstraints(minHeight: 75),
                alignment: Alignment.center,
                decoration: BoxDecoration(
                  borderRadius:
                      const BorderRadius.vertical(top: Radius.circular(12)),
                  color: AppTheme.of(context).bg.bg3,
                ),
                child: Container(
                  padding: const EdgeInsets.fromLTRB(50, 22, 50, 22),
                  alignment: Alignment.center,
                  child: Text(title!.tr),
                ),
              ),
            if (title != null)
              Divider(
                color: AppTheme.of(context).bg.bg1,
              ),
            for (var i = 0; i < actions.length; i++)
              if (actions[i] == ActionSheetItem.divider)
                const Divider(height: 8)
              else
                ConstrainedBox(
                  constraints: const BoxConstraints(minHeight: 56),
                  child: FbTextButton.primary(
                    actions[i].label,
                    size: FbButtonSize.large,
                    onTap: () {
                      final retVal = actions[i].value ?? i;
                      if (onConfirm != null) {
                        onConfirm!(retVal as T);
                      } else {
                        Get.back(result: retVal);
                      }
                    },
                  ),
                ),
          ],
        ),
      ),
    );
  }
}
