//
//  RtmpViewFactory.m
//  Pods
//
//  Created by 致命七八 on 2019/11/5.
//

#import "RtmpViewFactory.h"

@interface RtmpViewFactory ()

@property(nonatomic,strong) RtmpViewManager *manager;

@end

@implementation RtmpViewFactory

+(RtmpViewFactory *)factoryWithManager:(RtmpViewManager *)manager{
    RtmpViewFactory *fac = RtmpViewFactory.new;
    fac.manager = manager;
    return fac;
}
-(NSObject<FlutterMessageCodec> *)createArgsCodec{
    return FlutterStandardMessageCodec.sharedInstance;
}
- (NSObject<FlutterPlatformView> *)createWithFrame:(CGRect)frame viewIdentifier:(int64_t)viewId arguments:(id)args{
    
    RtmpView *cameraView = [RtmpView.alloc initWithFrame:frame];
    self.manager.session.preView = cameraView.view;
    NSLog(@"will create view");
    return cameraView;
}


@end

@interface RtmpView ()
@property(nonatomic,assign) CGRect frame;
@property(nonatomic, strong) UIView *showView;
@end
@implementation RtmpView

-(instancetype)initWithFrame:(CGRect)frame{
    if (self = [super init]) {
        self.frame = frame;
    }
    if(!self.showView)
        self.showView = [UIView.alloc initWithFrame:frame];
    else
        self.showView.frame = frame;
    return self;
}
-(UIView *)view{
    return _showView;
}
@end
