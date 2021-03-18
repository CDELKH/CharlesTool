//
//  DLAddEnvironmentalInputView.m
//  NetSchool
//
//  Created by 郎烨 on 2020/12/2.
//  Copyright © 2020 CDEL. All rights reserved.
//

#import "DLAddEnvironmentalInputView.h"
#import "DLAlertShowAnimate.h"
#import "CommUtls.h"

@interface DLAddEnvironmentalInputView ()

@property (nonatomic, strong) UITextField *environmentTextField;
@property (nonatomic, copy) void(^confirmBlock)(RACTuple *inputTuple);
@property (nonatomic, copy) void(^cancelBlock)(void);

@end

@implementation DLAddEnvironmentalInputView

- (instancetype)initWithFrame:(CGRect)frame{
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor = [UIColor whiteColor];
        [self addViews];
    }
    return self;
}

- (void)addViews{
    UILabel *domainTip = [[UILabel alloc] init];
    domainTip.text = @"输入环境";
    [self addSubview:domainTip];
    [domainTip mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self);
        make.top.equalTo(self).offset(15);
        make.height.mas_equalTo(40);
    }];
    
    UITextField *environmentTextField = [[UITextField alloc] init];
    environmentTextField.backgroundColor = [CommUtls colorWithHexString:@"eeeeee"];
    environmentTextField.keyboardType = UIKeyboardTypeURL;
    [self addSubview:environmentTextField];
    [environmentTextField mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self);
        make.top.mas_equalTo(domainTip.mas_bottom).offset(8);
        make.height.mas_equalTo(35);
        make.left.equalTo(self).offset(15);
        make.right.equalTo(self).offset(-15);
    }];
    self.environmentTextField = environmentTextField;
    
    @weakify(self)
    UIButton *confirmButton = [[UIButton alloc] init];
    [confirmButton setTitle:@"确认" forState:UIControlStateNormal];
    [confirmButton setTitleColor:[CommUtls colorWithHexString:@"#249ff6"] forState:UIControlStateNormal];
    [[confirmButton rac_signalForControlEvents:UIControlEventTouchUpInside] subscribeNext:^(id x) {
        @strongify(self)
        [self checkInput];
        [self dismiss];
    }];
    [self addSubview:confirmButton];
    [confirmButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.bottom.equalTo(self);
        make.top.equalTo(environmentTextField.mas_bottom);
        make.width.equalTo(self.mas_width).dividedBy(2);
    }];
    
    UIButton *cancelButton = [[UIButton alloc] init];
    [cancelButton setTitle:@"取消" forState:UIControlStateNormal];
    [cancelButton setTitleColor:[UIColor grayColor] forState:UIControlStateNormal];
    [[cancelButton rac_signalForControlEvents:UIControlEventTouchUpInside] subscribeNext:^(id x) {
        @strongify(self)
        if (self.cancelBlock) {
            self.cancelBlock();
        }
        [self dismiss];
    }];
    [self addSubview:cancelButton];
    [cancelButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.bottom.equalTo(self);
        make.top.equalTo(environmentTextField.mas_bottom);
        make.width.equalTo(self.mas_width).dividedBy(2);
    }];
}

- (void)checkInput{
    if (self.confirmBlock) {
        self.confirmBlock(RACTuplePack(self.environmentTextField.text));
    }
}

#pragma mark - show dismiss
- (void)dismiss{
    [DLAlertShowAnimate disappear];
    self.environmentTextField.text = @"";
    [self.environmentTextField resignFirstResponder];
}

- (void)showWithConfirmBlock:(nullable void(^)(RACTuple *inputTuple))confirmBlock //会发送域名和ip的元组
                 cancelBlock:(nullable void(^)(void))cancelBlock {
    self.confirmBlock = confirmBlock;
    self.cancelBlock = cancelBlock;
    
    [DLAlertShowAnimate showInView:[CommUtls getCurrentVC].view alertView:self popupMode:View_Popup_Mode_Center bgAlpha:.5 outsideDisappear:NO disappear:^{
    }];
    [self.environmentTextField becomeFirstResponder];
}

- (void)showWithDomain:(NSString *)domain
          confirmBlock:(nullable void(^)(RACTuple *inputTuple))confirmBlock
           cancelBlock:(nullable void(^)(void))cancelBlock {
    self.environmentTextField.text = domain;
    [self showWithConfirmBlock:confirmBlock cancelBlock:cancelBlock];
}

@end
