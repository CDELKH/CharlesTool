//
//  DLRequestsDetailView.h
//  NetSchool
//
//  Created by 郎烨 on 2020/12/1.
//  Copyright © 2020 CDEL. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "DLRequestDetailViewModel.h"

NS_ASSUME_NONNULL_BEGIN

@interface DLRequestsDetailView : UIView

- (instancetype)initWithViewModel:(DLRequestDetailViewModel *)viewModel;

@end

NS_ASSUME_NONNULL_END
