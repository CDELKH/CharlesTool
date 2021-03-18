//
//  DLAlertShowAnimate.h
//  NetSchool
//
//  Created by SL on 2016/12/5.
//  Copyright © 2016年 CDEL. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef NS_ENUM(NSInteger,View_Popup_Mode) {
    View_Popup_Mode_Center = 0,
    View_Popup_Mode_Down,
    View_Popup_Mode_Left,
    View_Popup_Mode_Right,
    View_Popup_Mode_Top,
};

@interface DLAlertShowAnimate : UIView

+ (instancetype)sharedInstance;

/**
 显示在inView中心的alertView

 @param inView 显示在inview上
 @param alertView 显示的view，需要设置此view的frame值
 @param popupMode 弹出方式
 @param bgAlpha 多余背景透明度
 @param outsideDisappear 点击外围是否自动消失
 */
+ (void)showInView:(UIView *)inView
         alertView:(UIView *)alertView
         popupMode:(View_Popup_Mode)popupMode
           bgAlpha:(CGFloat)bgAlpha
  outsideDisappear:(BOOL)outsideDisappear;

/**
 显示在inView中心的alertView，增加disappear的回调

 @param inView 显示在inview上
 @param alertView 显示的view，需要设置此view的frame值
 @param popupMode 弹出方式
 @param bgAlpha 多余背景透明度
 @param outsideDisappear 点击外围是否自动消失
 @param disappear disappear的回调
 */
+ (void)showInView:(UIView *)inView
         alertView:(UIView *)alertView
         popupMode:(View_Popup_Mode)popupMode
           bgAlpha:(CGFloat)bgAlpha
  outsideDisappear:(BOOL)outsideDisappear
         disappear:(void(^)())disappear;

/**
 显示在inView中心的alertView，增加disappear的回调
 
 @param inView 显示在inview上
 @param alertView 显示的view，需要设置此view的frame值
 @param popupMode 弹出方式
 @param bgAlpha 多余背景透明度
 @param outsideDisappear 点击外围是否自动消失
 @param disappear disappear的回调
 */
- (void)showInView:(UIView *)inView
         alertView:(UIView *)alertView
         popupMode:(View_Popup_Mode)popupMode
           bgAlpha:(CGFloat)bgAlpha
  outsideDisappear:(BOOL)outsideDisappear
         disappear:(void(^)())disappear;

/**
 弹出框直接消失
 */
+ (void)disappear;
- (void)disappear;
- (void)disappearComplete:(dispatch_block_t)close;

/// 是否显示弹窗
+ (BOOL)showAlert;

/// 外部改变弹出方式
/// @param popupMode <#popupMode description#>
- (void)changePopupMode:(View_Popup_Mode)popupMode;

@end
