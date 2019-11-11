//
//  Response.m
//  flutter_rtmp_publisher
//
//  Created by 致命七八 on 2019/11/5.
//

#import "Response.h"

@implementation Response
+(Response *)successfulResponse{
    Response *res = Response.new;
    res.succeed = true;
    res.message = @"succeed";
    return res;
}
+(Response *)failResponse:(NSString*)errmsg{
    Response *res = Response.new;
    res.succeed = false;
    res.message = errmsg;
    return res;
}


@end
