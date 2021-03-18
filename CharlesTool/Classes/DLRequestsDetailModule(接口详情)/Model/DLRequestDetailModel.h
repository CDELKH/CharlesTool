//
//  DLRequestDetailModel.h
//  NetSchool
//
//  Created by 郎烨 on 2020/12/1.
//  Copyright © 2020 CDEL. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface DLRequestDetailModel : NSObject
/**
 *  标题
 */
@property (nonatomic, copy) NSString *title;
/**
 *  内容
 */
@property (nonatomic, copy) NSString *detailContent;
/**
 *  域名
 */
@property (nonatomic, copy) NSString *urlAddress;
/**
 *  IP
 */
@property (nonatomic, copy) NSString *IP;

@end

NS_ASSUME_NONNULL_END
