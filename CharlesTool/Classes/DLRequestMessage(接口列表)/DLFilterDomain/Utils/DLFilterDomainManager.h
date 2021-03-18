//
//  DLFilterDomainManager.h
//  CharlesSpec
//
//  Created by konghui on 2021/2/6.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface DLFilterDomainManager : NSObject

+ (instancetype)sharedInstance;

@property (nonatomic, strong) RACSubject *dataRefreshSignal;
@property (nonatomic, strong) NSArray *filterRequestsArray;

@end

NS_ASSUME_NONNULL_END
