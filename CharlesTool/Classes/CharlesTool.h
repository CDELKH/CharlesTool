//
//  CharlesTool.h
//  NetSchool
//
//  Created by 郎烨 on 2020/12/8.
//  Copyright © 2020 CDEL. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface CharlesTool : NSObject

// 单利创建对象
+ (instancetype)sharedInstance;

// 是否开启默认调试
+ (void)isTurnOnDefaultDebugging:(BOOL)isDefault;

// 跳转调试开关控制器
+ (void)debugSetViewControllerController;

// 是否展示debugView
+ (void)isShowDebugView:(BOOL)isShow;

// 改变选择的环境的名字
- (void)changeDebutonViewTitle:(NSString *)string;

@end

NS_ASSUME_NONNULL_END
