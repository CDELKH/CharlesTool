//
//  DLDomainIPMapManager.m
//  NetSchool
//
//  Created by konghui on 2020/9/24.
//  Copyright © 2020 CDEL. All rights reserved.
//

#import "DLDomainIPMapManager.h"
#import <JSONKit-NoWarning/JSONKit.h>

#define DL_REQUESTSTATUSCODE_INITIAL_INFO @"请求中"
#define DL_REQUESTRESPONSEDATA_INITIAL_INFO @"无"

#define DL_ENABLE_CHANGE_IP_FORDOMAIN_SIGN @"DLEnableChangeIPForDomainSign"
#define DL_IP_DOMAIN_MAP_CACHE @"DLIpDomainMapCache"
// 保存请求信息条目数
#define DL_NET_MESSAGE_COUNT 200

@interface DLDomainIPMapManager ()

@property (nonatomic, strong) NSMutableDictionary *currentValidMapRelation;
@property (nonatomic, strong) NSMutableArray *requests;
//@property (nonatomic, strong) NSMutableDictionary *requestsInfoDic;
@property (nonatomic, strong) NSMutableArray *requestsArray;
@property (nonatomic, strong) NSMutableArray *requestsHostArray;

@end

@implementation DLDomainIPMapManager

#pragma mark - 单例
+ (instancetype)sharedInstance{
    static DLDomainIPMapManager *shareInstance;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        shareInstance = [super allocWithZone:NULL];
        [shareInstance initConfiguration];
    });
    return shareInstance;
}

+ (id)allocWithZone:(struct _NSZone *)zone
{
    return [DLDomainIPMapManager sharedInstance];
}

+ (id)copy
{
    return [DLDomainIPMapManager sharedInstance];
}

- (void)initConfiguration{
    _requests = [[NSMutableArray alloc] init];
    _requestsArray = [[NSMutableArray alloc] init];
    _requestsHostArray = [[NSMutableArray alloc] init];
    _requestsInfoRefreshSignal = [[RACSubject subject] setNameWithFormat:@"%@ requestsInfoRefreshSignal",[self class]];
    
    NSNumber *enableChangeIPForDomain = [[NSUserDefaults standardUserDefaults] objectForKey:DL_ENABLE_CHANGE_IP_FORDOMAIN_SIGN];
    _enableChangeIPForDomain = [enableChangeIPForDomain boolValue];
    if(_enableChangeIPForDomain){
        NSDictionary *mapRelation = [[NSUserDefaults standardUserDefaults] objectForKey:DL_IP_DOMAIN_MAP_CACHE];
        self.currentValidMapRelation = [mapRelation mutableCopy];
    }
}

#pragma mark -
- (void)setEnableChangeIPForDomain:(BOOL)enableChangeIPForDomain{
    _enableChangeIPForDomain = enableChangeIPForDomain;
    
    [[NSUserDefaults standardUserDefaults] setObject:@(enableChangeIPForDomain) forKey:DL_ENABLE_CHANGE_IP_FORDOMAIN_SIGN];
    
    if (!enableChangeIPForDomain && self.currentValidMapRelation) {
        [self setCustomizedMapRelation:nil];
    }
}

- (void)setCustomizedMapRelation:(NSDictionary *)relation{
    self.currentValidMapRelation = [relation mutableCopy];
    
    if (relation) {
        [[NSUserDefaults standardUserDefaults] setObject:relation forKey:DL_IP_DOMAIN_MAP_CACHE];
    }else{
        [[NSUserDefaults standardUserDefaults] removeObjectForKey:DL_IP_DOMAIN_MAP_CACHE];
    }
}

- (BOOL)canChangeToIPForDomain:(NSString *)domain{
    if ([self.currentValidMapRelation.allKeys containsObject:domain]) {
        return YES;
    }else{
        return NO;
    }
}

- (NSString *)getIPWithDomain:(NSString *)domain{
    if ([self.currentValidMapRelation.allKeys containsObject:domain]) {
        return self.currentValidMapRelation[domain];
    }
    return domain;
}

#pragma mark -
- (void)appendRequest:(NSURLRequest *)request{
    @synchronized (self.requests, self.requestsArray) {
        [self.requests addObject:request];
        NSMutableDictionary *info = [[NSMutableDictionary alloc] initWithCapacity:6];
        [self.requestsArray addObject:info];
        NSString *host = request.URL.host;
        if (host && ![self.requestsHostArray containsObject:host]) {
            [self.requestsHostArray addObject:host];
        }
        
        NSString *urlInfo = request.URL.absoluteString;
        NSDictionary *requestDic = [NSDictionary dictionary];
        if (self.delegate && [self.delegate respondsToSelector:@selector(dealWithURL:forRequest:)]) {
            urlInfo = [self.delegate dealWithURL:urlInfo forRequest:request];
            requestDic = [urlInfo objectFromJSONString];
        }
        if (urlInfo && urlInfo.length > 0) {
            NSString *pathString = requestDic[@"resourcePath"];
            if (pathString && pathString.length > 0) {
                [info setValue:request.URL forKey:DL_CHARLES_REQUEST_INFO_KEY_DOMAINRUL];
                [info setValue:requestDic[@"resourcePath"] forKey:DL_CHARLES_REQUEST_INFO_KEY_URL];
            } else {
                [info setValue:urlInfo forKey:DL_CHARLES_REQUEST_INFO_KEY_URL];
            }
            [info setValue:urlInfo forKey:DL_CHARLES_REQUEST_INFO_KEY_PARAMAS];
            [info setValue:DL_REQUESTSTATUSCODE_INITIAL_INFO forKey:DL_CHARLES_REQUEST_INFO_KEY_STATUSCODE];
            [info setValue:DL_REQUESTRESPONSEDATA_INITIAL_INFO forKey:DL_CHARLES_REQUEST_INFO_KEY_RESPONSEDATA];
            [info setValue:DL_CHARLES_REQUEST_INFO_KEY_TIMESTATISTICS forKey:DL_CHARLES_REQUEST_INFO_KEY_TIMESTATISTICS];
           
            [self.requestsArray replaceObjectAtIndex:[self.requests indexOfObject:request] withObject:info];
    //        [self.requestsInfoDic setValue:info forKey:[NSString stringWithFormat:@"%ld",[self.requests indexOfObject:request]]];
        } else {
            [info setValue:request.URL.absoluteString forKey:DL_CHARLES_REQUEST_INFO_KEY_URL];
            [info setValue:request.URL.absoluteString forKey:DL_CHARLES_REQUEST_INFO_KEY_PARAMAS];
            [info setValue:DL_REQUESTSTATUSCODE_INITIAL_INFO forKey:DL_CHARLES_REQUEST_INFO_KEY_STATUSCODE];
            [info setValue:DL_REQUESTRESPONSEDATA_INITIAL_INFO forKey:DL_CHARLES_REQUEST_INFO_KEY_RESPONSEDATA];
            [info setValue:DL_CHARLES_REQUEST_INFO_KEY_TIMESTATISTICS forKey:DL_CHARLES_REQUEST_INFO_KEY_TIMESTATISTICS];
           
            [self.requestsArray replaceObjectAtIndex:[self.requests indexOfObject:request] withObject:info];
        }
        if (self.requests.count > DL_NET_MESSAGE_COUNT) {
            [self.requests removeObjectAtIndex:0];
            [self.requestsArray removeObjectAtIndex:0];
        }
        [self.requestsInfoRefreshSignal sendNext:nil];
    }
}

- (void)appendStarTime:(double)time forRequest:(NSURLRequest *)request {
    @synchronized (self.requests, self.requestsArray) {
        if ([self.requests containsObject:request]) {
            // 实例化NSDateFormatter
            NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
            // 设置日期格式
            [formatter setDateFormat:@"HH:mm:ss:SSS"];
            // 获取当前日期
            NSDate *currentDate = [NSDate date];
            NSString *currentDateString = [formatter stringFromDate:currentDate];
    //        NSMutableDictionary *info = [self.requestsInfoDic valueForKey:[NSString stringWithFormat:@"%ld",[self.requests indexOfObject:request]]];
            NSMutableDictionary *info = [self.requestsArray objectAtIndex:[self.requests indexOfObject:request]];
            [info setValue:currentDateString forKey:DL_CHARLES_REQUEST_INFO_KEY_STARTIME];
            [self.requestsInfoRefreshSignal sendNext:nil];
        }else{
            NSLog(@"追加请求状态码error 未找到请求");
        }
    }
}

- (void)appendTimeStatistics:(double)time forRequest:(NSURLRequest *)request {
    @synchronized (self.requests, self.requestsArray) {
        if ([self.requests containsObject:request]) {
            NSString *consumTime = [NSString stringWithFormat:@"%.1lf",time];
    //        NSMutableDictionary *info = [self.requestsInfoDic valueForKey:[NSString stringWithFormat:@"%ld",[self.requests indexOfObject:request]]];
            NSMutableDictionary *info = [self.requestsArray objectAtIndex:[self.requests indexOfObject:request]];
            [info setValue:consumTime forKey:DL_CHARLES_REQUEST_INFO_KEY_TIMESTATISTICS];
            [self.requestsInfoRefreshSignal sendNext:nil];
        }else{
            NSLog(@"追加请求状态码error 未找到请求");
        }
    }
}

- (void)appendError:(NSError *)error forRequest:(NSURLRequest *)request {
    @synchronized (self.requests, self.requestsArray) {
        if ([self.requests containsObject:request]) {
    //        NSMutableDictionary *info = [self.requestsInfoDic valueForKey:[NSString stringWithFormat:@"%ld",[self.requests indexOfObject:request]]];
            NSMutableDictionary *info = [self.requestsArray objectAtIndex:[self.requests indexOfObject:request]];
            [info setValue:error.description forKey:DL_CHARLES_REQUEST_INFO_KEY_ERROR];
            [self.requestsInfoRefreshSignal sendNext:nil];
        }else{
            NSLog(@"追加请求状态码error 未找到请求");
        }
    }
}

- (void)appendStatusCode:(NSString *)statusCode forRequest:(NSURLRequest *)request{
    @synchronized (self.requests, self.requestsArray) {
        if ([self.requests containsObject:request]) {
            NSString *code = statusCode;
            if (self.delegate && [self.delegate respondsToSelector:@selector(dealWithStatusCode:forRequest:)]) {
                code = [self.delegate dealWithStatusCode:code forRequest:request];
            }
    //        NSMutableDictionary *info = [self.requestsInfoDic valueForKey:[NSString stringWithFormat:@"%ld",[self.requests indexOfObject:request]]];
            NSMutableDictionary *info = [self.requestsArray objectAtIndex:[self.requests indexOfObject:request]];
            [info setValue:code forKey:DL_CHARLES_REQUEST_INFO_KEY_STATUSCODE];
            [self.requestsInfoRefreshSignal sendNext:nil];
        }else{
            NSLog(@"追加请求状态码error 未找到请求");
        }
    }
}

- (void)appendResponseData:(NSData *)data response:(nonnull NSURLResponse *)response forRequest:(nonnull NSURLRequest *)request{
    @synchronized (self.requests, self.requestsArray) {
        if ([self.requests containsObject:request]) {
            if ([data isKindOfClass:[NSData class]]) {
                NSString *responseData = nil;
                NSStringEncoding *stringEncoding = nil;
                NSString *textEncodingName = response.textEncodingName;
                if (textEncodingName != nil && ![textEncodingName isEqual:[NSNull null]]) {
                    CFStringEncoding cfEncoding = CFStringConvertIANACharSetNameToEncoding((CFStringRef)textEncodingName);
                    if (cfEncoding != kCFStringEncodingInvalidId) {
                        stringEncoding = CFStringConvertEncodingToNSStringEncoding(cfEncoding);
                    }
                }
                
                /*格式化jsonstring*/
                NSData *encodeData = data;
                NSError *error;
                id jsonObject = [NSJSONSerialization JSONObjectWithData:data options:nil error:&error];
                if (!error) {
                    NSData *prettyJsonData = [NSJSONSerialization dataWithJSONObject:jsonObject options:NSJSONWritingPrettyPrinted error:&error];
                    if (!error) {
                        encodeData = prettyJsonData;
                    }
                }
                if (stringEncoding) {
                    responseData = [[NSString alloc] initWithData:encodeData encoding:stringEncoding];
                }else{
                    responseData = [[NSString alloc] initWithData:encodeData encoding:NSUTF8StringEncoding];
                }
                
                if (self.delegate && [self.delegate respondsToSelector:@selector(dealWithResponseData:forRequest:)]) {
                    responseData = [self.delegate dealWithResponseData:responseData forRequest:request];
                }
    //            NSMutableDictionary *info = [self.requestsInfoDic valueForKey:[NSString stringWithFormat:@"%ld",[self.requests indexOfObject:request]]];
                NSMutableDictionary *info = [self.requestsArray objectAtIndex:[self.requests indexOfObject:request]];
                [info setValue:responseData forKey:DL_CHARLES_REQUEST_INFO_KEY_RESPONSEDATA];
                [self.requestsInfoRefreshSignal sendNext:nil];
            }
        }else{
            NSLog(@"追加请求响应error 未找到请求");
        }
    }
}

- (void)clearRequestsInfoDic {
    [self.requests removeAllObjects];
    [self.requestsArray removeAllObjects];
    [self.requestsHostArray removeAllObjects];
}

// TODO: requestsInfoRefreshSignal 一个请求会触发很多次该信号

@end
