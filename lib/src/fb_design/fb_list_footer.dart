import 'package:flutter/material.dart';
import 'package:lib_ui/load_more.dart';
enum FbLoadStatus {
  idle,
  loading,
  error,
  noMore,
}
/// 为列表提供加载态和重试机制
class FbListFooter extends StatelessWidget {
  final Widget child;

  final LoadMoreStatus loadStatus;
  final VoidCallback loadMore;

  const FbListFooter({
    Key? key,
    required this.child,
    required this.loadStatus,
    required this.loadMore,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return NotificationListener<ScrollMetricsNotification>(
      child: child,
      onNotification: (notification) {
        final metrics = notification.metrics;
        if (metrics.pixels >= metrics.maxScrollExtent) {
          switch(loadStatus) {

            case LoadMoreStatus.noMore:
              break;
            case LoadMoreStatus.ready:
              // TODO: Handle this case.
              break;
            case LoadMoreStatus.loading:
              // TODO: Handle this case.
              break;
            case LoadMoreStatus.error:
              // TODO: Handle this case.
              break;
            case LoadMoreStatus.toTop:
              // TODO: Handle this case.
              break;
          }
        }
        return false;
      },
    );
  }
}
