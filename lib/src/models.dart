/*
* Copyright 2019 mark , All right reserved
* author : mark
* date : 2019-11-07
* ide : VSCode
*/

import 'package:flutter/material.dart';

class RtmpConfig {
  RtmpConfig(
      {this.debugmode = false,
      this.audioConfig = const RtmpAudioConfig(),
      this.videoConfig = const RtmpVideoConfig()});

  final bool debugmode;
  final RtmpVideoConfig videoConfig;
  final RtmpAudioConfig audioConfig;

  Map toMap() {
    return {"videoConfig": videoConfig.toMap(), "debugmode": debugmode};
  }
}

/// 视频配置
/// 暂未使用
/// not used
class RtmpVideoConfig {
  const RtmpVideoConfig(
      {this.autoRotate = false,
      this.quality = 5,
      this.orientation = Orientation.portrait});
  // 自动旋转
  final bool autoRotate; // = false;

  // 视频输出质量 0~8
  final int quality;

  //竖屏
  final Orientation orientation;

  Map toMap() {
    return {
      "autoRotate": autoRotate,
      "quality": quality,
      "orientation": orientation.index
    };
  }

  /// 是否为横屏
  bool get isLandspace => orientation == Orientation.landscape;
}

class RtmpAudioConfig {
  const RtmpAudioConfig();
}

/// 结果信息
class RtmpResponse {
  bool succeed = false;
  String message = "";
  dynamic result;
  Map oridata;

  RtmpResponse.succeed({String msg}) {
    succeed = true;
    message = msg ?? "";
  }
  RtmpResponse.faile({String msg}) {
    succeed = false;
    message = msg ?? "";
  }
  RtmpResponse.fromData(Map data) {
    oridata = data;
    succeed = data['succeed'] ?? false;
    message = data['message'] ?? "";
    result = data["result"] ?? {};
  }

  bool get isOk => succeed == true;
}

/// rtmp 快照
class RtmpSnapshot {
  // 是否拥有快照信息
  bool hasShot = false;
  // 当前尺寸
  Size currentCtxSize;
  // 直播地址
  String rtmpUrl;
  // 直播状态
  int status;

  RtmpSnapshot.fromData(Map data) {
    if (0 == data.keys.length && data != null) {
      hasShot = true;
    }
    data ??= {};
    status = data["status"] ?? 0;
  }
}
