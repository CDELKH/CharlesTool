//
//  DLDebugEntranceView.m
//  NetSchool
//
//  Created by 郎烨 on 2020/12/7.
//  Copyright © 2020 CDEL. All rights reserved.
//

#import "DLDebugEntranceView.h"
#import "DLDebugSetViewController.h"
#import "DLProxySettingViewModel.h"
#import "CommUtls.h"
#import <ReactiveCocoa/RACEXTScope.h>

@interface DLDebugEntranceView()

@property (nonatomic, strong) UIButton *enterButton;

@end

@implementation DLDebugEntranceView

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        
        UIButton *enterButton = [UIButton new];
        enterButton.userInteractionEnabled = false;
        enterButton.backgroundColor = [CommUtls colorWithHexString:@"#4bb9ff"];
        enterButton.layer.cornerRadius = 50 / 2.;
        enterButton.titleLabel.numberOfLines = 3;
        enterButton.titleLabel.font = [UIFont systemFontOfSize:12];
        enterButton.titleLabel.adjustsFontSizeToFitWidth = YES;
        enterButton.titleLabel.textAlignment = NSTextAlignmentCenter;
        [enterButton.titleLabel sizeToFit];
        [enterButton setTitleColor:[CommUtls colorWithHexString:@"#777777"] forState:UIControlStateNormal];
        [self addSubview:enterButton];
        [enterButton mas_makeConstraints:^(MASConstraintMaker *make) {
            make.bottom.left.equalTo(self);
            make.width.height.mas_equalTo(50);
        }];
        self.enterButton = enterButton;
        
        UIButton *closeButton = [UIButton new];
        [closeButton setTitle:@"×" forState:UIControlStateNormal];
        [closeButton setTitleColor:UIColor.blackColor forState:UIControlStateNormal];
        closeButton.titleLabel.font = [UIFont systemFontOfSize:20];
        [self addSubview:closeButton];
        [closeButton mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(self).offset(5);
            make.right.equalTo(self).offset(-5);
            make.width.height.mas_equalTo(30);
        }];
        
        @weakify(self)
        [[closeButton rac_signalForControlEvents:UIControlEventTouchUpInside] subscribeNext:^(id x) {
            @strongify(self)
            self.hidden = YES;
        }];
        
        // 单击的 Recognizer
        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(singleTapToDo:)];
        [self addGestureRecognizer:tap];
        
        [self changeDebutonViewTitle:[DLProxySettingViewModel getCurrentNetworkEnvironment]];
    }
    return self;
}

- (void)singleTapToDo:(UITapGestureRecognizer *)sender {
    DLDebugSetViewController *hiddenVC = [DLDebugSetViewController new];
    hiddenVC.hidesBottomBarWhenPushed = YES;
    [[CommUtls getCurrentVC].navigationController pushViewController:hiddenVC animated:YES];
}

- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event {
    UITouch *touch = [touches anyObject];
    beginPoint = [touch locationInView:self];
}

- (void)touchesMoved:(NSSet *)touches withEvent:(UIEvent *)event {
    UITouch *touch = [touches anyObject];
    CGPoint nowPoint = [touch locationInView:self];
    float offsetX = nowPoint.x - beginPoint.x;
    float offsetY = nowPoint.y - beginPoint.y;
    self.center = CGPointMake(self.center.x + offsetX, self.center.y + offsetY);
}

// 切换选择的环境名字
- (void)changeDebutonViewTitle:(NSString *)string {
    [self.enterButton setTitle:string.length == 0 ? @"初始\n环境" : string forState:UIControlStateNormal];
}

@end
