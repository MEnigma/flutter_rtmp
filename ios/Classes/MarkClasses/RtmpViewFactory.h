//
//  RtmpViewFactory.h
//  Pods
//
//  Created by 致命七八 on 2019/11/5.
//

#import <UIKit/UIKit.h>
#import <Flutter/Flutter.h>
#import "RtmpViewManager.h"
NS_ASSUME_NONNULL_BEGIN

@interface RtmpViewFactory : NSObject<FlutterPlatformViewFactory>
+(RtmpViewFactory *)factoryWithManager:(RtmpViewManager*)manager;

@end

@interface RtmpView : NSObject <FlutterPlatformView>
-(instancetype)initWithFrame:(CGRect)frame;
@end

NS_ASSUME_NONNULL_END
