//
//  DLRequestsInfoCell.m
//  NetSchool
//
//  Created by konghui on 2020/11/10.
//  Copyright © 2020 CDEL. All rights reserved.
//

#import "DLRequestsInfoCell.h"
#import "DLDomainIPMapManager.h"
#import "DLRequestInfoUIMacro.h"

@interface DLRequestsInfoCell ()

@property (nonatomic, strong) UILabel *statusCodeLabel;
@property (nonatomic, strong) UILabel *domainLabel;
@property (nonatomic, strong) UILabel *urlLabel;
@property (nonatomic, strong) UILabel *timeLabel;

@end

@implementation DLRequestsInfoCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        [self addViews];
    }
    return self;
}

- (void)addViews{
    
    UILabel *statusCodeLabel = [[UILabel alloc] init];
    statusCodeLabel.numberOfLines = 2;
    statusCodeLabel.textAlignment = NSTextAlignmentCenter;
    statusCodeLabel.adjustsFontSizeToFitWidth = YES;
    [self.contentView addSubview:statusCodeLabel];
    [statusCodeLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(REQUEST_INFO_DEFAULT_SPACING);
        make.right.equalTo(0);
        make.width.mas_equalTo(REQUEST_INFO_STATUS_CODE_AREA_WIDTH);
    }];
    self.statusCodeLabel = statusCodeLabel;
    
    UILabel *domainLabel = [[UILabel alloc] init];
    domainLabel.font = [UIFont systemFontOfSize:15];
    [self.contentView addSubview:domainLabel];
    [domainLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.left.mas_equalTo(REQUEST_INFO_DEFAULT_SPACING);
        make.right.equalTo(statusCodeLabel.mas_left).offset(-REQUEST_INFO_DEFAULT_SPACING);
    }];
    self.domainLabel = domainLabel;
    
    UILabel *urlLabel = [[UILabel alloc] init];
    urlLabel.textColor = [UIColor orangeColor];
    urlLabel.font = [UIFont systemFontOfSize:15];
    urlLabel.numberOfLines = 1;
    [self.contentView addSubview:urlLabel];
    [urlLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(REQUEST_INFO_DEFAULT_SPACING);
        make.bottom.mas_equalTo(-REQUEST_INFO_DEFAULT_TOPSPACING);
        make.right.equalTo(statusCodeLabel.mas_left).offset(-REQUEST_INFO_DEFAULT_SPACING);
    }];
    self.urlLabel = urlLabel;
    
    UILabel *timeLabel = [[UILabel alloc] init];
    timeLabel.textAlignment = NSTextAlignmentCenter;
    timeLabel.adjustsFontSizeToFitWidth = YES;
    [self.contentView addSubview:timeLabel];
    [timeLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(0);
        make.bottom.mas_equalTo(-REQUEST_INFO_DEFAULT_TOPSPACING);
        make.width.mas_equalTo(REQUEST_INFO_STATUS_CODE_AREA_WIDTH);
    }];
    self.timeLabel = timeLabel;
}

- (void)setRequestInfo:(NSDictionary *)requestInfo{
    _requestInfo = requestInfo;
    
    NSString *statusCodeInfo = requestInfo[DL_CHARLES_REQUEST_INFO_KEY_STATUSCODE];
    NSString *timeInfo = requestInfo[DL_CHARLES_REQUEST_INFO_KEY_TIMESTATISTICS];
    NSString *statusInfo = [NSString stringWithFormat:@"%@\n%@ms",statusCodeInfo,timeInfo];
    self.statusCodeLabel.text = statusInfo;
    if (requestInfo[DL_CHARLES_REQUEST_INFO_KEY_DOMAINRUL] == nil) {
        self.domainLabel.numberOfLines = 3;
        self.domainLabel.text = requestInfo[DL_CHARLES_REQUEST_INFO_KEY_URL];
        self.urlLabel.text = @"";
    } else {
        self.domainLabel.numberOfLines = 2;
        NSString *doMainString = [NSString stringWithFormat:@"%@",requestInfo[DL_CHARLES_REQUEST_INFO_KEY_DOMAINRUL]];
        self.domainLabel.text = doMainString;
        self.urlLabel.text = requestInfo[DL_CHARLES_REQUEST_INFO_KEY_URL];
    }
    
    self.timeLabel.text = requestInfo[DL_CHARLES_REQUEST_INFO_KEY_STARTIME];
    
    if ([statusCodeInfo isEqualToString:DL_REQUESTSTATUSCODE_ERROR_INFO] || [statusCodeInfo containsString:@"4"] || [statusCodeInfo containsString:@"5"]) {
        self.statusCodeLabel.textColor = [UIColor redColor];
    }else if([statusCodeInfo containsString:@"2"]){
        self.statusCodeLabel.textColor = [UIColor greenColor];
    }else if ([statusCodeInfo containsString:@"3"]){
        self.statusCodeLabel.textColor = [UIColor purpleColor];
    }else{
        self.statusCodeLabel.textColor = [UIColor blackColor];
    }
}

@end
