/*
* Copyright 2019 mark , All right reserved
* author : mark
* date : 2019-11-05
* ide : VSCode
*/

import 'package:flutter/services.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_rtmp/src/def.dart';
import 'package:flutter_rtmp/src/models.dart';

class RtmpManager {
  RtmpManager({this.onCreated});

  /// 视图加载回调,
  final VoidCallback onCreated;

  /// 配置
  MethodChannel _configChannel = MethodChannel(DEF_CAMERA_SETTING_CONFIG);

  /// 回调
  EventChannel _statueBackChannel = EventChannel(DEF_CAMERA_STATUE_CALLBACK);

  /// 配置
  final RtmpConfig config = RtmpConfig();

  /// 直播状态
  RtmpStatue _statue = RtmpStatue.preparing;

  Future<RtmpResponse> didCreated() async {
    Map res = null;
    try {
      res = await _configChannel.invokeMethod("initConfig", config.toMap());
    } catch (e) {
      print(" ___ catch e : $e ");
    }

    if (onCreated != null) onCreated();
    return RtmpResponse.fromData(res ?? {});
  }

  /// 开始直播
  Future<RtmpResponse> living({@required String url}) async {
    return RtmpResponse.fromData(
        await _configChannel.invokeMethod("startLive", {"url": url}));
  }

  /// 停止直播
  Future<RtmpResponse> stopLive() async =>
      RtmpResponse.fromData(await _configChannel.invokeMethod("stopLive", {}));

  /// 旋转摄像头
  Future<RtmpResponse> rotateCamera() async {
    RtmpResponse res = RtmpResponse.fromData(
        await _configChannel.invokeMethod("rotateCamera", {}));
    if (res.isOk) {
      config.videoConfig.rotate();
    }
    return res;
  }

  Future<RtmpResponse> pauseLive() async {
    if (_statue != RtmpStatue.living) return RtmpResponse.succeed();
    return RtmpResponse.fromData(
        await _configChannel.invokeMethod("pauseLive", {}));
  }

  Future<RtmpResponse> resumeLive() async {
    if (_statue != RtmpStatue.pause) return RtmpResponse.succeed();
    return RtmpResponse.fromData(
        await _configChannel.invokeMethod("resumeLive", {}));
  }

  Future dispose() async {
    return await _configChannel.invokeMethod("dispose", {});
  }

  ///切换摄像头
  Future<RtmpResponse> switchCamera()async{
    return RtmpResponse.fromData(await _configChannel.invokeMethod("switchCamera",{}));
  }

  @deprecated
  Future<double> cameraRatio() async {
    try {
      RtmpResponse res = RtmpResponse.fromData(
          await _configChannel.invokeMethod("cameraRatio", {}));
      if (res.isOk) {
        String ratio = res.oridata['ratio'];
        double width = double.parse(ratio.split("*")[1]);
        double height = double.parse(ratio.split("*")[0]);
        return width / height;
      } else {
        return null;
      }
    } catch (Exception) {
      return null;
    }
  }
}
