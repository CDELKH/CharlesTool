//
//  DLAddEnvironmentalInputView.h
//  NetSchool
//
//  Created by 郎烨 on 2020/12/2.
//  Copyright © 2020 CDEL. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface DLAddEnvironmentalInputView : UIView

- (void)showWithConfirmBlock:(nullable void(^)(RACTuple *inputTuple))confirmBlock
                 cancelBlock:(nullable void(^)(void))cancelBlock;
- (void)showWithDomain:(NSString *)domain
          confirmBlock:(nullable void(^)(RACTuple *inputTuple))confirmBlock
           cancelBlock:(nullable void(^)(void))cancelBlock;
- (void)dismiss;

@end

NS_ASSUME_NONNULL_END
