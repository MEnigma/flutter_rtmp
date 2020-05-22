/*
* Copyright 2019 mark , All right reserved
* author : mark
* date : 2019-11-05
* ide : VSCode
*/

/// 状态回调
const String DEF_CAMERA_STATUE_CALLBACK = "holo#livingStatueCallback";

/// 视图id
const String DEF_CAMERA_RTMP_VIEW = "holo#cameraRtmpView";

/// 配置方法
const String DEF_CAMERA_SETTING_CONFIG = "holo#cameraSettingConfig";

enum RtmpStatue {
  preparing,
  failed,
  living,
  pause,
  resume,
  stop,
}

abstract class MethodDef {
  static String get initConfig => "initConfig";
  static String get startLive => "startLive";
  static String get stopLive => "stopLive";
  static String get pauseLive => "pauseLive";
  static String get resumeLive => "resumeLive";
  static String get dispose => "dispose";
  static String get cameraRatio => "cameraRatio";
  static String get switchCamera => "switchCamera";
  static String get rotateOrientation => "rotateOrientation";
}
