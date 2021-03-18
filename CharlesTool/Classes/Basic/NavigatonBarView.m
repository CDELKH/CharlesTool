//
//  NavigatonBarView.m
//  forum
//
//  Created by cyx on 12-7-26.
//  Copyright (c) 2012年 cdeledu. All rights reserved.
//

#import "NavigatonBarView.h"
#import "DLBaseMacro.h"

const float const_navigation_hight = 64.0;
const float navigationbar_title_width = 200.0;
const float navigationbar_button_width = 60;
const float navigationbar_interval = 0;
const float navigationbar_font = 14.0;


@interface NavigatonBarView()
{
    UILabel * _titleLabel;
    UIButton *_leftButton;
    UIButton *_rightButton;
    UIImageView *_backGroundImgeView;
    UILabel *_rightLabel;
    UILabel *_leftLabel;
    UIImage *leftButtonImageNormarl;
    UIImage *leftButtonImageHighlight;
    UIImage *rightButtonImageNormarl;
    UIImage *rightButtonImageHighlight;
}
@end

@implementation NavigatonBarView


- (id)initLeftButtonPicNormal:(UIImage *)leftImageNormal
       leftButtonPicHighlight:(UIImage *)leftImageHighlight
         rightButtonPicNormal:(UIImage *)rightImageNormal
      rightButtonPicHighlight:(UIImage *)rightImageHighlight
                    fontColor:(UIColor *)color
{
    self = [super init];
    if (self) {
        self.backgroundColor = [UIColor whiteColor];
        
        leftButtonImageNormarl = leftImageNormal;
        leftButtonImageHighlight = leftImageHighlight;
        rightButtonImageNormarl = rightImageNormal;
        rightButtonImageHighlight = rightImageHighlight;
        
        _backGroundImgeView = [[UIImageView alloc]init];
        [_backGroundImgeView setTranslatesAutoresizingMaskIntoConstraints:NO];
        
        _titleLabel = [[UILabel alloc] init];
        _titleLabel.backgroundColor = [UIColor clearColor];
        _titleLabel.font = [UIFont boldSystemFontOfSize:navigationbar_font];
        _titleLabel.textColor = color;
        [_titleLabel setTranslatesAutoresizingMaskIntoConstraints:NO];
        
        _leftButton = [[UIButton alloc]init];
        _leftButton.backgroundColor = [UIColor clearColor];
        [_leftButton addTarget:self action:@selector(navigationLeftButtonClick) forControlEvents:UIControlEventTouchUpInside];
        [_leftButton setTranslatesAutoresizingMaskIntoConstraints:NO];
        
        _rightButton = [[UIButton alloc]init];
        _rightButton.backgroundColor=[UIColor clearColor];
        [_rightButton addTarget:self action:@selector(navigationRightButtonClick) forControlEvents:UIControlEventTouchUpInside];
        [_rightButton setTranslatesAutoresizingMaskIntoConstraints:NO];
        
        _leftLabel=[[UILabel alloc]init];
        _leftLabel.backgroundColor = [UIColor clearColor];
        _leftLabel.textAlignment = NSTextAlignmentCenter;
        _leftLabel.font = [UIFont boldSystemFontOfSize:navigationbar_font];
        _leftLabel.textColor = color;
        [_leftLabel setTranslatesAutoresizingMaskIntoConstraints:NO];
        
        _rightLabel = [[UILabel alloc]init];
        _rightLabel.backgroundColor = [UIColor clearColor];
        _rightLabel.textAlignment = NSTextAlignmentCenter;
        _rightLabel.font = [UIFont boldSystemFontOfSize:navigationbar_font];
        _rightLabel.textColor = color;
        [_rightLabel setTranslatesAutoresizingMaskIntoConstraints:NO];
        
        [self addSubview:_backGroundImgeView];
        [self addSubview:_titleLabel];
        [self addSubview:_leftButton];
        [self addSubview:_rightButton];
        [self addSubview:_rightLabel];
        [self addSubview:_leftLabel];
        
        [_backGroundImgeView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.bottom.left.right.mas_equalTo(0);
        }];
        
        NSInteger top = 20;
        if (iPhoneX) {
            top = 44;
        }

        [_leftLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.mas_equalTo(top);
            make.width.mas_equalTo(60);
            make.left.mas_equalTo(0);
            make.bottom.mas_equalTo(0);
        }];
        
        [_leftButton mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.mas_equalTo(top);
            make.width.mas_equalTo(60);
            make.left.mas_equalTo(0);
            make.bottom.mas_equalTo(0);
        }];
        
        [_rightLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.mas_equalTo(top);
            make.width.mas_equalTo(60);
            make.right.mas_equalTo(0);
            make.bottom.mas_equalTo(0);
        }];
        
        [_rightButton mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.mas_equalTo(top);
            make.width.mas_equalTo(60);
            make.right.mas_equalTo(0);
            make.bottom.mas_equalTo(0);
        }];
        
        [_titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.mas_equalTo(top);
            make.right.mas_equalTo(_rightButton.mas_left).offset(-10);
            make.left.mas_equalTo(_leftButton.mas_right).offset(10);
            make.bottom.mas_equalTo(0);            
        }];
        
    }
    return self;
}



- (void)navigationLeftButtonClick
{
    if([_delegate respondsToSelector:@selector(leftButtonClick)])
        [_delegate leftButtonClick];
}

- (void)navigationRightButtonClick
{
    if([_delegate respondsToSelector:@selector(rightButtonClick)])
        [_delegate rightButtonClick];
}



- (void)setNavagationBarStyle:(NavigationBarStyle)navagationBarStyle
{
    switch (navagationBarStyle) {
        case None_button_show:
        {
            [_leftButton setHidden:YES];
            [_rightButton setHidden:YES];
            
            [_leftLabel setHidden:YES];
            [_rightLabel setHidden:YES];
            
        }
            break;
        case Left_right_button_show:
        {
            [_leftButton setHidden:NO];
            [_rightButton setHidden:NO];
            [_leftLabel setHidden:NO];
            [_rightLabel setHidden:NO];
            
            [_leftButton setImage:leftButtonImageNormarl forState:UIControlStateNormal];
            [_leftButton setImage:leftButtonImageHighlight forState:UIControlStateHighlighted];
            [_rightButton setImage:rightButtonImageNormarl forState:UIControlStateNormal];
            [_rightButton setImage:rightButtonImageHighlight forState:UIControlStateHighlighted];
        }
            break;
        case Left_button_Show:
        {
            [_rightButton setHidden:YES];
            [_leftButton setHidden:NO];
            [_rightLabel setHidden:YES];
            [_leftLabel setHidden:NO];
            
            [_leftButton setImage:leftButtonImageNormarl forState:UIControlStateNormal];
            [_leftButton setImage:leftButtonImageHighlight forState:UIControlStateHighlighted];
        }
            break;
        case Right_button_show:
        {
            [_leftButton setHidden:YES];
            [_rightButton setHidden:NO];
            [_leftLabel setHidden:YES];
            [_rightLabel setHidden:NO];
            
            
            [_rightButton setImage:rightButtonImageNormarl forState:UIControlStateNormal];
            [_rightButton setImage:rightButtonImageHighlight forState:UIControlStateHighlighted];
        }
            break;
        default:
            break;
    }
}


@end
