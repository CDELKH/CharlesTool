//
//  DLProxySettingViewModel.h
//  NetSchool
//
//  Created by konghui on 2020/9/25.
//  Copyright © 2020 CDEL. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface DLProxySettingViewModel : NSObject

@property (nonatomic, strong) RACSubject *reloadSignal;

- (NSInteger)numberOfPorxyChoice;
- (NSString *)proxyChoiceNameAtIndexPath:(NSIndexPath *)indexPath;

- (void)didCellButtonSelectProxyAtIndexPath:(NSInteger)indexPathRow;
- (BOOL)isSelectProxyItemForCurrentIndexPath:(NSIndexPath *)indexPath;
// 添加环境
- (void)addEnvironmentalScience:(NSString *)string;
// 修改环境
- (void)editerEnvironmentWithNewKey:(NSString *)newKey oldKey:(NSString *)oldKey withIndexPath:(NSIndexPath *)indexPath;
- (void)deleteEnvironmentWithIndexPath:(NSIndexPath *)indexPath;
// 刷新全部数据
- (void)reloadPlistFileDataSource:(NSMutableArray *)dataArray atIndexPath:(NSInteger)indexPathRow;
// 关闭已开启的IP
+ (void)turnOffEnabledIP;
// 获取当前环境的名字
+ (NSString *)getCurrentNetworkEnvironment;
// 改变网络环境
- (NSString *)changeCurrentNetworkEnvironment;

@end

NS_ASSUME_NONNULL_END
