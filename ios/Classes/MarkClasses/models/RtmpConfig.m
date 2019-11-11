//
//  RtmpConfig.m
//  flutter_rtmp_publisher
//
//  Created by 致命七八 on 2019/11/7.
//

#import "RtmpConfig.h"

@interface RtmpConfig ()
{
    RtmpVideoConfig *_videoConfig;
    RtmpAudioConfig *_audioConfig;
}
@end

@implementation RtmpConfig
-(void)loadData:(NSDictionary *)data{
    self.videoConfig = [RtmpVideoConfig.new mj_setKeyValues:data[@"videoConfig"]];
    self.audioConfig = [RtmpAudioConfig.new mj_setKeyValues:data[@"audioConfig"]];
}
-(void)setVideoConfig:(RtmpVideoConfig *)videoConfig{
    _videoConfig = nil;
    _videoConfig = videoConfig;
}
-(void)setAudioConfig:(RtmpAudioConfig *)audioConfig{
    _audioConfig = nil;
    _audioConfig = audioConfig;
}
-(RtmpVideoConfig *)videoConfig{
    if (!_videoConfig) {
        _videoConfig = RtmpVideoConfig.new;
    }
    return _videoConfig;
}
-(RtmpAudioConfig *)audioConfig{
    if (!_audioConfig) {
        _audioConfig = RtmpAudioConfig.new;
    }
    return _audioConfig;
}
@end


@implementation RtmpVideoConfig

-(LFLiveVideoConfiguration *)configuration{
    long quality = MIN(8,MAX(0, self.quality));
    return [LFLiveVideoConfiguration defaultConfigurationForQuality:quality outputImageOrientation:self.orientation == RtmpOrientationPortrait ? UIInterfaceOrientationPortrait : UIInterfaceOrientationLandscapeRight];
}

@end

@implementation RtmpAudioConfig 

-(LFLiveAudioConfiguration *)configuration{
    return [LFLiveAudioConfiguration defaultConfiguration];
}

@end
