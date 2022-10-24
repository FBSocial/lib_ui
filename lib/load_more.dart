import 'package:flutter/material.dart';
import 'package:lib_theme/default_theme.dart';

enum LoadMoreStatus {
  noMore,
  ready,
  loading,
  error,
  toTop,
}

/// 一个不需要维护加载状态的 LoadMore 组件，只需要提供数据加载方式
class LoadMore extends StatefulWidget {
  final double loadMoreThreshold;

  final Future<bool> Function() fetchNextPage;
  final Widget Function(Widget Function()) builder;
  final Widget? loadingWidget;

  final bool autoStart;

  const LoadMore({
    required this.fetchNextPage,
    required this.builder,
    this.loadMoreThreshold = 50.0,
    this.loadingWidget,
    this.autoStart = false,
    Key? key,
  }) : super(key: key);

  @override
  _LoadMoreState createState() => _LoadMoreState();
}

class _LoadMoreState extends State<LoadMore> {
  var _loadMoreStatus = LoadMoreStatus.ready;
  var _isLoading = false;

  @override
  void initState() {
    if (widget.autoStart) {
      WidgetsBinding.instance!.addPostFrameCallback((_) {
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
    switch (_loadMoreStatus) {
      case LoadMoreStatus.ready:
      case LoadMoreStatus.loading:
        return _LoadingWidget(
            child:
                widget.loadingWidget ?? DefaultTheme.defaultLoadingIndicator());
      case LoadMoreStatus.error:

      /// 暂时没用到这种情况，因为开启了自动重试
      case LoadMoreStatus.noMore:
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
    if (_loadMoreStatus != LoadMoreStatus.ready) return true;

    if (n.metrics.pixels + widget.loadMoreThreshold >
        n.metrics.maxScrollExtent) {
      _startLoading();
    }
    return true;
  }

  void _startLoading() {
    _isLoading = true;
    _loadMoreStatus = LoadMoreStatus.loading;
    widget.fetchNextPage().then((hasMore) {
      if (!hasMore) {
        setState(() {
          _loadMoreStatus = LoadMoreStatus.noMore;
        });
      }

      /// 除了 [didUpdateWidget]，其他地方不应该设置 [_loadMoreStatus] 为 ready，否则可能导致这里再次执行
      _isLoading = false;
    }).catchError((_) {
      _isLoading = false;
      return;
    });
  }

  void _onLoadingWidgetUpdate() {
    /// 加载完数据后，会把数据插入列表中，于是这里就会执行，即加载完成
    /// 在 [_loadMoreStatus] 不为 true 时，加载态重置为 ready
    /// 📢 除了这个地方，其他地方不应该设置状态为 ready，因为这里能保证新数据已经被填充进来
    if (_loadMoreStatus != LoadMoreStatus.noMore && !_isLoading) {
      _loadMoreStatus = LoadMoreStatus.ready;
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
