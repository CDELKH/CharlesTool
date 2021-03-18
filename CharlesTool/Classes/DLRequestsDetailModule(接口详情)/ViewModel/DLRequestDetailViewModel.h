//
//  DLRequestDetailViewModel.h
//  NetSchool
//
//  Created by 郎烨 on 2020/12/1.
//  Copyright © 2020 CDEL. All rights reserved.
//

#import "DLRequestDetailModel.h"

NS_ASSUME_NONNULL_BEGIN

@interface DLRequestDetailViewModel : NSObject

@property (nonatomic, strong) NSDictionary *info;

- (NSInteger)numberOfItems;
- (DLRequestDetailModel *)getRequestInfoItemAtIndexPath:(NSIndexPath *)indexPath;
- (CGFloat)heightForRowAtIndexPath:(NSIndexPath *)indexPath;

@end

NS_ASSUME_NONNULL_END
