//
//  DLAlertShowAnimate.m
//  NetSchool
//
//  Created by SL on 2016/12/5.
//  Copyright © 2016年 CDEL. All rights reserved.
//

#import "DLAlertShowAnimate.h"
#import <Masonry/Masonry.h>
#import <ReactiveCocoa/ReactiveCocoa.h>
#import <ReactiveCocoa/RACEXTScope.h>

#define Animations_Time         .4

//typedef void (^OutsideDisappear)();
typedef void (^DisappearBlock)();

@interface DLAlertShowAnimate ()

/**
 黑色背景view
 */
@property (nonatomic, strong) UIView *dl_bgView;

/**
 背景button，用于点击view外部自动消失
 */
@property (nonatomic, strong) UIButton *dl_bgButton;

/**
 显示在dl_inView中
 */
@property (nonatomic, weak) UIView *dl_inView;

/**
 需要弹出的view
 */
@property (nonatomic, weak) UIView *dl_alertView;

/**
 弹出模式
 */
@property (nonatomic, assign) View_Popup_Mode dl_popupMode;

/**
 显示背景透明度
 */
@property (nonatomic, assign) CGFloat dl_bgAlpha;

/**
 点击消失block
 */
@property (nonatomic, copy) DisappearBlock disappearBlock;

@end

@implementation DLAlertShowAnimate

+ (instancetype)sharedInstance {
    static id _sharedInstance = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        _sharedInstance = [[self alloc] init];
    });
    return _sharedInstance;
}

- (instancetype)init {
    self = [super init];
    if (self) {
        UIView *bgView = [UIView new];
        [self addSubview:bgView];
        bgView.backgroundColor = [UIColor blackColor];
        bgView.alpha = 0;
        [bgView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.edges.mas_equalTo(0);
        }];
        self.dl_bgView = bgView;
        
        UIButton *bgButton = [UIButton buttonWithType:UIButtonTypeCustom];
        [self addSubview:bgButton];
        [bgButton mas_makeConstraints:^(MASConstraintMaker *make) {
            make.edges.mas_equalTo(0);
        }];
        @weakify(self);
        bgButton.rac_command = [[RACCommand alloc] initWithSignalBlock:^RACSignal *(id input) {
            @strongify(self);
            [self disappear];
            return [RACSignal empty];
        }];
        self.dl_bgButton = bgButton;
    }
    return self;
}

+ (void)showInView:(UIView *)inView
         alertView:(UIView *)alertView
         popupMode:(View_Popup_Mode)popupMode
           bgAlpha:(CGFloat)bgAlpha
  outsideDisappear:(BOOL)outsideDisappear {
    [[self sharedInstance] showInView:inView
                            alertView:alertView
                            popupMode:popupMode
                              bgAlpha:bgAlpha
                     outsideDisappear:outsideDisappear
                            disappear:nil];
}

+ (void)showInView:(UIView *)inView
         alertView:(UIView *)alertView
         popupMode:(View_Popup_Mode)popupMode
           bgAlpha:(CGFloat)bgAlpha
  outsideDisappear:(BOOL)outsideDisappear
         disappear:(void(^)())disappear {
    [[self sharedInstance] showInView:inView
                            alertView:alertView
                            popupMode:popupMode
                              bgAlpha:bgAlpha
                     outsideDisappear:outsideDisappear
                            disappear:disappear];
}

- (void)showInView:(UIView *)inView
         alertView:(UIView *)alertView
         popupMode:(View_Popup_Mode)popupMode
           bgAlpha:(CGFloat)bgAlpha
  outsideDisappear:(BOOL)outsideDisappear
         disappear:(void(^)())disappear {
    
    self.disappearBlock = disappear;
    
    CGFloat alertWidth = alertView.frame.size.width;
    CGFloat alertHeight = alertView.frame.size.height;
    
    if (self.dl_alertView) {
        [self.dl_alertView removeFromSuperview];
        self.dl_alertView = nil;
    }
    if (self.superview) {
        [self removeFromSuperview];
    }
    
    self.dl_inView = inView;
    self.dl_alertView = alertView;
    self.dl_popupMode = popupMode;
    self.dl_bgAlpha = bgAlpha;
    self.dl_bgButton.hidden = !outsideDisappear;
    
    inView.userInteractionEnabled = NO;
    [inView addSubview:self];
    [self mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.edges.mas_equalTo(0);
    }];
    
    [self addSubview:alertView];
    
    alertView.alpha = 0;
    self.dl_bgView.alpha = 0;
    
    if (popupMode == View_Popup_Mode_Center) {
        [alertView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.center.mas_equalTo(self);
            make.width.mas_equalTo(alertWidth);
            make.height.mas_equalTo(alertHeight);
        }];
        alertView.transform = CGAffineTransformScale(CGAffineTransformIdentity, 1.1, 1.1);
        
        [UIView animateWithDuration:Animations_Time animations:^{
            self.dl_bgView.alpha = bgAlpha;
            alertView.alpha = 1;
            alertView.transform = CGAffineTransformScale(CGAffineTransformIdentity, 1, 1);
        } completion:^(BOOL finished) {
            inView.userInteractionEnabled = YES;
        }];
    } else if (popupMode == View_Popup_Mode_Down) {
        [alertView mas_updateConstraints:^(MASConstraintMaker *make) {
            make.centerX.mas_equalTo(self.mas_centerX);
            make.width.mas_equalTo(alertWidth);
            make.height.mas_equalTo(alertHeight);
            make.bottom.mas_equalTo(self.mas_bottom).mas_equalTo(alertHeight);
        }];
        [self layoutIfNeeded];
        
        [UIView animateWithDuration:Animations_Time animations:^{
            self.dl_bgView.alpha = bgAlpha;
            alertView.alpha = 1;
            [alertView mas_updateConstraints:^(MASConstraintMaker *make) {
                make.bottom.mas_equalTo(0);
            }];
            [self layoutIfNeeded];
        } completion:^(BOOL finished) {
            inView.userInteractionEnabled = YES;
        }];
    } else if (popupMode == View_Popup_Mode_Left) {
        [alertView mas_updateConstraints:^(MASConstraintMaker *make) {
            make.centerY.mas_equalTo(self.mas_centerY);
            make.width.mas_equalTo(alertWidth);
            make.height.mas_equalTo(alertHeight);
            make.left.mas_equalTo(self.mas_left).mas_equalTo(-alertWidth);
        }];
        [self layoutIfNeeded];
        
        [UIView animateWithDuration:Animations_Time animations:^{
            self.dl_bgView.alpha = bgAlpha;
            alertView.alpha = 1;
            [alertView mas_updateConstraints:^(MASConstraintMaker *make) {
                make.left.mas_equalTo(0);
            }];
            [self layoutIfNeeded];
        } completion:^(BOOL finished) {
            inView.userInteractionEnabled = YES;
        }];
    } else if (popupMode == View_Popup_Mode_Right) {
        [alertView mas_updateConstraints:^(MASConstraintMaker *make) {
            make.centerY.mas_equalTo(self.mas_centerY);
            make.width.mas_equalTo(alertWidth);
            make.height.mas_equalTo(alertHeight);
            make.right.mas_equalTo(self.mas_right).mas_equalTo(alertWidth);
        }];
        [self layoutIfNeeded];
        
        [UIView animateWithDuration:Animations_Time animations:^{
            self.dl_bgView.alpha = bgAlpha;
            alertView.alpha = 1;
            [alertView mas_updateConstraints:^(MASConstraintMaker *make) {
                make.right.mas_equalTo(0);
            }];
            [self layoutIfNeeded];
        } completion:^(BOOL finished) {
            inView.userInteractionEnabled = YES;
        }];
    }else if (popupMode == View_Popup_Mode_Top) {
        [alertView mas_updateConstraints:^(MASConstraintMaker *make) {
            make.centerX.mas_equalTo(self.mas_centerX);
            make.width.mas_equalTo(alertWidth);
            make.height.mas_equalTo(alertHeight);
            make.top.mas_equalTo(self.mas_top).mas_equalTo(-alertHeight);
        }];
        [self layoutIfNeeded];
        
        [UIView animateWithDuration:Animations_Time animations:^{
            self.dl_bgView.alpha = bgAlpha;
            alertView.alpha = 1;
            [alertView mas_updateConstraints:^(MASConstraintMaker *make) {
                make.top.mas_equalTo(0);
            }];
            [self layoutIfNeeded];
        } completion:^(BOOL finished) {
            inView.userInteractionEnabled = YES;
        }];
    }
}

+ (void)disappear {
    [[self sharedInstance] disappear];
}

- (void)disappear {
    self.dl_inView.userInteractionEnabled = NO;
    if (self.dl_popupMode == View_Popup_Mode_Center) {
        [UIView animateWithDuration:Animations_Time animations:^{
            self.dl_alertView.transform = CGAffineTransformScale(CGAffineTransformIdentity, .5, .5);
            self.dl_alertView.alpha = 0;
            self.dl_bgView.alpha = 0;
        } completion:^(BOOL s){
            [self completion];
        }];
    } else if (self.dl_popupMode == View_Popup_Mode_Down) {
        [UIView animateWithDuration:Animations_Time animations:^{
            self.dl_alertView.alpha = 0;
            self.dl_bgView.alpha = 0;
            [self.dl_alertView mas_updateConstraints:^(MASConstraintMaker *make) {
                make.bottom.mas_equalTo(self.mas_bottom).mas_equalTo(self.dl_alertView.frame.size.height);
            }];
            [self layoutIfNeeded];
        } completion:^(BOOL s){
            [self completion];
        }];
    } else if (self.dl_popupMode == View_Popup_Mode_Left) {
        [UIView animateWithDuration:Animations_Time animations:^{
            self.dl_alertView.alpha = 0;
            self.dl_bgView.alpha = 0;
            [self.dl_alertView mas_updateConstraints:^(MASConstraintMaker *make) {
                make.left.mas_equalTo(self.mas_left).mas_equalTo(-self.dl_alertView.frame.size.width);
            }];
            [self layoutIfNeeded];
        } completion:^(BOOL s){
            [self completion];
        }];
    } else if (self.dl_popupMode == View_Popup_Mode_Right) {
        [UIView animateWithDuration:Animations_Time animations:^{
            self.dl_alertView.alpha = 0;
            self.dl_bgView.alpha = 0;
            [self.dl_alertView mas_updateConstraints:^(MASConstraintMaker *make) {
                make.right.mas_equalTo(self.mas_right).mas_equalTo(self.dl_alertView.frame.size.width);
            }];
            [self layoutIfNeeded];
        } completion:^(BOOL s){
            [self completion];
        }];
    }else if (self.dl_popupMode == View_Popup_Mode_Top) {
        [UIView animateWithDuration:Animations_Time animations:^{
            self.dl_alertView.alpha = 0;
            self.dl_bgView.alpha = 0;
            [self.dl_alertView mas_updateConstraints:^(MASConstraintMaker *make) {
                make.top.mas_equalTo(self.mas_top).mas_equalTo(-self.dl_alertView.frame.size.height);
            }];
            [self layoutIfNeeded];
        } completion:^(BOOL s){
            [self completion];
        }];
    }
}

- (void)disappearComplete:(dispatch_block_t)close {
    if (close) {
        self.disappearBlock = close;
    }
    [self disappear];
}

- (void)completion {
    [self.dl_alertView removeFromSuperview];
    self.dl_alertView = nil;
    [self removeFromSuperview];
    self.dl_inView.userInteractionEnabled = YES;
    if (self.disappearBlock) {
        self.disappearBlock();
        self.disappearBlock = nil;
    }
}

+ (BOOL)showAlert {
    return [DLAlertShowAnimate sharedInstance].dl_alertView != nil;
}

- (void)changePopupMode:(View_Popup_Mode)popupMode{
    self.dl_popupMode = popupMode;
}

@end
