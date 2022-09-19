import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_image_view/flutter_image_view.dart';
import 'package:lib_theme/const.dart';
import 'package:lib_utils/loggers.dart';

// test url
// 'http://fanbook-video-test-1251001060.cos.ap-guangzhou.myqcloud.com/fanbook/app/files/chatroom/txt/ebd48416a0a2711272e62cc86a05d284.xlsx';
// "http://fanbook-video-test-1251001060.cos.ap-guangzhou.myqcloud.com/fanbook/app/files/chatroom/txt/986ff0ecdf3b72cd6191a5f15a8dea85.zip";
// "https://fanbook-video-test-1251001060.file.myqcloud.com/fanbook/app/files/chatroom/image/617496409a1e53d873118bdd95384324.png";

///保存所有有问题的url
final Set<String?> _errorUrls = {};
const retainCountKey = "retain_count";
const deadLineKey = "dead_line";
const textureIdKey = "textureId";
const requestIdKey = "requestId";
// 暂时不限制缓存数量,因为纹理没有引用了会被释放(只是延时释放).
const cacheTextureCount = 999;
// 缩短延时释放时间,延时的目的主要是为了防止rebuild频繁创建释放,所以延时3秒足够rebuild
const cacheTextureTime = Duration(seconds: 3);

Map<String, Map?> _cachedTextures = {};

// 先判断能否释放此纹理: 1.没有widget引用此纹理了 2.没有引用时长达CacheTextureTime秒以上 (防止rebuild导致的频繁释放创建)
void _recycleAllTexture() {
  if (_cachedTextures.isEmpty) return;
  _cachedTextures.removeWhere((key, value) {
    final deadTime = DateTime.fromMillisecondsSinceEpoch(value![deadLineKey]);
    final retainCount = value[retainCountKey];
    if (retainCount <= 0 && deadTime.compareTo(DateTime.now()) <= 0) {
      final textureId = value[textureIdKey];
      final requestId = value[requestIdKey];
      FlutterImageView.disposeTexture(textureId, requestId);
      return true;
    } else {
      return false;
    }
  });
}

class TextureImage extends StatefulWidget {
  /// flutter2.5.3默认不使用外接纹理
  static bool useTexture = false;

  final double width;
  final double height;
  final double radius;
  final String? url;
  final BoxFit? fit;

  final Widget Function(double? progress)? progressCallBack;
  final Widget Function(String error)? errorCallBack;
  final Widget Function()? doneCallBack;

  const TextureImage(this.url,
      {Key? key,
      this.fit,
      this.width = 50,
      this.height = 50,
      this.radius = 0.0,
      this.progressCallBack,
      this.errorCallBack,
      this.doneCallBack})
      : super(key: key);

  @override
  _TextureImageState createState() => _TextureImageState();
}

class _TextureImageState extends State<TextureImage> {
  String? _url;
  int? _textureId = -1;
  String? _textureRequestId = "";
  Widget? _body;

  //临时缓存纹理ID, 这个时候，只创建了空白纹理画布
  Map? _curTmpTextureInfo;
  bool get _hasCahce => _cachedTextures.containsKey(_url ?? "");

  @override
  void initState() {
    _loadTexture();
    super.initState();
  }

  String? _decodeUrl(String? url) {
    final _uri = Uri.tryParse(_url!);
    try {
      // 22/04/22 whiskee.chen 避免_url 格式不规范 （缺少http或https）而导致读取_uri.origin出现异常
      return _uri != null ? "${_uri.origin}${_uri.path}" : url;
    } catch (e) {
      logger.warning("_decodeUrl: $e");
      return url;
    }
  }

  void _loadTexture() {
    _url = _errorUrls.contains(widget.url)
        ? widget.url
        : transformToThumb(widget.url!);

    if (_hasCahce) {
      //存在缓存纹理，直接把缓存引用计数器+1，并且拿到缓存纹理ID,进行渲染
      _addReatinCount();
      _createTextureBody();
    } else {
      //没有缓存纹理，通知原生拿
      FlutterImageView.loadTexture(_decodeUrl(_url)!,
              width: widget.width.toInt(),
              height: widget.height.toInt(),
              radius: widget.radius.toInt(),
              progressCallBack: _onProgressing,
              errorCallBack: _onError,
              doneCallBack: _onDone)
          .then((value) {
        if (mounted) {
          _initTempTexture(value!);
        } else {
          FlutterImageView.disposeTexture(
              value![textureIdKey].toString(), value[requestIdKey].toString());
        }
      });
    }
  }

  /// 临时纹理ID，这个时候只创建了空白纹理画布
  void _initTempTexture(Map result) {
    _curTmpTextureInfo = {
      deadLineKey: DateTime.now().add(cacheTextureTime).millisecondsSinceEpoch,
      retainCountKey: 1,
      textureIdKey: result[textureIdKey]?.toString(),
      requestIdKey: result[requestIdKey]?.toString()
    };
  }

  /// 纹理创建成功之后，缓存纹理
  /// 如果缓冲区满了，直接使用纹理
  /// 如果存在缓存纹理，使用缓存纹理渲染Texture,并把计数器+1 并且把新创建的纹理释放，聊天公屏中连续相同表情包时候会存在该情况
  void _cacheTextureId() {
    if (_curTmpTextureInfo == null) return;
    if (_cachedTextures.length >= cacheTextureCount) {
      // TODO 此文件内的 !.toString() 部分原本是 ?.toString()，不确实能够使用 !
      _textureId = int.tryParse(_curTmpTextureInfo![textureIdKey]!.toString());
      _textureRequestId = _curTmpTextureInfo![requestIdKey]?.toString();
      return;
    }

    if (_cachedTextures.containsKey(_url)) {
      _cachedTextures[_url]![retainCountKey] += 1;
      // 存在老纹理，把新的释放
      if (_curTmpTextureInfo![textureIdKey] !=
          _cachedTextures[_url]![textureIdKey]) {
        FlutterImageView.disposeTexture(_curTmpTextureInfo![textureIdKey],
            _curTmpTextureInfo![requestIdKey]);
        _curTmpTextureInfo = null;
      }
    } else {
      _cachedTextures[_url!] = _curTmpTextureInfo;
    }

    _cachedTextures[_url]![deadLineKey] =
        DateTime.now().add(cacheTextureTime).millisecondsSinceEpoch;
    _textureId = int.tryParse(_cachedTextures[_url]![textureIdKey]!.toString());
    _textureRequestId = _cachedTextures[_url]![requestIdKey]?.toString();
  }

  /// 缓存纹理计数器+1
  void _addReatinCount() {
    if (_cachedTextures.containsKey(_url)) {
      final oldTextures = _cachedTextures[_url]!;
      oldTextures[retainCountKey] += 1;
      oldTextures[deadLineKey] =
          DateTime.now().add(cacheTextureTime).millisecondsSinceEpoch;

      _textureId =
          int.tryParse(_cachedTextures[_url]![textureIdKey]!.toString());
      _textureRequestId = _cachedTextures[_url]![requestIdKey]?.toString();
    } else {
      logger.info("_addReatinCount,error :$_url");
    }
  }

  /// 对于存在于缓冲区的纹理计数器-1
  /// 对于不存在于缓冲区的纹理直接释放
  void _onDisposeTexture(String textureId, String? requestId, String? url) {
    if (_cachedTextures.containsKey(url)) {
      final textureInfo = _cachedTextures[url]!;
      final retainCount = textureInfo[retainCountKey] - 1;
      textureInfo[retainCountKey] = retainCount;
      if (retainCount <= 0) {
        textureInfo[deadLineKey] =
            DateTime.now().add(cacheTextureTime).millisecondsSinceEpoch;
      }
    } else if (_curTmpTextureInfo != null) {
      //缓冲区满了，不在缓存池里面，直接释放纹理
      final textureId = _curTmpTextureInfo![textureIdKey];
      final requestId = _curTmpTextureInfo![requestIdKey];
      FlutterImageView.disposeTexture(textureId, requestId);
    }
    // 如果立即调用_recycleAllTexture,则本次需要释放的纹理由于CacheTextureTime的加入变得不会释放.
    // 而CacheTextureTime加入的原因参考其注释
    Future.delayed(cacheTextureTime, _recycleAllTexture);
  }

  /// 创建缓存冲进度，图片下载进度
  void _onProgressing(double? progress) {
    _body = widget.progressCallBack?.call(progress);
    if (mounted) setState(() {});
  }

  /// 创建纹理失败回调
  /// 包括图片解密失败，url不可达失败，超时失败
  /// 失败之后，释放空白纹理
  void _onError(String error) {
    if (!_errorUrls.contains(_url)) _errorUrls.add(_url);

    if (_curTmpTextureInfo != null) {
      FlutterImageView.disposeTexture(
          _curTmpTextureInfo![textureIdKey], _curTmpTextureInfo![requestIdKey]);
    }

    _body = widget.errorCallBack?.call(error);
    if (mounted) setState(() {});
  }

  /// 创建纹理成功
  /// 成功之后需要缓存纹理
  void _onDone() {
    _cacheTextureId();
    _createTextureBody();
  }

  void _createTextureBody() {
    _body = _textureId != null && _textureId! >= 0
        ? Container(
            key: ValueKey(_textureId.toString()),
            width: widget.width,
            height: widget.height,
            alignment: Alignment.center,
            child: Texture(textureId: _textureId!))
        : sizedBox;
    if (mounted) setState(() {});
  }

  @override
  void dispose() {
    _onDisposeTexture(_textureId.toString(), _textureRequestId, _url);
    _curTmpTextureInfo = null;
    super.dispose();
  }

  @override
  void didUpdateWidget(covariant TextureImage oldWidget) {
    if (oldWidget.url != widget.url ||
        oldWidget.height != widget.height ||
        oldWidget.width != widget.width) {
      // 先释放掉正在展示的纹理(防止从didUpdateWidget过来的create请求)
      if (_textureId! > -1 && _textureRequestId!.isNotEmpty) {
        _onDisposeTexture(_textureId.toString(), _textureRequestId, _url);
      }
      _loadTexture();
    }
    super.didUpdateWidget(oldWidget);
  }

  @override
  Widget build(BuildContext context) {
    return _body ?? SizedBox(width: widget.width, height: widget.height);
  }

  String transformToThumb(String url) {
    if (url.endsWith('gif')) return url;
    if (widget.width > 0 && widget.height > 0) {
      return '$url?imageMogr2/thumbnail/${widget.width}x${widget.height}';
    } else if (widget.width > 0) {
      return '$url?imageMogr2/thumbnail/x${widget.width}';
    } else if (widget.height > 0) {
      return '$url?imageMogr2/thumbnail/${widget.height}x';
    } else {
      return '$url?imageMogr2/thumbnail/100x100';
    }
  }
}
