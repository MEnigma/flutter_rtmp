//
//  RtmpConfig.h
//  flutter_rtmp_publisher
//
//  Created by 致命七八 on 2019/11/7.
//

#import <Foundation/Foundation.h>
#import <LFLiveKit/LFLiveKit.h>
#import <MJExtension/MJExtension.h>

NS_ASSUME_NONNULL_BEGIN

typedef NS_ENUM(NSInteger, RtmpOrientation){
    RtmpOrientationPortrait = 1,
    RtmpOrientationLandspace = 2
};

@class RtmpVideoConfig;
@class RtmpAudioConfig;

@interface RtmpConfig : NSObject

@property(nonatomic,strong) RtmpVideoConfig *videoConfig;
@property(nonatomic,strong) RtmpAudioConfig *audioConfig;

-(void)loadData:(NSDictionary *)data;

@end

@interface RtmpVideoConfig : NSObject

/// 自动旋转
@property(nonatomic, assign) bool autoRotate;

/// 质量 --> 0~8
@property (nonatomic ,assign) NSInteger quality;

/// 旋转方向
@property (nonatomic ,assign) RtmpOrientation orientation;


-(LFLiveVideoConfiguration *)configuration;

@end

@interface RtmpAudioConfig : NSObject


-(LFLiveAudioConfiguration *)configuration;

@end
NS_ASSUME_NONNULL_END
