import 'package:flutter/material.dart';
import 'package:lib_ui/list_view/position_list_view/src/item_positions_listener.dart';
import 'package:lib_ui/list_view/position_list_view/src/scrollable_positioned_list.dart';

import 'index_list.dart';

enum ListType {
  scrollablePositionedList,
  indexList,
}

enum ProxyInitialAlignment {
  top,
  bottom,
}

class ProxyIndexList extends StatelessWidget {
  final int initialIndex;
  final ProxyController? controller;
  final ProxyIndexListener? indexListener;
  final ProxyInitialAlignment? initialAlignment;
  final double initialOffset;
  final ScrollPhysics? physics;
  final int itemCount;
  final bool reverse;
  final EdgeInsets? padding;
  final ProxyBuilder builder;
  final double? minCacheExtent;

  const ProxyIndexList({
    Key? key,
    this.initialIndex = 0,
    required this.controller,
    this.indexListener,
    this.physics,
    this.padding,
    this.initialOffset = 0,
    this.reverse = false,
    required this.itemCount,
    required this.builder,
    this.initialAlignment = ProxyInitialAlignment.top,
    this.minCacheExtent,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) =>
      buildList(controller?.listType ?? ListType.scrollablePositionedList);

  Widget buildList(ListType type) {
    if (type == ListType.indexList) {
      return IndexListView.builder(
        key: key,
        reverse: reverse,
        indexPadding: padding,
        indexController: controller!.indexController,
        initialIndex: initialIndex,
        indexListener: indexListener?.indexListener,
        initialAlignment: initialAlignment == ProxyInitialAlignment.top
            ? InitialAlignment.top
            : InitialAlignment.bottom,
        childrenDelegate: SliverChildBuilderDelegate(
          builder,
          childCount: itemCount,
        ),
        physics: physics,
      );
    }
    return ScrollablePositionedList.builder(
      key: key,
      padding: padding,
      reverse: reverse,
      initialScrollIndex: initialIndex,
      initialOffset: initialOffset,
      itemBuilder: builder,
      itemCount: itemCount,
      initialAlignment: initialAlignment == ProxyInitialAlignment.top ? 0 : 1,
      itemScrollController: controller!.itemScrollController!,
      physics: physics!,
      itemPositionsListener: indexListener!.itemPositionsListener!,
      scrollController: controller!.scrollController,
      minCacheExtent: minCacheExtent,
    );
  }
}

class ProxyController {
  ItemScrollController? itemScrollController;
  IndexController? indexController;
  ScrollController? scrollController;

  ProxyController.fromItemController(this.itemScrollController,
      {this.scrollController});

  ProxyController.fromIndexController(this.indexController);

  void jumpToIndex(int index, {double alignment = 0, double offset = 0}) {
    itemScrollController?.jumpTo(
        index: index, alignment: alignment, offset: offset);
    indexController?.jumpToIndex(index);
  }

  Future animationToIndex(int index,
      {required Duration duration,
      Curve curve = Curves.linear,
      double alignment = 0}) async {
    await itemScrollController?.scrollTo(
        index: index, duration: duration, alignment: alignment);
    await indexController?.animationToIndex(index,
        duration: duration, curve: curve);
  }

  bool get isAttached {
    return itemScrollController?.isAttached ??
        indexController?.hasClients ??
        false;
  }

  ListType get listType => indexController == null
      ? ListType.scrollablePositionedList
      : ListType.indexList;
}

class ProxyIndexListener {
  ItemPositionsListener? itemPositionsListener;
  IndexListener? indexListener;

  ProxyIndexListener.fromItemListener(this.itemPositionsListener);

  ProxyIndexListener.fromIndexListener(this.indexListener);
}

typedef ProxyBuilder = Widget Function(BuildContext context, int index);
