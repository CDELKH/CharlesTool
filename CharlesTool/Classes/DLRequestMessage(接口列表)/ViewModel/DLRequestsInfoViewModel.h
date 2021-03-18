//
//  DLRequestsInfoViewModel.h
//  NetSchool
//
//  Created by konghui on 2020/11/10.
//  Copyright © 2020 CDEL. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface DLRequestsInfoViewModel : NSObject

@property (nonatomic, strong) RACSubject *reloadSignal;
@property (nonatomic, strong) RACSubject *jumpToDetailSignal;

- (NSInteger)numberOfItems;
- (NSDictionary *)getRequestInfoItemAtIndexPath:(NSIndexPath *)indexPath;
- (CGFloat)heightForRowAtIndexPath:(NSIndexPath *)indexPath;
- (void)dataSourceReversalDisplay;

- (void)searchRequestWithText:(NSString *)text;

@end

NS_ASSUME_NONNULL_END
