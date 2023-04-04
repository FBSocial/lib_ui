/*
 * @FilePath       : /social/lib/app/modules/ui_gallery/views/ui_fb_button_example.dart
 *
 * @Info           : UI样例展示： 统一按钮
 *
 * @Author         : Whiskee Chan
 * @Date           : 2022-02-25 16:47:51
 * @Version        : 1.0.0
 *
 * Copyright 2022 iDreamSky FanBook, All Rights Reserved.
 *
 * @LastEditors    : Whiskee Chan
 * @LastEditTime   : 2022-03-11 16:47:03
 *
 */

import 'package:flutter/material.dart';
import 'package:lib_ui/lib_ui.dart';

class ButtonExamplePage extends StatefulWidget {
  const ButtonExamplePage({Key? key}) : super(key: key);

  @override
  _ButtonExamplePageState createState() => _ButtonExamplePageState();
}

class _ButtonExamplePageState extends State<ButtonExamplePage> {
  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: ListView(
      children: [
        _buildTextButtons(context),
        _buildOutlinedButtons(),
        _buildFillButtons(),
      ],
    ));
  }

  Widget _buildTextButtons(BuildContext context) {
    return makeSection(
      "FbTextButton - 文字按钮",
      child: DefaultTextStyle(
        style: Theme.of(context).textTheme.bodySmall!,
        child: Table(
          defaultVerticalAlignment: TableCellVerticalAlignment.middle,
          columnWidths: const <int, TableColumnWidth>{
            0: FixedColumnWidth(120),
            1: FixedColumnWidth(120),
            2: FixedColumnWidth(120),
            3: FixedColumnWidth(120),
            4: FixedColumnWidth(120),
          },
          children: <TableRow>[
            TableRow(
              children: <Widget>[
                const SizedBox(),
                ...[
                  "主按钮（小）",
                  "警示按钮（小）",
                  "主按钮（大）",
                  "警示按钮（大）",
                ]
                    .map((e) => Center(
                            child: Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Text(e),
                        )))
                    .toList(growable: false),
              ],
            ),
            TableRow(
              children: <Widget>[
                const Center(child: Text("正常态")),
                FbTextButton.primary("文字按钮", onTap: () => {}),
                FbTextButton.dangerous("文字按钮", onTap: () => {}),
                FbTextButton.primary("文字按钮",
                    size: FbButtonSize.large, onTap: () => {}),
                FbTextButton.dangerous("文字按钮",
                    size: FbButtonSize.large, onTap: () => {}),
              ],
            ),
            TableRow(
              children: <Widget>[
                const Center(child: Text("未激活")),
                FbTextButton.primary("文字按钮",
                    state: FbButtonState.deactivated, onTap: () => {}),
                FbTextButton.dangerous("文字按钮",
                    state: FbButtonState.deactivated, onTap: () => {}),
                FbTextButton.primary("文字按钮",
                    state: FbButtonState.deactivated,
                    size: FbButtonSize.large,
                    onTap: () => {}),
                FbTextButton.dangerous("文字按钮",
                    state: FbButtonState.deactivated,
                    size: FbButtonSize.large,
                    onTap: () => {}),
              ],
            ),
            TableRow(
              children: <Widget>[
                const Center(child: Text("禁用")),
                FbTextButton.primary("文字按钮",
                    state: FbButtonState.disabled, onTap: () => {}),
                FbTextButton.dangerous("文字按钮",
                    state: FbButtonState.disabled, onTap: () => {}),
                FbTextButton.primary("文字按钮",
                    state: FbButtonState.disabled,
                    size: FbButtonSize.large,
                    onTap: () => {}),
                FbTextButton.dangerous("文字按钮",
                    state: FbButtonState.disabled,
                    size: FbButtonSize.large,
                    onTap: () => {}),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildOutlinedButtons() {
    TableRow makeRow(String title, {required FbButtonState state}) {
      return TableRow(
        children: <Widget>[
          SizedBox(height: 60, child: Center(child: Text(title))),
          FbOutlinedButton.primary(title, state: state, onTap: () => {}),
          FbOutlinedButton.secondary(title, state: state, onTap: () => {}),
          FbOutlinedButton.primary(title,
              state: state, size: FbButtonSize.medium, onTap: () => {}),
          FbOutlinedButton.primary(
            title,
            state: state,
            icon: Icons.supervisor_account,
            size: FbButtonSize.medium,
            onTap: () => {},
          ),
          FbOutlinedButton.secondary(title,
              state: state, size: FbButtonSize.medium, onTap: () => {}),
          FbOutlinedButton.secondary(title,
              state: state,
              icon: Icons.supervisor_account,
              size: FbButtonSize.medium,
              onTap: () => {}),
          FbOutlinedButton.primary(title,
              state: state, size: FbButtonSize.large, onTap: () => {}),
          FbOutlinedButton.primary(title,
              state: state,
              icon: Icons.supervisor_account,
              size: FbButtonSize.large,
              onTap: () => {}),
          FbOutlinedButton.secondary(title,
              state: state, size: FbButtonSize.large, onTap: () => {}),
          FbOutlinedButton.secondary(title,
              state: state,
              icon: Icons.supervisor_account,
              size: FbButtonSize.large,
              onTap: () => {}),
        ],
      );
    }

    return makeSection(
      "FbOutlinedButton - 边框按钮",
      child: DefaultTextStyle(
        style: Theme.of(context).textTheme.bodySmall!,
        child: Table(
          defaultVerticalAlignment: TableCellVerticalAlignment.middle,
          columnWidths: const <int, TableColumnWidth>{
            0: FixedColumnWidth(120),
            1: FixedColumnWidth(60 + 16),
            2: FixedColumnWidth(60 + 16),
            3: FixedColumnWidth(184 + 16),
            4: FixedColumnWidth(184 + 16),
            5: FixedColumnWidth(184 + 16),
            6: FixedColumnWidth(184 + 16),
            7: FixedColumnWidth(240 + 16),
            8: FixedColumnWidth(240 + 16),
            9: FixedColumnWidth(240 + 16),
            10: FixedColumnWidth(240 + 16),
            11: FixedColumnWidth(300 + 16),
            12: FixedColumnWidth(300 + 16),
            13: FixedColumnWidth(300 + 16),
            14: FixedColumnWidth(300 + 16),
          },
          children: <TableRow>[
            TableRow(
              children: <Widget>[
                const SizedBox(),
                ...[
                  "主按钮（小）",
                  "次按钮（小）",
                  "主按钮（中）",
                  "带图标主按钮（中）",
                  "次按钮（中）",
                  "带图标次按钮（中）",
                  "主按钮（大）",
                  "带图标主按钮（大）",
                  "次按钮（大）",
                  "带图标次按钮（大）",
                  "主按钮（跟随约束）",
                  "带图标主按钮（跟随约束）",
                  "次按钮（跟随约束）",
                  "带图标次按钮（跟随约束）",
                ]
                    .map((e) => Center(
                            child: Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Text(e),
                        )))
                    .toList(growable: false),
              ],
            ),
            makeRow("正常", state: FbButtonState.normal),
            makeRow("未激活", state: FbButtonState.deactivated),
            makeRow("禁用", state: FbButtonState.disabled),
            makeRow("完成", state: FbButtonState.completed),
            makeRow("加载", state: FbButtonState.loading),
          ],
        ),
      ),
    );
  }

  Widget _buildFillButtons() {
    TableRow makeRow(String title, {required FbButtonState state}) {
      return TableRow(
        children: <Widget>[
          SizedBox(height: 60, child: Center(child: Text(title))),
          FbFilledButton.primary(title, state: state, onTap: () => {}),
          FbFilledButton.secondary(title, state: state, onTap: () => {}),
          FbFilledButton.tertiary(title, state: state, onTap: () => {}),
          FbFilledButton.dangerous(title, state: state, onTap: () => {}),
          FbFilledButton.primary(title,
              state: state, size: FbButtonSize.medium, onTap: () => {}),
          FbFilledButton.primary(
            title,
            state: state,
            size: FbButtonSize.medium,
            icon: Icons.supervisor_account,
            onTap: () => {},
          ),
          FbFilledButton.secondary(title,
              state: state, size: FbButtonSize.medium, onTap: () => {}),
          FbFilledButton.secondary(
            title,
            state: state,
            size: FbButtonSize.medium,
            icon: Icons.supervisor_account,
            onTap: () => {},
          ),
          FbFilledButton.tertiary(title,
              state: state, size: FbButtonSize.medium, onTap: () => {}),
          FbFilledButton.tertiary(
            title,
            state: state,
            size: FbButtonSize.medium,
            icon: Icons.supervisor_account,
            onTap: () => {},
          ),
          FbFilledButton.dangerous(title,
              state: state, size: FbButtonSize.medium, onTap: () => {}),
          FbFilledButton.primary(title,
              state: state, size: FbButtonSize.large, onTap: () => {}),
          FbFilledButton.primary(
            title,
            state: state,
            size: FbButtonSize.large,
            icon: Icons.supervisor_account,
            onTap: () => {},
          ),
          FbFilledButton.secondary(title,
              state: state, size: FbButtonSize.large, onTap: () => {}),
          FbFilledButton.secondary(
            title,
            state: state,
            size: FbButtonSize.large,
            icon: Icons.supervisor_account,
            onTap: () => {},
          ),
          FbFilledButton.tertiary(title,
              state: state, size: FbButtonSize.large, onTap: () => {}),
          FbFilledButton.tertiary(
            title,
            state: state,
            size: FbButtonSize.large,
            icon: Icons.supervisor_account,
            onTap: () => {},
          ),
          FbFilledButton.dangerous(title,
              state: state, size: FbButtonSize.large, onTap: () => {}),
        ],
      );
    }

    return makeSection(
      "FbFilledButton - 实色按钮",
      child: DefaultTextStyle(
        style: Theme.of(context).textTheme.bodySmall!,
        child: Table(
          defaultVerticalAlignment: TableCellVerticalAlignment.middle,
          columnWidths: const <int, TableColumnWidth>{
            0: FixedColumnWidth(120),
            1: FixedColumnWidth(60 + 16),
            2: FixedColumnWidth(60 + 16),
            3: FixedColumnWidth(60 + 16),
            4: FixedColumnWidth(60 + 16),
            5: FixedColumnWidth(184 + 16),
            6: FixedColumnWidth(184 + 16),
            7: FixedColumnWidth(184 + 16),
            8: FixedColumnWidth(184 + 16),
            9: FixedColumnWidth(184 + 16),
            10: FixedColumnWidth(184 + 16),
            11: FixedColumnWidth(184 + 16),
            12: FixedColumnWidth(240 + 16),
            13: FixedColumnWidth(240 + 16),
            14: FixedColumnWidth(240 + 16),
            15: FixedColumnWidth(240 + 16),
            16: FixedColumnWidth(240 + 16),
            17: FixedColumnWidth(240 + 16),
            18: FixedColumnWidth(240 + 16),
            19: FixedColumnWidth(300 + 16),
            20: FixedColumnWidth(300 + 16),
            21: FixedColumnWidth(300 + 16),
            22: FixedColumnWidth(300 + 16),
            23: FixedColumnWidth(300 + 16),
            24: FixedColumnWidth(300 + 16),
            25: FixedColumnWidth(300 + 16),
          },
          children: <TableRow>[
            TableRow(
              children: <Widget>[
                const SizedBox(),
                ...[
                  "主按钮（小）",
                  "次按钮（小）",
                  "次按钮 2（小）",
                  "警示按钮（小）",
                  "主按钮（中）",
                  "带图标主按钮（中）",
                  "次按钮（中）",
                  "带图标次按钮（中）",
                  "次按钮 2（中）",
                  "带图标次按钮 2（中）",
                  "警示按钮（中）",
                  "主按钮（大）",
                  "带图标主按钮（大）",
                  "次按钮（大）",
                  "带图标次按钮（大）",
                  "次按钮 2（大）",
                  "带图标次按钮 2（大）",
                  "警示按钮（大）",
                  "主按钮（跟随约束）",
                  "带图标主按钮（跟随约束）",
                  "次按钮（跟随约束）",
                  "带图标次按钮（跟随约束）",
                  "次按钮 2（跟随约束）",
                  "带图标次按钮 2（跟随约束）",
                  "警示按钮（跟随约束）",
                ]
                    .map((e) => Center(
                            child: Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Text(e, textAlign: TextAlign.center),
                        )))
                    .toList(growable: false),
              ],
            ),
            makeRow("正常", state: FbButtonState.normal),
            makeRow("未激活", state: FbButtonState.deactivated),
            makeRow("禁用", state: FbButtonState.disabled),
            makeRow("完成", state: FbButtonState.completed),
            makeRow("加载", state: FbButtonState.loading),
          ],
        ),
      ),
    );
  }

  Widget makeSection(String title, {required Widget child}) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Card(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Text(title),
            ),
            const Divider(),
            SingleChildScrollView(
                padding: const EdgeInsets.all(8),
                scrollDirection: Axis.horizontal,
                child: child),
          ],
        ),
      ),
    );
  }
}
