本工具能够将美术提供的 svg 文件转换成 ttf 文件，并交予 Flutter 项目使用。



## 依赖

这个工具依赖于以下命令：

1.  Node.js

2.  dart 工具包中的 dartfmt（如果不存在，文件就不会格式化）

    

## 做了什么？

1.  将位于 icon 文件夹下的文件转换成  ttf 文件
2.  生成 IconFont.dart 文件
3.  更新 Flutter 项目中的 *assets/fonts/iconfont.ttf* 文件



## 如何运行？

首次运行，请在根目录执行`npm i`。



1.  从蓝湖上下载 svg 文件
2.  如果没有对应的模块文件夹，新建一个，然后把图标放进去（只能是英文，下划线连接单词）
3.  把图片名字改成英文，下划线连接单词
4.  运行脚本 `sh run.sh`
5.  在 flutter 项目目录下执行 `flutter clean`
6.  重新运行项目



此时，Flutter 项目下的 *lib/icon_font.dart* 会被更新。

```dart
// GENERATED CODE - DO NOT MODIFY BY HAND
import 'package:flutter/widgets.dart';

class IconFont {
  static const IconData SetupCharactersDelete =
      IconData(0xea01, fontFamily: "iconfont");
}
```



并且，*assets/fonts/iconfont.ttf* 也会被更新。



## 如何使用图标

```dart
Icon(IconFont.SetupCharactersDelete);
```