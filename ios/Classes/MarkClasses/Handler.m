//
//  Handler.m
//  flutter_rtmp_publisher
//
//  Created by 致命七八 on 2019/11/5.
//

#import "Handler.h"

@implementation Handler

@end

@implementation HoloLiveStatueHandler

-(FlutterError *)onListenWithArguments:(id)arguments eventSink:(FlutterEventSink)events{
    self.sink = events;
    return nil;
}
-(FlutterError *)onCancelWithArguments:(id)arguments{
    return nil;
}

@end
