//
//  DLRequestsInfoViewModel.m
//  NetSchool
//
//  Created by konghui on 2020/11/10.
//  Copyright © 2020 CDEL. All rights reserved.
//

#import "DLRequestsInfoViewModel.h"
#import "DLFilterDomainManager.h"
#import "DLDomainIPMapManager.h"

@interface DLRequestsInfoViewModel()

//@property (nonatomic, strong) NSMutableDictionary *cacheHeightDic;
@property (nonatomic, assign) BOOL isReversal;
@property (nonatomic, strong) NSString *searchText;
@property (nonatomic, strong) NSMutableArray *searchRequestArray;
@property (nonatomic, assign) BOOL searchRequestNeedUpdate;
@property (nonatomic, strong) RACDisposable *refreshDisposable;

@end

@implementation DLRequestsInfoViewModel

- (instancetype)init{
    self = [super init];
    if (self) {
        _reloadSignal = [RACSubject subject];
        _jumpToDetailSignal = [RACSubject subject];
//        _cacheHeightDic = [[NSMutableDictionary alloc] init];
        _searchRequestArray = [[NSMutableArray alloc] init];
        
        @weakify(self)
        self.refreshDisposable = [[DLFilterDomainManager sharedInstance].dataRefreshSignal subscribeNext:^(id x) {
            @strongify(self)
            self.searchRequestNeedUpdate = YES;
            [self.reloadSignal sendNext:nil];
        }];
    }
    return self;
}

- (NSMutableArray *)getRequestsInfo{
    NSArray *requestArray = [DLFilterDomainManager sharedInstance].filterRequestsArray;
    
    if (!self.searchText || self.searchText.length == 0) {
        if (self.searchRequestArray.count > 0) {
            [self.searchRequestArray removeAllObjects];
        }
        if (self.searchRequestNeedUpdate) {
            self.searchRequestNeedUpdate = NO;
        }
        return requestArray;
    }
    
    if (self.searchRequestNeedUpdate) {
        self.searchRequestNeedUpdate = NO;
        [self.searchRequestArray removeAllObjects];
        
        for (NSDictionary *requestInfo in requestArray) {
            NSString *requestURL = requestInfo[DL_CHARLES_REQUEST_INFO_KEY_URL];
            NSURL *domainRequestURL = requestInfo[DL_CHARLES_REQUEST_INFO_KEY_DOMAINRUL];
            if ([requestURL containsString:self.searchText] || [domainRequestURL.absoluteString containsString:self.searchText]) {
                [self.searchRequestArray addObject:requestInfo];
            }
        }
    }
    
    return self.searchRequestArray;
}

- (void)searchRequestWithText:(NSString *)text{
    if (![text isEqualToString:self.searchText]) {
        self.searchText = text;
        
        self.searchRequestNeedUpdate = YES;
        [self.reloadSignal sendNext:nil];
    }
}

- (NSInteger)numberOfItems{
    return [[self getRequestsInfo] count];
}

- (NSDictionary *)getRequestInfoItemAtIndexPath:(NSIndexPath *)indexPath{
//    NSString *infoKey;
    NSInteger indexPathRow;
    if (self.isReversal) {
        indexPathRow = indexPath.row;
//        infoKey = [NSString stringWithFormat:@"%ld",indexPath.row];
    } else {
        indexPathRow = [self numberOfItems] - 1 - indexPath.row;
//        infoKey = [NSString stringWithFormat:@"%ld",[self numberOfItems] - 1 - indexPath.row];
    }
    return [self getRequestsInfo][indexPathRow];
}

- (CGFloat)heightForRowAtIndexPath:(NSIndexPath *)indexPath{
//    NSString *infoKey;
//    if (self.isReversal) {
//        infoKey = [NSString stringWithFormat:@"%ld",indexPath.row];
//    } else {
//        infoKey = [NSString stringWithFormat:@"%ld",[self numberOfItems] - 1 - indexPath.row];
//    }
//    CGFloat cellHeight = 0;
//    if (self.cacheHeightDic[infoKey]) {
//        cellHeight = [self.cacheHeightDic[infoKey] floatValue];
//    }else{
//        NSDictionary *info = [self getRequestInfoItemAtIndexPath:indexPath];
//        NSString *url = info[DL_CHARLES_REQUEST_INFO_KEY_URL];
//        cellHeight = [CommUtls returnHeightFloat:url frontSize:[UIFont systemFontOfSize:15] frontWidth:kMainScreenWidth - 50 - 2 * 15] + 2 * 15;
//        cellHeight = cellHeight > 100 ? 100 : cellHeight;
//        cellHeight = 80;
//        self.cacheHeightDic[infoKey] = @(cellHeight);
//    };
//    CGFloat cellHeight = 80;
    return 80;
}

- (void)dataSourceReversalDisplay {
    self.isReversal = !self.isReversal;
    [self.reloadSignal sendNext:nil];
}

- (void)dealloc{
    if (self.refreshDisposable) {
        [self.refreshDisposable dispose];
        self.refreshDisposable = nil;
    }
}

@end
