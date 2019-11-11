//
//  RtmpViewManager.h
//  Pods
//
//  Created by 致命七八 on 2019/11/5.
//

#import <Foundation/Foundation.h>
#import "LFLiveSession.h"
#import <Flutter/Flutter.h>
#import "def.h"
#import "Handler.h"
#import "SessionInf.h"
#import "RtmpConfig.h"
//#import "RtmpViewFactory.h"

@class RtmpView;
NS_ASSUME_NONNULL_BEGIN


@interface RtmpViewManager : NSObject

@property(nonatomic ,strong) RtmpView * platformView;

@property(nonatomic, strong) LFLiveSession * session;

/// 注册回调方法
-(void)registLivingStatueCallback:(NSObject<FlutterBinaryMessenger>*)messenger;


-(void)handleMethod:(FlutterMethodCall *)method result:(FlutterResult)result;
@end

NS_ASSUME_NONNULL_END
