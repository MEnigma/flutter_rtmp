//
//  Response.h
//  flutter_rtmp_publisher
//
//  Created by 致命七八 on 2019/11/5.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

typedef NS_ENUM(NSInteger,ErrCode){
    ErrCodeNone = 0,               // 无错误
    ErrCodeRepeatOperation = 1,    // 重复操作
    ErrCodeUnKnown = 2,            // 未知错误
};

@interface Response : NSObject
+(Response *)successfulResponse;
+(Response *)failResponse:(NSString*)errmsg;
+(Response *)make:(bool)succeed message :(NSString *)message result:(NSDictionary *)result errcode:(ErrCode)errcode;

@property(nonatomic) bool succeed;

@property(nonatomic, copy) NSString* message;

@property(nonatomic, strong) NSDictionary *result;

@property (nonatomic, assign) ErrCode errorCode;

@end

NS_ASSUME_NONNULL_END
