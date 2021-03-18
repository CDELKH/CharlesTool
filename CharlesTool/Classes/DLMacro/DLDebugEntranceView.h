//
//  DLDebugEntranceView.h
//  NetSchool
//
//  Created by 郎烨 on 2020/12/7.
//  Copyright © 2020 CDEL. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface DLDebugEntranceView : UIView

{
    CGPoint beginPoint;
}

// 显示选择的环境
- (void)changeDebutonViewTitle:(NSString *)string;

@end

NS_ASSUME_NONNULL_END
