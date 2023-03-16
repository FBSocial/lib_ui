// Copyright 2014 The Flutter Authors. All rights reserved.
// Use of this source code is governed by a BSD-style license that can be
// found in the LICENSE file.

// @dart = 2.8

import 'package:flutter/material.dart';
import 'package:lib_theme/app_theme.dart';

class CustomRadio extends StatefulWidget {
  final List<String> items;
  final void Function(int type) onSelect;
  final int defaultSelectItem;

  const CustomRadio(
      {@required this.items,
      this.onSelect,
      this.defaultSelectItem = 0,
      Key key})
      : super(key: key);

  @override
  _CustomRadioState createState() => _CustomRadioState();
}

class _CustomRadioState extends State<CustomRadio> {
  int _selectType = 1;
  final List<Widget> _widgets = [];

  @override
  void initState() {
    _selectType = widget.defaultSelectItem;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    _widgets.clear();
    for (int i = 0; i < widget.items.length; i++) {
      _widgets.add(_customRadio(
          title: widget.items[i],
          select: _selectType == i,
          type: i,
          alignment: i == 0
              ? Alignment.centerLeft
              : ((i == widget.items.length - 1)
                  ? Alignment.centerRight
                  : Alignment.center)));
    }
    return Container(
      height: 52,
      alignment: Alignment.center,
      padding: const EdgeInsets.fromLTRB(25.5, 0, 25.5, 0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: _widgets,
      ),
    );
  }

  Widget _customRadio(
      {String title, bool select, int type, AlignmentGeometry alignment}) {
    return GestureDetector(
      onTap: () {
        _selectType = type;
        setState(() {});
        widget.onSelect(type);
      },
      child: Container(
        alignment: alignment,
        height: 52,
        width: 80,
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              height: 15,
              width: 15,
              decoration: BoxDecoration(
                  border: Border.all(
                      color: select
                          ? AppTheme.of(context).fg.blue1
                          : AppTheme.of(context).fg.b40,
                      width: select ? 4 : 1),
                  borderRadius: const BorderRadius.all(Radius.circular(18))),
            ),
            const SizedBox(width: 5),
            Text(
              title,
              style: TextStyle(
                  fontWeight: FontWeight.normal,
                  fontSize: 15,
                  color: select
                      ? AppTheme.of(context).fg.blue1
                      : AppTheme.of(context).fg.b40,
                  height: 1.2),
            )
          ],
        ),
      ),
    );
  }
}
