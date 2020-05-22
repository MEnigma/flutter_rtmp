package holo.mark.flutter_rtmp

// 状态回调
var DEF_CAMERA_STATUE_CALLBACK = "holo#livingStatueCallback"

/// 视图id
var DEF_CAMERA_RTMP_VIEW = "holo#cameraRtmpView"

/// 配置方法
var DEF_CAMERA_SETTING_CONFIG = "holo#cameraSettingConfig"


var PKG_NAME = "hv.rtmp"


// --------------  连接状态 --------------
/// 准备中
var RTMP_STATUE_Preparing = 0
/// 准备结束
var RTMP_STATUE_Ready = -1
/// 连接中
var RTMP_STATUE_Pending = 1
/// 已连接
var RTMP_STATUE_Pushing = 2
/// 已断开
var RTMP_STATUE_Stop = 3
/// 连接出错
var RTMP_STATUE_Error = 4
///  正在刷新
var RTMP_STATUE_Refresh = 5