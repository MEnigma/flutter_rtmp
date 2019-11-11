/*
* Copyright 2019 mark , All right reserved
* author : mark
* date : 2019-11-07
* ide : VSCode
*/

import 'package:flutter/widgets.dart';

int ORIENTATION_PORTRAIT = 1;
int ORIENTATION_LANDSCAPE = 2;

class RtmpConfig {
  RtmpVideoConfig videoConfig = RtmpVideoConfig();
  RtmpAudioConfig audioConfig = RtmpAudioConfig();

  Map toMap() {
    return {"videoConfig": videoConfig.toMap()};
  }
}

/// 视频配置
class RtmpVideoConfig {
  // 自动旋转
  bool autoRotate = false;

  // 视频输出质量 0~8
  int quality = 5;

  //竖屏
  int orientation = ORIENTATION_PORTRAIT;

  Map toMap() {
    return {
      "autoRotate": autoRotate,
      "quality": quality,
      "orientation": orientation
    };
  }

  void rotate(){
    if(orientation == ORIENTATION_PORTRAIT){
      orientation = ORIENTATION_LANDSCAPE;
    }else{
      orientation = ORIENTATION_PORTRAIT;
    }
  }
  /// 是否为横屏
  bool get isLandspace => orientation == ORIENTATION_LANDSCAPE;
  
}

class RtmpAudioConfig {}

/// 结果信息
class RtmpResponse {
  bool succeed = false;
  String message = "";

  Map oridata;

  RtmpResponse.succeed({String msg}){
    succeed = true;
    message = msg ?? "";
  }
  RtmpResponse.faile({String msg}){
    succeed = false;
    message = msg ?? "";
  }
  RtmpResponse.fromData(Map data) {
    oridata = data;
    succeed = data['succeed'] ?? false;
    message = data['message'] ?? "";
  }

  bool get isOk => succeed == true;
}
