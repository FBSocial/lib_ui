import 'package:flutter/material.dart';
import 'package:lib_theme/default_theme.dart';

enum LoadMoreWidgetStatus {
  noMore,
  ready,
  error,
}

/// 一个不需要维护加载状态的 LoadMoreWidget 组件，只需要提供数据加载方式
class LoadMoreWidget extends StatefulWidget {
  final double loadMoreWidgetThreshold;

  final Future<bool> Function() fetchNextPage;
  final Widget Function(Widget Function()) builder;
  final Widget? loadingWidget;

  final bool autoStart;

  const LoadMoreWidget({
    required this.fetchNextPage,
    required this.builder,
    this.loadMoreWidgetThreshold = 50.0,
    this.loadingWidget,
    this.autoStart = false,
    Key? key,
  }) : super(key: key);

  @override
  _LoadMoreWidgetState createState() => _LoadMoreWidgetState();
}

class _LoadMoreWidgetState extends State<LoadMoreWidget> {
  var _loadMoreWidgetStatus = LoadMoreWidgetStatus.ready;

  @override
  void initState() {
    if (widget.autoStart) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        _startLoading();
      });
    }

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return NotificationListener(
      onNotification: _onNotification,
      child: widget.builder(_buildDefaultLoadingWidget),
    );
  }

  Widget _buildDefaultLoadingWidget() {
    switch (_loadMoreWidgetStatus) {
      case LoadMoreWidgetStatus.ready:
        return _LoadingWidget(
            child:
                widget.loadingWidget ?? DefaultTheme.defaultLoadingIndicator());
      case LoadMoreWidgetStatus.error:

      /// 暂时没用到这种情况，因为开启了自动重试
      case LoadMoreWidgetStatus.noMore:
      default:
        return const SizedBox();
    }
  }

  bool _onNotification(Notification notification) {
    if (notification is ScrollNotification) {
      _onScroll(notification);
    } else if (notification is _LoadingWidgetUpdateNotification) {
      _onLoadingWidgetUpdate();
    }
    return true;
  }

  bool _onScroll(ScrollNotification n) {
    if (_loadMoreWidgetStatus != LoadMoreWidgetStatus.ready) return true;

    if (n.metrics.pixels + widget.loadMoreWidgetThreshold >
        n.metrics.maxScrollExtent) {
      _startLoading();
    }
    return true;
  }

  void _startLoading() {
    _loadMoreWidgetStatus = LoadMoreWidgetStatus.ready;
    widget.fetchNextPage().then((hasMore) {
      if (!hasMore) {
        setState(() {
          _loadMoreWidgetStatus = LoadMoreWidgetStatus.noMore;
        });
      }

      /// 除了 [didUpdateWidget]，其他地方不应该设置 [_LoadMoreWidgetStatus] 为 ready，否则可能导致这里再次执行
    }).catchError((_) {
    });
  }

  void _onLoadingWidgetUpdate() {
    /// 加载完数据后，会把数据插入列表中，于是这里就会执行，即加载完成
    /// 在 [_LoadMoreWidgetStatus] 不为 true 时，加载态重置为 ready
    /// 📢 除了这个地方，其他地方不应该设置状态为 ready，因为这里能保证新数据已经被填充进来
    if (_loadMoreWidgetStatus != LoadMoreWidgetStatus.noMore) {
      _loadMoreWidgetStatus = LoadMoreWidgetStatus.ready;
    }
  }
}

class _LoadingWidgetUpdateNotification extends Notification {
  const _LoadingWidgetUpdateNotification();
}

class _LoadingWidget extends StatefulWidget {
  final Widget? child;

  const _LoadingWidget({this.child});

  @override
  __LoadingWidgetState createState() => __LoadingWidgetState();
}

class __LoadingWidgetState extends State<_LoadingWidget> {
  @override
  void didUpdateWidget(covariant _LoadingWidget oldWidget) {
    const _LoadingWidgetUpdateNotification().dispatch(context);
    super.didUpdateWidget(oldWidget);
  }

  @override
  Widget build(BuildContext context) {
    return widget.child!;
  }
}
