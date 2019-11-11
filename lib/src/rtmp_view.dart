/*
* Copyright 2019 mark , All right reserved
* author : mark
* date : 2019-11-05
* ide : VSCode
*/

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter/foundation.dart';

import 'package:flutter/widgets.dart';
import 'package:flutter_rtmp/src/def.dart';
import 'package:flutter_rtmp/src/rtmp_manager.dart';

class RtmpView extends StatefulWidget {
  final RtmpManager manager;
  RtmpView({@required this.manager});

  @override
  _RtmpViewState createState() => _RtmpViewState();
}

class _RtmpViewState extends State<RtmpView> {
  /// 屏幕方向
  Orientation orientation = Orientation.portrait;

  @override
  Widget build(BuildContext context) {
    var view = null;
    if (defaultTargetPlatform == TargetPlatform.iOS) {
      view = UiKitView(
        viewType: DEF_CAMERA_RTMP_VIEW,
        onPlatformViewCreated: _onCreated,
      );
    } else if (defaultTargetPlatform == TargetPlatform.android) {
      view = AndroidView(
        viewType: DEF_CAMERA_RTMP_VIEW,
        onPlatformViewCreated: _onCreated,
      );
    } else {
      view = Container();
    }

    return Container(
        alignment: Alignment.center,
        child: AspectRatio(
          aspectRatio:
              orientation == Orientation.portrait ? 720.0 / 1280 : 1280.0 / 720,
          child: view,
        ));
  }

  void _onCreated(int statue) {
    if (widget.manager != null) {
      widget.manager.didCreated();
    }
  }
}
