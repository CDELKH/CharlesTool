//
//  DLSettingTableViewCell.m
//  AFNetworking
//
//  Created by 郎烨 on 2020/12/14.
//

#import "DLSettingTableViewCell.h"
#import "CommUtls.h"

@implementation DLSettingTableViewCell

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        [self creatCellUI];
        [self dealLayout];
    }
    return self;
}

- (void)creatCellUI {
    self.arrowImageView =[UIImageView new];
    [_arrowImageView setImage:[UIImage imageNamed:@"list_btn_into"]];
    [_arrowImageView sizeToFit];
    [self.contentView addSubview:_arrowImageView];
    
    CGFloat arrowWidth = _arrowImageView.frame.size.width;
    CGFloat arrowHeight = _arrowImageView.frame.size.height;
    
    @weakify(self);
    [_arrowImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        @strongify(self);
        make.right.equalTo(self.contentView.mas_right).offset(-14);
        make.centerY.equalTo(self.contentView.mas_centerY);
        make.width.mas_equalTo(arrowWidth);
        make.height.mas_equalTo(arrowHeight);
    }];
    
    self.contentLabel = [[UILabel alloc]init];
    self.contentLabel.backgroundColor = [UIColor clearColor];
    self.contentLabel.font = [UIFont systemFontOfSize:16];
    self.contentLabel.textColor = [CommUtls colorWithHexString:@"#222222"];
    self.contentLabel.numberOfLines = 0;
    self.contentLabel.lineBreakMode = NSLineBreakByWordWrapping;
    [self addSubview:self.contentLabel];
    
    self.lineImageView = [[UIImageView alloc]init];
    self.lineImageView.backgroundColor = [CommUtls colorWithHexString:@"#f0f0f0"];
    [self addSubview:self.lineImageView];
    
    self.rightSwitch = [[UISwitch alloc]init];
    [self addSubview:self.rightSwitch];
}

- (void)dealLayout {
    
    [self.contentLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.mas_equalTo(self);
        make.left.mas_equalTo(self.mas_left).offset(15);
        make.right.mas_equalTo(self.mas_centerX).offset(20);
    }];
    
    [self.lineImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self.mas_bottom).offset(-1);
        make.left.mas_equalTo(self.mas_left);
        make.right.mas_equalTo(self.mas_right);
        make.height.mas_equalTo(1);
    }];

    CGFloat right = -20;
    [self.rightSwitch mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.mas_equalTo(self.mas_centerY);
        make.right.mas_equalTo(self.mas_right).offset(right);
        make.width.mas_equalTo(40);
        make.height.mas_equalTo(30);
    }];
}

@end
