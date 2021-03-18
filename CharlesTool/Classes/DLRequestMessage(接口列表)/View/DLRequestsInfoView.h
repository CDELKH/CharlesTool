//
//  DLRequestsInfoView.h
//  NetSchool
//
//  Created by konghui on 2020/11/10.
//  Copyright © 2020 CDEL. All rights reserved.
//

#import <UIKit/UIKit.h>
@class DLRequestsInfoViewModel;

NS_ASSUME_NONNULL_BEGIN

@interface DLRequestsInfoView : UIView

- (instancetype)initWithViewModel:(DLRequestsInfoViewModel *)viewModel;

@end

NS_ASSUME_NONNULL_END
