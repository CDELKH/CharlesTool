//
//  DLGatewayRequestManager.m
//  NetSchool
//
//  Created by konghui on 2020/11/10.
//  Copyright © 2020 CDEL. All rights reserved.
//

#import "DLGatewayRequestManager.h"

@implementation DLGatewayRequestManager

#pragma mark - 单例
+ (instancetype)sharedInstance{
    static DLGatewayRequestManager *shareInstance;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        shareInstance = [super allocWithZone:NULL];
    });
    return shareInstance;
}

+ (id)allocWithZone:(struct _NSZone *)zone
{
    return [DLGatewayRequestManager sharedInstance];
}

+ (id)copy
{
    return [DLGatewayRequestManager sharedInstance];
}

#pragma mark - protocol
- (NSString *)dealWithURL:(NSString *)urlString forRequest:(NSURLRequest *)request{
    if ([urlString containsString:@"doorman"]) {
        uint8_t sub[1024] = {0};
        NSInputStream *inputStream = request.HTTPBodyStream;
        NSMutableData *body = [[NSMutableData alloc] init];
        [inputStream open];
        while ([inputStream hasBytesAvailable]) {
            NSInteger len = [inputStream read:sub maxLength:1024];
            if (len > 0 && inputStream.streamError == nil) {
                [body appendBytes:(void *)sub length:len];
            }else{
                break;
            }
        }
        NSString *requestData = [[NSString alloc] initWithData:body encoding:NSUTF8StringEncoding];
        return requestData;
    }
    return urlString;
}

@end
