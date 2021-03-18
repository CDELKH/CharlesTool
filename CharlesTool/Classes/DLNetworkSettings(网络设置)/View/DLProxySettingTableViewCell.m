//
//  DLProxySettingTableViewCell.m
//  NetSchool
//
//  Created by 郎烨 on 2020/12/2.
//  Copyright © 2020 CDEL. All rights reserved.
//

#import "DLProxySettingTableViewCell.h"

@implementation DLProxySettingTableViewCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        [self addViews];
    }
    return self;
}

- (void)addViews {
    UIButton *chooseButton = [[UIButton alloc] init];
    chooseButton.backgroundColor = UIColor.clearColor;
    [self.contentView addSubview:chooseButton];
    [chooseButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.top.bottom.equalTo(self.contentView);
        make.width.mas_equalTo(80);
    }];
    self.chooseButton = chooseButton;
}

@end
