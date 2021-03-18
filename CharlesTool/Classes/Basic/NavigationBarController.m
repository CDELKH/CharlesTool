//
//  NavagationBarController.m
//  UIDemo
//
//  Created by cyx on 14-10-30.
//  Copyright (c) 2014年 cyx. All rights reserved.
//

#import "NavigationBarController.h"
#import "CommUtls.h"
#import "DLBaseMacro.h"

@interface NavigationBarController ()<NavigatonBarViewDelegate>

@end

@implementation NavigationBarController

- (void)viewDidLoad
{
    [super viewDidLoad];    
    
    self.view.backgroundColor = [UIColor whiteColor];
    
    _navigationBarView = [[NavigatonBarView alloc]initLeftButtonPicNormal:[UIImage imageNamed:@"nav_btn_back_n.png"] leftButtonPicHighlight:[UIImage imageNamed:@"nav_btn_back_p.png"] rightButtonPicNormal:[UIImage imageNamed:@""] rightButtonPicHighlight:[UIImage imageNamed:@""] fontColor:[UIColor blackColor]];
//    _navigationBarView.leftButton.contentEdgeInsets = UIEdgeInsetsMake(0, 15, 0, 35);
    // 字色
    UIColor *navBtnColor = [UIColor blackColor];
    [_navigationBarView.rightButton setTitleColor:navBtnColor
                                         forState:UIControlStateNormal];
    [_navigationBarView.rightButton setTitleColor:[navBtnColor colorWithAlphaComponent:.4] forState:UIControlStateHighlighted];
    [_navigationBarView.leftButton setTitleColor:navBtnColor
                                         forState:UIControlStateNormal];
    _navigationBarView.leftLabel.textColor = navBtnColor;
    _navigationBarView.rightLabel.textColor = navBtnColor;
    
    _navigationBarView.backGroundImgeView.image = nil;
     _navigationBarView.backgroundColor = [UIColor whiteColor];
    if([self.navigationController.topViewController isKindOfClass:self.class]&&self.navigationController.viewControllers.count == 1)
        _navigationBarView.navagationBarStyle = None_button_show;
    else
        _navigationBarView.navagationBarStyle = Left_button_Show;
    if (self.showTitle) {
        _navigationBarView.titleLabel.text = self.showTitle;
    }
    // 字号
    _navigationBarView.titleLabel.font = [UIFont boldSystemFontOfSize:18];    [_navigationBarView.rightButton.titleLabel setFont:[UIFont systemFontOfSize:16]];
    _navigationBarView.titleLabel.textAlignment = NSTextAlignmentCenter;
    _navigationBarView.rightButton.titleLabel.adjustsFontSizeToFitWidth = YES;
    [_navigationBarView.leftButton.titleLabel setFont:[UIFont systemFontOfSize:16]];
    _navigationBarView.leftButton.titleLabel.adjustsFontSizeToFitWidth = YES;
    _navigationBarView.leftLabel.font = [UIFont systemFontOfSize:16];
    _navigationBarView.leftLabel.adjustsFontSizeToFitWidth = YES;
    _navigationBarView.rightLabel.font = [UIFont systemFontOfSize:16];
    _navigationBarView.rightLabel.adjustsFontSizeToFitWidth = YES;
    _navigationBarView.delegate = self;
    [self.view addSubview:_navigationBarView];
    
    [self dealRightButtonControlEvent];
    
    [_navigationBarView makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(0);
        make.left.mas_equalTo(0);
        make.right.mas_equalTo(0);
        make.height.mas_equalTo(NAVIGATIONBAR_HEIGHT);
    }];
    // 添加底部阴影
    UIView *bottomLineView = [UIView new];
    bottomLineView.backgroundColor = [UIColor whiteColor];
    bottomLineView.layer.shadowColor = [UIColor blackColor].CGColor;
    bottomLineView.layer.shadowOffset = CGSizeMake(0,-1);
    bottomLineView.layer.shadowOpacity = 0.05;
    bottomLineView.layer.shadowRadius = 1;
    [self.navigationBarView addSubview:bottomLineView];
    [bottomLineView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.bottom.mas_equalTo(0);
        make.height.mas_equalTo(1);
    }];
}

- (void)nearByNavigationBarView:(UIView *)tView isShowBottom:(BOOL)bottom
{
    [tView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(_navigationBarView.mas_bottom);
        make.left.mas_equalTo(0);
        make.right.mas_equalTo(0);
        make.bottom.mas_equalTo(self.view.mas_bottom);
    }];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}

- (void)leftButtonClick
{
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)rightButtonClick
{
}

#pragma mark -处理右侧按钮的UIControlEventTouchXXX事件

- (void)dealRightButtonControlEvent{
    [_navigationBarView.rightButton addTarget:self action:@selector(rightButtonTouchDown) forControlEvents:UIControlEventTouchDown];
    [_navigationBarView.rightButton addTarget:self action:@selector(rightButtonTouchDownRepeat) forControlEvents:UIControlEventTouchDownRepeat];
    [_navigationBarView.rightButton addTarget:self action:@selector(rightButtonTouchUpInside) forControlEvents:UIControlEventTouchUpInside];
    [_navigationBarView.rightButton addTarget:self action:@selector(rightButtonTouchUpOutside) forControlEvents:UIControlEventTouchUpOutside];
    [_navigationBarView.rightButton addTarget:self action:@selector(rightButtonTouchCancel) forControlEvents:UIControlEventTouchCancel];
}

- (void)rightButtonTouchDown{
    [self.navigationBarView.rightLabel setTextColor:[[UIColor blackColor] colorWithAlphaComponent:.4]];
}

- (void)rightButtonTouchDownRepeat{
    [self.navigationBarView.rightLabel setTextColor:[[UIColor blackColor] colorWithAlphaComponent:.4]];
}

- (void)rightButtonTouchUpInside{
    [self.navigationBarView.rightLabel setTextColor:[UIColor blackColor]];
}

- (void)rightButtonTouchUpOutside{
    [self.navigationBarView.rightLabel setTextColor:[UIColor blackColor]];
}

- (void)rightButtonTouchCancel{
    [self.navigationBarView.rightLabel setTextColor:[UIColor blackColor]];
}

#pragma mark ----旋转成为竖屏----

- (void)changeInterfaceOrientationToPorait {
    if ([UIApplication sharedApplication].statusBarOrientation != UIInterfaceOrientationPortrait ||
        [UIApplication sharedApplication].statusBarOrientation != UIInterfaceOrientationPortraitUpsideDown) {
        SEL selector = NSSelectorFromString(@"setOrientation:");
        NSInvocation *invocation = [NSInvocation invocationWithMethodSignature:[UIDevice instanceMethodSignatureForSelector:selector]];
        [invocation setSelector:selector];
        [invocation setTarget:[UIDevice currentDevice]];
        int val = UIInterfaceOrientationPortrait;
        [invocation setArgument:&val atIndex:2];
        [invocation invoke];
    }
}

@end
