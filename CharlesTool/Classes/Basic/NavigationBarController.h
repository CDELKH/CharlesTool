//
//  NavagationBarController.h
//  UIDemo
//
//  Created by cyx on 14-10-30.
//  Copyright (c) 2014年 CDEL. All rights reserved.
//

#import "NavigatonBarView.h"
#import <UIKit/UIKit.h>

@interface NavigationBarController : UIViewController
{
    NavigatonBarView *_navigationBarView;
}

@property (nonatomic, strong) NavigatonBarView *navigationBarView;

@property (nonatomic, strong) NSString *showTitle;

/**
 *  当前页面是否禁用ios7返回手势，默认不禁用
 */
@property (nonatomic, assign) BOOL closeInteractiveGesture;

/**
 *  当前页面是否禁用IQKeyboardManager，默认不禁用（一般禁用的话，还需要设置输入框的属性inputAccessoryView = [UIView new]）
 */
@property (nonatomic,assign) BOOL closeIQKeyboardManager;

- (void)nearByNavigationBarView:(UIView *)tView isShowBottom:(BOOL)bottom;

- (void)leftButtonClick;

- (void)rightButtonClick;

/// 旋转为竖屏
- (void)changeInterfaceOrientationToPorait;

@end
