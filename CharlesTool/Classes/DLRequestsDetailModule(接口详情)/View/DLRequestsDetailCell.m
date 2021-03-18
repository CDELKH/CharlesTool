//
//  DLRequestsDetailCell.m
//  NetSchool
//
//  Created by 郎烨 on 2020/12/1.
//  Copyright © 2020 CDEL. All rights reserved.
//

#import "DLRequestsDetailCell.h"
#import "DLRequestInfoUIMacro.h"
#import "DLRequestsDetailTextView.h"
#import "CommUtls.h"

@interface DLRequestsDetailCell ()
// 详情标题
@property (nonatomic, strong) UILabel *nameLabel;
// 详情内容
@property (nonatomic, strong) DLRequestsDetailTextView *detailTextView;

@end

@implementation DLRequestsDetailCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        [self addViews];
    }
    return self;
}

- (void)addViews{
    UILabel *nameLabel = [[UILabel alloc] init];
    nameLabel.textColor = [CommUtls colorWithHexString:@"#4bb9ff"];
    nameLabel.font = [UIFont systemFontOfSize:10];
    nameLabel.textAlignment = NSTextAlignmentCenter;
    nameLabel.adjustsFontSizeToFitWidth = YES;
    [self.contentView addSubview:nameLabel];
    [nameLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(REQUEST_INFO_DEFAULT_TOPSPACING);
        make.centerX.equalTo(self.contentView);
    }];
    self.nameLabel = nameLabel;
    
    DLRequestsDetailTextView *detailTextView = [DLRequestsDetailTextView new];
    [self.contentView addSubview:detailTextView];
    detailTextView.font = [UIFont systemFontOfSize:15];
    [detailTextView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.nameLabel.mas_bottom).offset(REQUEST_INFO_DEFAULT_TOPSPACING);
        make.left.mas_equalTo(REQUEST_INFO_DEFAULT_SPACING);
        make.bottom.right.mas_equalTo(-REQUEST_INFO_DEFAULT_SPACING);
    }];
    detailTextView.scrollEnabled = NO;
    detailTextView.editable = NO;
    self.detailTextView = detailTextView;
}

- (void)setDetailModel:(DLRequestDetailModel *)detailModel {
    self.nameLabel.text = detailModel.title;
    self.detailTextView.text = detailModel.detailContent;
}

@end
