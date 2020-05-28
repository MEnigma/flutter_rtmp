//
//  SessionInf.h
//  Pods
//
//  Created by 致命七八 on 2019/11/5.
//

#import <Foundation/Foundation.h>
#import "LFLiveSession.h"
#import <MJExtension/MJExtension.h>
#import "Response.h"
NS_ASSUME_NONNULL_BEGIN

typedef NS_ENUM(NSInteger,RTMPStatus){
    /// 准备中
    RTMP_STATUE_Ready = 0,
    /// 连接中
    RTMP_STATUE_Pending = 1,
    /// 已连接
    RTMP_STATUE_Pushing = 2,
    /// 已断开
    RTMP_STATUE_Stop = 3,
    /// 连接出错
    RTMP_STATUE_Error = 4,
    ///  正在刷新
    RTMP_STATUE_Refresh = 5,
};

@interface SessionInf : NSObject

// 连接状态
@property(nonatomic ,assign) RTMPStatus status ;

// rtmp地址
@property(nonatomic, copy) NSString *rtmpUrl;

// 当前预览尺寸--宽度,为序列化方便而拆分
@property(nonatomic, assign) CGFloat previewWidth;

// 当前预览尺寸--高度,为序列化方便而拆分
@property(nonatomic, assign) CGFloat previewHeight;

/// 更新状态
-(void)updateStatus:(LFLiveState)status;

/// 加载session信息
-(void)loadSessionInf:(LFLiveSession *)sessionInf;

-(bool)pushing;
-(bool)waiting;

@end

NS_ASSUME_NONNULL_END
