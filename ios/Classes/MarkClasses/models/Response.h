//
//  Response.h
//  flutter_rtmp_publisher
//
//  Created by 致命七八 on 2019/11/5.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface Response : NSObject
+(Response *)successfulResponse;
+(Response *)failResponse:(NSString*)errmsg;

@property(nonatomic) bool succeed;

@property(nonatomic, copy) NSString* message;

@end

NS_ASSUME_NONNULL_END
