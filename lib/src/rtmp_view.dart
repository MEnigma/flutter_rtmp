/*
* Copyright 2019 mark , All right reserved
* author : mark
* date : 2019-11-05
* ide : VSCode
*/

import 'package:flutter/material.dart';
import 'package:flutter/foundation.dart';

import 'package:flutter/widgets.dart';
import 'package:flutter_rtmp/src/rtmp_manager.dart';

/// 直播推流回显view,需要依赖[RtmpManager]控制其行为
/// 当前为固定宽高比例 720/1280 ,以适应大多数摄像头采集的尺寸比例
class RtmpView extends StatelessWidget {
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
  Widget build(BuildContext context) {
    return checkPermission
        ? manager.permissionEnable
            ? manager.view()
            : FutureBuilder(
                future: manager.permissionCheck(),
                builder: (_, AsyncSnapshot shot) {
                  if (shot.connectionState != ConnectionState.done) {
                    return permissionLoadingWidgetBuilder != null
                        ? permissionLoadingWidgetBuilder(_)
                        : Center(
                            child: CircularProgressIndicator(),
                          );
                  } else {
                    return shot.data != null && shot.data
                        ? manager.view()
                        : errorWidgetBuilder != null
                            ? errorWidgetBuilder(_)
                            : Center(
                                child: Text("Permission error"),
                              );
                  }
                },
              )
        : manager.view();
  }
}
