//
//  DLCustomURLProtocol.m
//  NetSchool
//
//  Created by konghui on 2020/9/23.
//  Copyright © 2020 CDEL. All rights reserved.
//

#import "DLCustomURLProtocol.h"
#import "DLDomainIPMapManager.h"
#import <WebKit/WebKit.h>
#import "DLDebugManager.h"

static NSString * const DLCustomURLProtocolHandledKey = @"DLCustomURLProtocolHandledKey";

@interface DLCustomURLProtocol ()<NSURLSessionDataDelegate>

@property (nonatomic, strong) NSURLSession *session;
/**存放接受的信息*/
@property (nonatomic,strong) NSMutableData *mData;

@property (nonatomic, strong) NSMutableURLRequest *mutableRequest;

@property (nonatomic, assign) double startTime;

@end

@implementation DLCustomURLProtocol

// 此方法确定该协议是否能够处理给定的请求。
+ (BOOL)canInitWithRequest:(NSURLRequest *)request {
    // 只处理 http 和 https 请求
    NSString *scheme = [[request URL] scheme];
    if ([scheme caseInsensitiveCompare:@"http"] == NSOrderedSame || [scheme caseInsensitiveCompare:@"https"] == NSOrderedSame) {
        // 看看是否已经处理过了，防止无限循环
        if ([NSURLProtocol propertyForKey:DLCustomURLProtocolHandledKey inRequest:request]) {
            return NO;
        }
        
        // 打开调试模式就可以拦截所有的接口&&选择自己设置的环境会进行域名和IP的转换
        if ([DLDebugManager shareManager].supportDebug) {
            return YES;
        }
        return NO;
    }
    return NO;
}

+ (NSURLRequest *)canonicalRequestForRequest:(NSURLRequest *)request{
    // 处理url
    NSMutableURLRequest *ipRequest = [request mutableCopy];
    return ipRequest;
}

- (void)startLoading{
    self.startTime = [[NSDate date] timeIntervalSince1970] * 1000;
    NSMutableURLRequest *mutableRequest = [[self request] mutableCopy];
    self.mutableRequest = mutableRequest;
    [NSURLProtocol setProperty:@YES forKey:DLCustomURLProtocolHandledKey inRequest:mutableRequest];
    NSURLSessionConfiguration *sessionConfig = [NSURLSessionConfiguration defaultSessionConfiguration];
    self.session = [NSURLSession sessionWithConfiguration:sessionConfig delegate:self delegateQueue:nil];
    NSURLSessionDataTask *dataTask = [self.session dataTaskWithRequest:mutableRequest];
    [[DLDomainIPMapManager sharedInstance] appendRequest:mutableRequest];
    [[DLDomainIPMapManager sharedInstance] appendStarTime:self.startTime forRequest:mutableRequest];
    [dataTask resume];
}

- (void)stopLoading{
    // 这部分为需要统计时间的代码
    double end = [[NSDate date] timeIntervalSince1970] * 1000;
    [[DLDomainIPMapManager sharedInstance] appendTimeStatistics:(end - self.startTime) forRequest:self.mutableRequest];
    [self.session invalidateAndCancel];
    self.session = nil;
}

+ (BOOL)requestIsCacheEquivalent:(NSURLRequest *)a toRequest:(NSURLRequest *)b{
    return [super requestIsCacheEquivalent:a toRequest:b];
}

#pragma mark - NSURLSessionDelegate
- (void)URLSession:(NSURLSession *)session dataTask:(NSURLSessionDataTask *)dataTask didReceiveResponse:(NSURLResponse *)response completionHandler:(void (^)(NSURLSessionResponseDisposition))completionHandler {
    NSHTTPURLResponse *httpResponse = (NSHTTPURLResponse *)response;
    NSString *statusCode = [NSString stringWithFormat:@"%ld",(long)httpResponse.statusCode];
    [[DLDomainIPMapManager sharedInstance] appendStatusCode:statusCode forRequest:self.mutableRequest];
    
    self.mData = [NSMutableData data];
        
    [self.client URLProtocol:self didReceiveResponse:response cacheStoragePolicy:NSURLCacheStorageNotAllowed];
    completionHandler(NSURLSessionResponseAllow);
}

- (void)URLSession:(NSURLSession *)session dataTask:(NSURLSessionDataTask *)dataTask didReceiveData:(NSData *)data {
    [self.mData appendData:data];
    
    [self.client URLProtocol:self didLoadData:data];
}

- (void)URLSession:(NSURLSession *)session task:(NSURLSessionTask *)task didCompleteWithError:(NSError *)error{
    if (error) {
        [[DLDomainIPMapManager sharedInstance] appendStatusCode:DL_REQUESTSTATUSCODE_ERROR_INFO forRequest:self.mutableRequest];
        [[DLDomainIPMapManager sharedInstance] appendError:error forRequest:self.mutableRequest];
        [self.client URLProtocol:self didFailWithError:error];
    }else{
        [[DLDomainIPMapManager sharedInstance] appendResponseData:self.mData response:task.response forRequest:self.mutableRequest];
        
        [self.client URLProtocolDidFinishLoading:self];
    }
}

+ (BOOL)isAllowedChangeIP:(NSURLRequest *)request {
    BOOL isSupportDebug = [DLDebugManager shareManager].supportDebug;
    if ([DLDomainIPMapManager sharedInstance].enableChangeIPForDomain && [[DLDomainIPMapManager sharedInstance] canChangeToIPForDomain:[[request URL] host]] && isSupportDebug) {
        return YES;
    } else {
        return NO;
    }
}




#pragma mark - WKWebView的私有API
#pragma mark - 以下方法为iOS的私有方法，建议上线时注释————以下全部代码

+ (void)DL_unregisterScheme {
    [self wk_registerScheme:@"http"];
    [self wk_registerScheme:@"https"];
}

FOUNDATION_STATIC_INLINE Class ContextControllerClass() {
    static Class cls;
    if (!cls) {
        cls = [[[WKWebView new] valueForKey:@"browsingContextController"] class];
    }
    return cls;
}

FOUNDATION_STATIC_INLINE SEL RegisterSchemeSelector() {
    return NSSelectorFromString(@"registerSchemeForCustomProtocol:");
}

+ (void)wk_registerScheme:(NSString *)scheme {
    Class cls = ContextControllerClass();
    SEL sel = RegisterSchemeSelector();
    if ([(id)cls respondsToSelector:sel]) {
#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Warc-performSelector-leaks"
        [(id)cls performSelector:sel withObject:scheme];
#pragma clang diagnostic pop
    }
}

//FOUNDATION_STATIC_INLINE SEL UnregisterSchemeSelector() {
//    return NSSelectorFromString(@"unregisterSchemeForCustomProtocol:");
//}

//+ (void)wk_unregisterScheme:(NSString *)scheme {
//    Class cls = ContextControllerClass();
//    SEL sel = UnregisterSchemeSelector();
//    if ([(id)cls respondsToSelector:sel]) {
//#pragma clang diagnostic push
//#pragma clang diagnostic ignored "-Warc-performSelector-leaks"
//        [(id)cls performSelector:sel withObject:scheme];
//#pragma clang diagnostic pop
//    }
//}
//

@end
