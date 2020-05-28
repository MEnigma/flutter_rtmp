//
//  SessionInf.m
//  Pods
//
//  Created by 致命七八 on 2019/11/5.
//

#import "SessionInf.h"

@implementation SessionInf
-(void)loadSessionInf:(LFLiveSession *)sessionInf{
    self.previewHeight = CGRectGetHeight(sessionInf.preView.frame);
    self.previewWidth = CGRectGetWidth(sessionInf.preView.frame);
    self.rtmpUrl = sessionInf.streamInfo.url;
    [self updateStatus:sessionInf.state];
}
-(bool)pushing{
    return self.status == RTMP_STATUE_Pushing;
}
-(bool)waiting{
    return !self.pushing;
}
-(void)updateStatus:(LFLiveState)status{
    switch (status) {
        case LFLiveReady:{
            /// 准备
            _status = RTMP_STATUE_Ready;
        }
            break;
        case LFLivePending:{
            /// 连接中
            _status = RTMP_STATUE_Pending;
        }
            break;
        case LFLiveStart:{
            /// 已连接
            _status = RTMP_STATUE_Pushing;
        }
            break;
        case LFLiveStop:{
            /// 已断开
            _status = RTMP_STATUE_Stop;
        }
            break;
        case LFLiveError:{
            /// 连接出错
            _status = RTMP_STATUE_Error;
        }
            break;
        case LFLiveRefresh:{
            ///  正在刷新
            
            _status = RTMP_STATUE_Refresh;
        }
            break;
    }
}
@end
