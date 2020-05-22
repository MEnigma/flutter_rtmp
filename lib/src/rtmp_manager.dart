/*
* Copyright 2019 mark , All right reserved
* author : mark
* date : 2019-11-05
* ide : VSCode
*/

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_rtmp/flutter_rtmp.dart';
import 'package:flutter_rtmp/src/models.dart';

import 'def.dart';

class RtmpManager {
  // static final RtmpManager2 _instance = RtmpManager2._();
  // static RtmpManager2 get instance => _instance;
  // factory RtmpManager2() => _instance;
  // RtmpManager2._();
  RtmpManager({this.config});

  // method
  final MethodChannel _methodChannel = MethodChannel(DEF_CAMERA_SETTING_CONFIG);

  // 配置信息
  final RtmpConfig config;

  RtmpSnapshot _rtmpSnapshot;
  RtmpSnapshot get snapShot => _rtmpSnapshot;

  // 初始化配置信息
  // 会在 [onPlatformViewCreated] 中调用
  Future initConfig() async {
    await loadConfig();
  }

  // 加载配置信息
  Future loadConfig() async {
    _methodChannel.invokeMethod(MethodDef.initConfig, config?.toMap());
  }

  // 开始直播/推流
  // @param rtmpUrl 直播地址
  Future<RtmpResponse> startLive(String rtmpUrl) async {
    RtmpResponse result = RtmpResponse.fromData(
        await _methodChannel.invokeMethod("startLive", {"url": rtmpUrl}));
    return result;
  }

  // 停止直播/推流
  Future<RtmpResponse> stopLive() async {
    RtmpResponse result =
        RtmpResponse.fromData(await _methodChannel.invokeMethod("stopLive"));
    this._rtmpSnapshot = RtmpSnapshot.fromData(result.result);
    return result;
  }

  // 暂停推流
  Future<RtmpResponse> pauseLive() async {
    RtmpResponse result =
        RtmpResponse.fromData(await _methodChannel.invokeMethod("pauseLive"));
    this._rtmpSnapshot = RtmpSnapshot.fromData(result.result);
    return result;
  }

  // 恢复直播
  Future<RtmpResponse> resumeLive() async {
    RtmpResponse result =
        RtmpResponse.fromData(await _methodChannel.invokeMethod("resumeLive"));
    this._rtmpSnapshot = RtmpSnapshot.fromData(result.result);
    return result;
  }

  // 销毁
  Future<RtmpResponse> dispose() async {
    RtmpResponse result =
        RtmpResponse.fromData(await _methodChannel.invokeMethod("dispose"));
    this._rtmpSnapshot = RtmpSnapshot.fromData(result.result);
    return result;
  }

  // 获取 直播快照
  Future<RtmpSnapshot> updateSnapshot() async {
    RtmpResponse result =
        RtmpResponse.fromData(await _methodChannel.invokeMethod("cameraRatio"));
    this._rtmpSnapshot = RtmpSnapshot.fromData(result.result);
    return snapShot;
  }

  // 切换摄像头
  Future<RtmpResponse> switchCamera() async {
    RtmpResponse result = RtmpResponse.fromData(
        await _methodChannel.invokeMethod("switchCamera"));
    this._rtmpSnapshot = RtmpSnapshot.fromData(result.result);
    return result;
  }

  // 旋转摄像头
  Future<RtmpResponse> rotateOrientation(
      {Orientation orientation = Orientation.portrait,
      bool force = false}) async {
    RtmpResponse result = RtmpResponse.fromData(await _methodChannel
        .invokeMethod(
            "rotateOrientation", {"force": force, "orien": orientation.index}));
    this._rtmpSnapshot = RtmpSnapshot.fromData(result.result);
    return result;
  }
}
