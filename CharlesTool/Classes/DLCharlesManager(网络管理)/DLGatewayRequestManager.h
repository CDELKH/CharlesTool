//
//  DLGatewayRequestManager.h
//  NetSchool
//
//  Created by konghui on 2020/11/10.
//  Copyright © 2020 CDEL. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "DLDomainIPMapManager.h"

NS_ASSUME_NONNULL_BEGIN

@interface DLGatewayRequestManager : NSObject <DLDomainIPMapManagerDelegate>

+ (instancetype)sharedInstance;

- (NSString *)dealWithURL:(NSString *)urlString forRequest:(NSURLRequest *)request;

@end

NS_ASSUME_NONNULL_END
