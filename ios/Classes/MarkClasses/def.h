//
//  def.h
//  Pods
//
//  Created by 致命七八 on 2019/11/5.
//

#ifndef def_h
#define def_h


/// 连接状态回调名称
static NSString * DEF_CAMERA_STATUE_CALLBACK = @"holo#livingStatueCallback";
static NSString * DEF_CAMERA_RTMP_VIEW = @"holo#cameraRtmpView";
static NSString * DEF_CAMERA_SETTING_CONFIG = @"holo#cameraSettingConfig";

/// 状态回调
typedef enum : NSUInteger {
    /// 准备
     HoloLiveStatueReady = 0,
     /// 连接中
     HoloLiveStatuePending = 1,
     /// 已连接
     HoloLiveStatueStart = 2,
     /// 已断开
     HoloLiveStatueStop = 3,
     /// 连接出错
     HoloLiveStatueError = 4,
     ///  正在刷新
     HoloLiveStatueRefresh = 5
    
} HoloLiveStatues;




#endif /* def_h */
