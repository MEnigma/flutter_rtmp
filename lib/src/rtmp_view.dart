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
  final Widget permissionLoadingWidget;

  RtmpView(
      {@required this.manager,
      this.checkPermission = true,
      this.permissionLoadingWidget});

  @override
  _RtmpViewState createState() => _RtmpViewState();
}

class _RtmpViewState extends State<RtmpView> {
  /// 屏幕方向
  Orientation orientation = Orientation.portrait;

  bool _permissionAble = false;

  Future<bool> permissionCheck() async {
    PermissionHandler pHandler = PermissionHandler();
    List<PermissionGroup> requestPermission = [];

    /// 摄像机
    if (await pHandler.checkPermissionStatus(PermissionGroup.camera) !=
        PermissionStatus.granted) {
      requestPermission.add(PermissionGroup.camera);
    }

    /// 文件读写
    if (await pHandler.checkPermissionStatus(PermissionGroup.storage) !=
        PermissionStatus.granted) {
      if (defaultTargetPlatform == TargetPlatform.android)
        requestPermission.add(PermissionGroup.storage);
    }

    /// 麦克风
    if (await pHandler.checkPermissionStatus(PermissionGroup.microphone) !=
        PermissionStatus.granted) {
      requestPermission.add(PermissionGroup.microphone);
    }

    if (requestPermission.length > 0) {
      Map<PermissionGroup, PermissionStatus> res =
          await pHandler.requestPermissions(requestPermission);
      bool enable = true;
      res.forEach((var p, PermissionStatus status) {
        if (status != PermissionStatus.granted) {
          enable = false;
          return;
        }
      });
      _permissionAble = enable;
    } else {
      _permissionAble = true;
    }
    return _permissionAble;
  }

  Widget _getPlatformView() {
    var view;
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
    return view;
  }

  @override
  Widget build(BuildContext context) {
    return widget.checkPermission
        ? FutureBuilder(
            future: permissionCheck(),
            builder: (ctx, AsyncSnapshot shot) {
              if (shot.connectionState != ConnectionState.done) {
                return widget.permissionLoadingWidget ??
                    Center(
                      child: CircularProgressIndicator(),
                    );
              } else {
                return _permissionAble
                    ? _getPlatformView()
                    : Container(
                        color: Colors.white,
                        child: Center(
                          child: Text("未获得相关权限"),
                        ),
                      );
              }
            },
          )
        : Container(
            color: Colors.transparent,
            alignment: Alignment.center,
            child: AspectRatio(
              aspectRatio: 720.0 / 1280,
              child: _getPlatformView(),
            ));
  }

  void _onCreated(int statue) {
    if (widget.manager != null) {
      widget.manager.didCreated();
    }
  }
}
