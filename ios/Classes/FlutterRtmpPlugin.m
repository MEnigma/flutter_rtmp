#import "FlutterRtmpPlugin.h"
#import <UIKit/UIKit.h>

#import "RtmpViewFactory.h"


@interface FlutterRtmpPlugin ()

@property(strong, nonatomic) UIViewController *viewController;
@property (nonatomic, strong) UIButton *cButton;
@property (nonatomic, retain) UIViewController *anotherViewController;

@end

@implementation FlutterRtmpPlugin
+ (void)registerWithRegistrar:(NSObject<FlutterPluginRegistrar> *)registrar {
    
    RtmpViewManager *manager = RtmpViewManager.new;
    [registrar registerViewFactory:[RtmpViewFactory factoryWithManager:manager] withId:DEF_CAMERA_RTMP_VIEW];
    
    [[FlutterMethodChannel methodChannelWithName:DEF_CAMERA_SETTING_CONFIG binaryMessenger:registrar.messenger] setMethodCallHandler:^(FlutterMethodCall * _Nonnull call, FlutterResult  _Nonnull result) {
        [manager handleMethod:call result:result];
    }];
    [manager registLivingStatueCallback:registrar.messenger];
    
}

/*{
    UIViewController *_viewController;
}



// + (void)registerWithRegistrar:(NSObject<FlutterPluginRegistrar>*)registrar {
//   [SwiftFlutterRtmpPublisherPlugin registerWithRegistrar:registrar];
// }

+ (void)registerWithRegistrar:(NSObject<FlutterPluginRegistrar> *)registrar {
  FlutterMethodChannel *channel =
      [FlutterMethodChannel methodChannelWithName:@"rtmp_publisher"
                                  binaryMessenger:registrar.messenger];
  UIViewController *viewController =
      [UIApplication sharedApplication].delegate.window.rootViewController;
    
    
  FlutterRtmpPublisherPlugin *plugin =
      [[FlutterRtmpPublisherPlugin alloc] initWithViewController:viewController];
  [registrar addMethodCallDelegate:plugin channel:channel];
}

- (UIButton*)cButton{
    if(!_cButton){
        _cButton = [UIButton new];
        _cButton.size = CGSizeMake(44, 44);
        _cButton.left = self.viewController.view.width - 10 - _cButton.width;
        _cButton.top = 20;
        [_cButton setImage:[UIImage imageNamed:@"close_preview"] forState:UIControlStateNormal];
        _cButton.exclusiveTouch = YES;
        [_cButton addBlockForControlEvents:UIControlEventTouchUpInside block:^(id sender) {
            //            [self.viewC.navigationController popViewControllerAnimated:YES];
            [self.viewController dismissViewControllerAnimated:YES completion:^{
              
            }];
            // self.result(@"Done");
            // [self.navigationController popViewControllerAnimated:YES];
        }];
    }
    return _cButton;
}

- (instancetype)initWithViewController:(UIViewController *)viewController {
  self = [super init];
  if (self) {
    self.viewController = viewController;
  }
  return self;
}

- (void)handleMethodCall:(FlutterMethodCall *)call result:(FlutterResult)result {
  NSString *url = call.arguments[@"url"];
    url = @"rtmp://122.225.234.90/live/mark";
  if ([@"stream" isEqualToString:call.method]) {
    _anotherViewController = [[UIViewController alloc] init];
    [self.viewController presentViewController:_anotherViewController animated:NO completion:nil];

      LMLivePreview *mainView = [[LMLivePreview alloc] initWithFrame:CGRectMake(0, 0, self.viewController.view.bounds.size.width, self.viewController.view.bounds.size.height)];
      
      mainView.streamUrl = url;
      mainView.viewC = self.viewController;
      // mainView.result = result;

    [mainView addSubview:self.cButton];
      
      _anotherViewController.view = mainView;
      // [_anotherViewController.view addSubview:mainView];
    // _qrcodeview= [[LMLivePreview alloc] initWithFrame:CGRectMake(0, 0, width, height) ];
    // [_viewController.view addSubview:[[LMLivePreview alloc] initWithFrame:CGRectMake(0, 0, self.viewController.view.bounds.size.width, self.viewController.view.bounds.size.height) ]];
    // [self.viewController.navigationController dismissViewControllerAnimated:YES completion:nil];
    result(@"null");
  } else {
    result(FlutterMethodNotImplemented);
  }
}
*/
@end

