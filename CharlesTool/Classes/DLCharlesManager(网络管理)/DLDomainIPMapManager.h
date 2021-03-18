//
//  DLDomainIPMapManager.h
//  NetSchool
//
//  Created by konghui on 2020/9/24.
//  Copyright © 2020 CDEL. All rights reserved.
//

#import <Foundation/Foundation.h>

#define DL_WANTEST_WIFI_NAME @"DL-WanTest"
#define DL_LANTEST_WIFI_NAME @"DL-LanTest"

#define DL_CHARLES_REQUEST_INFO_KEY_DOMAINRUL @"domainRequestURL"
#define DL_CHARLES_REQUEST_INFO_KEY_URL @"requestURL"
#define DL_CHARLES_REQUEST_INFO_KEY_PARAMAS @"requestParamas"
#define DL_CHARLES_REQUEST_INFO_KEY_STATUSCODE @"requestStatusCode"
#define DL_CHARLES_REQUEST_INFO_KEY_RESPONSEDATA @"requestResponseData"
#define DL_CHARLES_REQUEST_INFO_KEY_STARTIME @"starTimeMessage"
#define DL_CHARLES_REQUEST_INFO_KEY_TIMESTATISTICS @"timeConsumingStatistics"
#define DL_CHARLES_REQUEST_INFO_KEY_ERROR @"errorMessage"

#define DL_REQUESTSTATUSCODE_ERROR_INFO @"请求失败"

NS_ASSUME_NONNULL_BEGIN

@protocol DLDomainIPMapManagerDelegate <NSObject>

- (NSString *)dealWithURL:(NSString *)urlString forRequest:(NSURLRequest *)request;
- (NSString *)dealWithStatusCode:(NSString *)statusCode forRequest:(NSURLRequest *)request;
- (NSString *)dealWithResponseData:(NSString *)responseData forRequest:(NSURLRequest *)request;

@end

@interface DLDomainIPMapManager : NSObject

+ (instancetype)sharedInstance;

/// 是否开启域名ip转换操作
@property (nonatomic, assign) BOOL enableChangeIPForDomain;

@property (nonatomic, weak) id<DLDomainIPMapManagerDelegate> delegate;
//@property (nonatomic, readonly) NSMutableDictionary *requestsInfoDic;
@property (nonatomic, readonly) NSMutableArray *requestsArray;
@property (nonatomic, readonly) NSMutableArray *requestsHostArray;
@property (nonatomic, strong) RACSubject *requestsInfoRefreshSignal;

/// 设置自定义映射关系
/// @param relation <#relation description#>
- (void)setCustomizedMapRelation:(nullable NSDictionary *)relation;

/// 域名可否转换成ip
/// @param domain <#domain description#>
- (BOOL)canChangeToIPForDomain:(NSString *)domain;
/// 通过域名获取ip
/// @param domain <#domain description#>
- (NSString *)getIPWithDomain:(NSString *)domain;
/// 清理数据
- (void)clearRequestsInfoDic;

- (void)appendRequest:(NSURLRequest *)request;
- (void)appendTimeStatistics:(double)time forRequest:(NSURLRequest *)request;
- (void)appendStarTime:(double)time forRequest:(NSURLRequest *)request;
- (void)appendStatusCode:(NSString *)statusCode forRequest:(NSURLRequest *)request;
- (void)appendError:(NSError *)error forRequest:(NSURLRequest *)request;
- (void)appendResponseData:(NSData *)data response:(NSURLResponse *)response forRequest:(NSURLRequest *)request;

@end

NS_ASSUME_NONNULL_END
