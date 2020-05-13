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

@property(nonatomic,strong)NSObject<FlutterBinaryMessenger> * _messenger;

@property(nonatomic,strong) RtmpConfig *config;
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
#pragma mark 设置
/// 设置url
-(void)startLive:(NSDictionary *)param result:(FlutterResult )result{
    LFLiveStreamInfo *stream = LFLiveStreamInfo.new;
    stream.url = param[@"url"];
    
    @try{
        NSLog(@"--- startLive ---");
        [self.session startLive:stream];
        if(result)result([Response successfulResponse].mj_JSONObject);
    }@catch(NSException *e){
        Response *response = [Response failResponse: [NSString stringWithFormat:@"%@",e]];
        if(result)result([response mj_JSONObject]);
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
    NSLog(@"--- init config ---");
    [self requestAccessForAudio];
    [self requestAccessForVideo];
    if(result){
        result(Response.successfulResponse.mj_JSONObject);
    }
}
/// 停止直播
-(void)stopLive:(NSDictionary *)param result:(FlutterResult)result{
    if(self.session && self.session.state == LFLiveStart){
        @try {
            [self.session stopLive];
            if(result){
                result(Response.successfulResponse.mj_JSONObject);
            }
        } @catch (NSException *exception) {
            if(result){
                result([Response failResponse:[NSString stringWithFormat:@"%@",exception]].mj_JSONObject);
            }
        }
    }
}
/// 暂停
-(void)pauseLive:(NSDictionary *)param result:(FlutterResult)result{
    if(self.session && self.session.state == LFLiveStart){
        @try {
            [self.session stopLive];
            if(result){
                result(Response.successfulResponse.mj_JSONObject);
            }
        } @catch (NSException *exception) {
            if(result){
                result([Response failResponse:[NSString stringWithFormat:@"%@",exception]].mj_JSONObject);
            }
        }
        
    }
}
/// 恢复
-(void)resumeLive:(NSDictionary *)param result:(FlutterResult)result{
    if (self.session) {
        @try {
            [self.session startLive:self.session.streamInfo];
            if(result)
                result(Response.successfulResponse.mj_JSONObject);
        } @catch (NSException *exception) {
            if(result)
                result([Response failResponse:[NSString stringWithFormat:@"%@",exception]].mj_JSONObject);
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
            if(result)
                result(Response.successfulResponse.mj_JSONObject);
        } @catch (NSException *exception) {
            if(result)
                result([Response failResponse:[NSString stringWithFormat:@"%@",exception]].mj_JSONObject);
        }
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
}
-(void)liveSession:(LFLiveSession *)session liveStateDidChange:(LFLiveState)state{
    SessionInf *inf = SessionInf.new;
    inf.state = state;
    if(_statueChannel && _statueHandler){
        _statueHandler.sink([inf mj_JSONObject]);
    }
    
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


@end
