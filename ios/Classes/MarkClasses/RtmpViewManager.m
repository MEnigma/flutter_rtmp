//
//  RtmpViewManager.m
//  Pods
//
//  Created by 致命七八 on 2019/11/5.
//

#import "RtmpViewManager.h"

@interface RtmpViewManager ()<LFLiveSessionDelegate>

@property (nonatomic, assign) int64_t viewid;
@property (nonatomic, assign) FlutterEventChannel *statueChannel;
@property (nonatomic, strong) HoloLiveStatueHandler *statueHandler;

@property (nonatomic, strong) NSObject<FlutterBinaryMessenger> * _messenger;

@property (nonatomic, strong) SessionInf *snapshot;
@property (nonatomic, strong) RtmpConfig *config;
@end
@implementation RtmpViewManager

#pragma mark public
-(void)registLivingStatueCallback:(NSObject<FlutterBinaryMessenger> *)messenger{
    self._messenger = messenger;
    //    [self initConfig:nil result:nil];
    
}
-(void)handleMethod:(FlutterMethodCall *)method result:(FlutterResult)result{
    NSString *methodName =[NSString stringWithFormat:@"%@:result:",method.method];
    if([self respondsToSelector:NSSelectorFromString(methodName)]){
        [self performSelector:NSSelectorFromString(methodName) withObject:method.arguments withObject:result];
    }else{
        result(FlutterMethodNotImplemented);
    }
}

-(void)logat:(NSString *)method params:(id)argus{
    if (self.config && self.config.debugmode){
        NSLog(@">> [Flutter RTMP] %@ --> param : %@",method,argus);
    }
}

#pragma mark 设置
/// 设置url
-(void)startLive:(NSDictionary *)param result:(FlutterResult )result{
    LFLiveStreamInfo *stream = LFLiveStreamInfo.new;
    stream.url = param[@"url"];
    
    @try{
        [self.session startLive:stream];
        [self.snapshot loadSessionInf:self.session];
        if(result)result([Response make:true
                                message:@""
                                 result:self.snapshot.mj_JSONObject
                                errcode:ErrCodeNone].mj_JSONObject);
    }@catch(NSException *e){
        if(result)result([Response make:false
                                message:e.description
                                 result:self.snapshot.mj_JSONObject
                                errcode:ErrCodeNone].mj_JSONObject);
    }
}
/// 基础配置:配置回调
-(void)initConfig:(NSDictionary *)param result:(FlutterResult)result{
    
    if(param){
        [self.config loadData:param];
        UIView *preview = self.session.preView;
        _session = nil;
        [self session];
        self.session.preView = preview;
    }
    [self requestAccessForAudio];
    [self requestAccessForVideo];
    [self.snapshot loadSessionInf:self.session];
    if(result){
        result([Response make:true
                      message:@""
                       result:self.snapshot.mj_JSONObject
                      errcode:ErrCodeNone].mj_JSONObject);
    }
}
/// 停止直播
-(void)stopLive:(NSDictionary *)param result:(FlutterResult)result{
    if(self.session && self.session.state == LFLiveStart){
        @try {
            [self.session stopLive];
            [self.snapshot loadSessionInf:self.session];
            if(result){
                result([Response make:true
                              message:@""
                               result:self.snapshot.mj_JSONObject
                              errcode:ErrCodeNone].mj_JSONObject);
            }
        } @catch (NSException *exception) {
            if(result){
                result([Response make:false
                              message:exception.description
                               result:self.snapshot.mj_JSONObject
                              errcode:ErrCodeNone].mj_JSONObject);
            }
        }
    }
}
/// 暂停
-(void)pauseLive:(NSDictionary *)param result:(FlutterResult)result{
    if(self.session && self.session.state == LFLiveStart){
        @try {
            [self.session stopLive];
            [self.snapshot loadSessionInf:self.session];
            if(result){
                result([Response make:true
                              message:@""
                               result:self.snapshot.mj_JSONObject
                              errcode:ErrCodeNone].mj_JSONObject);
            }
        } @catch (NSException *exception) {
            if(result){
                result([Response make:false
                              message:exception.description
                               result:self.snapshot.mj_JSONObject
                              errcode:ErrCodeNone].mj_JSONObject);
            }
        }
        
    }
}
/// 恢复
-(void)resumeLive:(NSDictionary *)param result:(FlutterResult)result{
    if (self.session) {
        @try {
            [self.session startLive:self.session.streamInfo];
            [self.snapshot loadSessionInf:self.session];
            if(result)
                result([Response make:true
                              message:@""
                               result:self.snapshot.mj_JSONObject
                              errcode:ErrCodeNone].mj_JSONObject);
            
        } @catch (NSException *exception) {
            if(result)
                result([Response make:false
                              message:exception.description
                               result:self.snapshot.mj_JSONObject
                              errcode:ErrCodeNone].mj_JSONObject);
            
        }
    }
    
}

/// x切换摄像头
-(void)switchCamera:(NSDictionary *)param result:(FlutterResult)result{
    if (self.session) {
        @try {
            LFLiveState oriState = self.session.state;
            if (oriState == LFLiveStart) [self.session stopLive];
            if(self.session.captureDevicePosition == AVCaptureDevicePositionBack){
                [self.session setCaptureDevicePosition:AVCaptureDevicePositionFront];
            }else{
                [self.session setCaptureDevicePosition:AVCaptureDevicePositionBack];
            }
            if (oriState == LFLiveStart) [self.session startLive:self.session.streamInfo];
            [self.snapshot loadSessionInf:self.session];
            if(result)
                result([Response make:true
                              message:@""
                               result:self.snapshot.mj_JSONObject
                              errcode:ErrCodeNone].mj_JSONObject);
        } @catch (NSException *exception) {
            if(result)
                result([Response make:false
                              message:exception.description
                               result:self.snapshot.mj_JSONObject
                              errcode:ErrCodeNone].mj_JSONObject);
            
        }
    }
}

/// 获取快照
-(void)snapshot:(NSDictionary *)param result:(FlutterResult)result{
    if (self.session){
        [self.snapshot loadSessionInf:self.session];
        result([Response make:true message:@"" result:self.snapshot.mj_JSONObject errcode:ErrCodeNone].mj_JSONObject);
    }else{
        result([Response failResponse:@"no session"].mj_JSONObject);
    }
}

- (void)requestAccessForVideo{
    __weak typeof(self) _self = self;
    AVAuthorizationStatus status = [AVCaptureDevice authorizationStatusForMediaType:AVMediaTypeVideo];
    switch (status) {
        case AVAuthorizationStatusNotDetermined:{
            // 许可对话没有出现，发起授权许可
            [AVCaptureDevice requestAccessForMediaType:AVMediaTypeVideo completionHandler:^(BOOL granted) {
                if (granted) {
                    dispatch_async(dispatch_get_main_queue(), ^{
                        [_self.session setRunning:YES];
                    });
                }
            }];
            break;
        }
        case AVAuthorizationStatusAuthorized:{
            // 已经开启授权，可继续
            //dispatch_async(dispatch_get_main_queue(), ^{
            [_self.session setRunning:YES];
            //});
            break;
        }
        case AVAuthorizationStatusDenied:
        case AVAuthorizationStatusRestricted:
            // 用户明确地拒绝授权，或者相机设备无法访问
            
            break;
        default:
            break;
    }
}

- (void)requestAccessForAudio{
    AVAuthorizationStatus status = [AVCaptureDevice authorizationStatusForMediaType:AVMediaTypeAudio];
    switch (status) {
        case AVAuthorizationStatusNotDetermined:{
            [AVCaptureDevice requestAccessForMediaType:AVMediaTypeAudio completionHandler:^(BOOL granted) {
            }];
            break;
        }
        case AVAuthorizationStatusAuthorized:{
            break;
        }
        case AVAuthorizationStatusDenied:
        case AVAuthorizationStatusRestricted:
            break;
        default:
            break;
    }
}



#pragma mark delegate
-(void)liveSession:(LFLiveSession *)session debugInfo:(LFLiveDebug *)debugInfo{
    if(_statueChannel && _statueHandler){
        _statueHandler.sink([debugInfo mj_JSONString]);
    }
    [self.snapshot loadSessionInf:session];
}
-(void)liveSession:(LFLiveSession *)session liveStateDidChange:(LFLiveState)state{
    SessionInf *inf = SessionInf.new;
    if(_statueChannel && _statueHandler){
        _statueHandler.sink([inf mj_JSONObject]);
    }
    [self.snapshot loadSessionInf:session];
    [self.snapshot updateStatus:state];
}
#pragma mark lazy load
-(RtmpConfig *)config{
    if (!_config) {
        _config = RtmpConfig.new;
    }
    return _config;
}
-(LFLiveSession *)session{
    if (!_session) {
        _session = [LFLiveSession.alloc initWithAudioConfiguration:self.config.audioConfig.configuration
                                                videoConfiguration:self.config.videoConfig.configuration];
        _session.delegate = self;
    }
    return _session;
}

-(SessionInf *)snapshot{
    if (!_snapshot) {
        _snapshot = SessionInf.new;
    }
    return _snapshot;
}

@end
