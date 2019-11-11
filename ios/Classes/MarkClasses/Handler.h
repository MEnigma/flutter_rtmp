//
//  Handler.h
//  flutter_rtmp_publisher
//
//  Created by 致命七八 on 2019/11/5.
//

#import <Foundation/Foundation.h>
#import <Flutter/Flutter.h>
NS_ASSUME_NONNULL_BEGIN

@interface Handler : NSObject<FlutterStreamHandler>

@property(nonatomic) FlutterEventSink sink;

@end


@interface HoloLiveStatueHandler : Handler<FlutterStreamHandler>


@end

NS_ASSUME_NONNULL_END
