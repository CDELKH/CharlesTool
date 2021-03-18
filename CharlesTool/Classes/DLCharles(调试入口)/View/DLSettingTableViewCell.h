//
//  DLSettingTableViewCell.h
//  AFNetworking
//
//  Created by 郎烨 on 2020/12/14.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface DLSettingTableViewCell : UITableViewCell

/**
 *  统一带有箭头cell的样式
 */
@property (nonatomic,strong) UIImageView *arrowImageView;

@property (nonatomic,strong)UILabel *contentLabel;
@property (nonatomic,strong)UISwitch *rightSwitch;
@property (nonatomic,strong)UIImageView *lineImageView;

@end

NS_ASSUME_NONNULL_END
