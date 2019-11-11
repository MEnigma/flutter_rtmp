/*
* Copyright 2019 mark , All right reserved
* author : mark
* date : 2019-11-05
* ide : VSCode
*/

import 'package:flutter/widgets.dart';

/// 状态回调
final String DEF_CAMERA_STATUE_CALLBACK = "holo#livingStatueCallback";

/// 视图id
final String DEF_CAMERA_RTMP_VIEW = "holo#cameraRtmpView";

/// 配置方法
final String DEF_CAMERA_SETTING_CONFIG = "holo#cameraSettingConfig";

enum RtmpStatue {
  preparing,
  failed,
  living,
  pause,
  resume,
  stop,
}

class _RtmpRoute{

  static String get stop => "stopLive";


}