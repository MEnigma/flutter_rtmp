/*
* Copyright 2019 mark , All right reserved
* author : mark
* date : 2019-11-05
* ide : VSCode
*/

import 'package:flutter/material.dart';
import 'package:flutter/foundation.dart';

import 'package:flutter/widgets.dart';
import 'package:flutter_rtmp/src/def.dart';
import 'package:flutter_rtmp/src/rtmp_manager.dart';
import 'package:permission_handler/permission_handler.dart';

/// 直播推流回显view,需要依赖[RtmpManager]控制其行为
/// 当前为固定宽高比例 720/1280 ,以适应大多数摄像头采集的尺寸比例
class RtmpView extends StatefulWidget {
  final RtmpManager manager;

  /// 是否检查权限,过程中会有loading, 默认[false]
  final bool checkPermission;

  /// loading view
  final WidgetBuilder permissionLoadingWidgetBuilder;

  /// errorwidget for permission
  final WidgetBuilder errorWidgetBuilder;

  RtmpView(
      {Key key,
      @required this.manager,
      this.checkPermission = true,
      this.permissionLoadingWidgetBuilder,
      this.errorWidgetBuilder})
      : super(key: key);

  @override
  _RtmpViewState createState() => _RtmpViewState();
}

class _RtmpViewState extends State<RtmpView> {
  Widget _platformView;
  GlobalKey _globalKey = GlobalKey();
  
  Widget _getPlatformView() {
    print("[RTMP] get platformview");
    if (_platformView == null) {
      if (defaultTargetPlatform == TargetPlatform.iOS) {
        _platformView = UiKitView(
          key: _globalKey,
          viewType: DEF_CAMERA_RTMP_VIEW,
          onPlatformViewCreated: _onCreated,
        );
      } else if (defaultTargetPlatform == TargetPlatform.android) {
        _platformView = AndroidView(
          key: _globalKey,
          viewType: DEF_CAMERA_RTMP_VIEW,
          onPlatformViewCreated: _onCreated,
        );
      } else {
        _platformView = Container();
      }
    }
    return Container(
        color: Colors.transparent,
        alignment: Alignment.center,
        child: AspectRatio(
          aspectRatio: 720.0 / 1280,
          child: _platformView,
        ));
  }

  @override
  Widget build(BuildContext context) {
    return widget.checkPermission
        ? widget.manager.permissionEnable
            ? _getPlatformView()
            : FutureBuilder(
                future: widget.manager.permissionCheck(),
                builder: (_, AsyncSnapshot shot) {
                  if (shot.connectionState != ConnectionState.done) {
                    return widget.permissionLoadingWidgetBuilder != null
                        ? widget.permissionLoadingWidgetBuilder(_)
                        : Center(
                            child: CircularProgressIndicator(),
                          );
                  } else {
                    return shot.data != null && shot.data
                        ? _getPlatformView()
                        : widget.errorWidgetBuilder != null
                            ? widget.errorWidgetBuilder(_)
                            : Center(
                                child: Text("Permission error"),
                              );
                  }
                },
              )
        : _getPlatformView();
  }

  void _onCreated(int statue) {
    if (widget.manager != null) {
      widget.manager.didCreated();
    }
  }
}
