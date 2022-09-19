import 'package:flutter/material.dart';

class CacheWidget extends StatefulWidget {
  const CacheWidget({Key? key, required this.builder, this.cacheKey})
      : super(key: key);
  final Widget Function() builder;
  final Object? cacheKey;

  @override
  _CacheWidgetState createState() => _CacheWidgetState();
}

class _CacheWidgetState extends State<CacheWidget> {
  Widget? _child;
  Object? _cacheKey;

  @override
  void initState() {
    _cacheKey = widget.key;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    if (_child == null || _cacheKey != widget.cacheKey) {
      _cacheKey = widget.cacheKey;
      _child = widget.builder();
    }
    return _child!;
  }
}
