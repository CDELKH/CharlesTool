//
//  DLFilterDomainManager.m
//  CharlesSpec
//
//  Created by konghui on 2021/2/6.
//

#import "DLFilterDomainManager.h"
#import "DLDomainIPMapManager.h"

#define DLFilterNoShowDomainListKey @"FilterNoShowDomainList"

@interface DLFilterDomainManager()

@property (nonatomic, strong) NSArray *originRequestArray;

@end

@implementation DLFilterDomainManager

+ (instancetype)sharedInstance{
    static DLFilterDomainManager *manager = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        manager = [[DLFilterDomainManager alloc] init];
        manager.dataRefreshSignal = [RACSubject subject];
        [manager makeOriginConfiguration];
        [manager filterData];
    });
    return manager;
}
 
- (id)copy{
    return [DLFilterDomainManager sharedInstance];
}

#pragma mark -init
- (void)makeOriginConfiguration{
    [[DLDomainIPMapManager sharedInstance].requestsInfoRefreshSignal subscribe:self.dataRefreshSignal];
    self.originRequestArray = [DLDomainIPMapManager sharedInstance].requestsArray;
}

- (void)filterData{
    NSArray *noShowDomainList = [[NSUserDefaults standardUserDefaults] objectForKey:DLFilterNoShowDomainListKey];
    for (NSDictionary *requestInfo in self.originRequestArray) {
    }
    self.filterRequestsArray = self.originRequestArray;
}

@end
