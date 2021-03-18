//
//  DLProxySettingViewModel.m
//  NetSchool
//
//  Created by konghui on 2020/9/25.
//  Copyright © 2020 CDEL. All rights reserved.
//

#import "DLProxySettingViewModel.h"
#import "DLDomainIPMapManager.h"
#import "CharlesTool.h"
#import "DLBaseMacro.h"

#define DL_PROXY_CONFIGURATION_KEY @"DLProxyConfigurationKey"
#define DL_PROXY_CONFIGURATION_NAME_NONE @"None"

@interface DLProxySettingViewModel ()

@property (nonatomic, strong) NSMutableArray *localMapRelations;
@property (nonatomic, assign) NSInteger selectProxyIndex;
@property (nonatomic, strong) NSString *fileName;

@end

@implementation DLProxySettingViewModel

#pragma mark - 初始化
- (instancetype)init{
    self = [super init];
    if (self) {
        _reloadSignal = [RACSubject subject];
        [self initPreviousProxyConfiguration];
    }
    return self;
}

- (void)initPreviousProxyConfiguration{
    //读取之前配置
    NSString *proxyName = [[NSUserDefaults standardUserDefaults] valueForKey:DL_PROXY_CONFIGURATION_KEY];
    if (!proxyName) {
        _selectProxyIndex = 0;
    }else{
        __block NSDictionary *wifiMapRelation;
        if ([proxyName isEqualToString:DL_PROXY_CONFIGURATION_NAME_NONE]) {
            _selectProxyIndex = 0;
        } else {
            [self.localMapRelations enumerateObjectsUsingBlock:^(NSDictionary * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
                if ([[obj.allKeys firstObject] isEqualToString:proxyName]) {
                    _selectProxyIndex = idx + 1;
                    wifiMapRelation = [obj.allValues firstObject];
                    *stop = YES;
                }
            }];
        }
        if (_selectProxyIndex != 0) {
            [[DLDomainIPMapManager sharedInstance] setEnableChangeIPForDomain:YES];
            if (wifiMapRelation) {
                [[DLDomainIPMapManager sharedInstance] setCustomizedMapRelation:wifiMapRelation];
            }
        }
    }
}

- (NSInteger)numberOfPorxyChoice{
    return 1 + self.localMapRelations.count;
}

- (NSString *)proxyChoiceNameAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.row == 0) {
        return @"初始环境";
    }else {
        NSInteger actualIndex = indexPath.row - 1;
        NSDictionary *wifiMapRelation = self.localMapRelations[actualIndex];
        return [wifiMapRelation.allKeys firstObject];
    }
}

- (void)didCellButtonSelectProxyAtIndexPath:(NSInteger)indexPathRow {
    if (self.selectProxyIndex == indexPathRow && (indexPathRow != 1 + self.localMapRelations.count)) {
        return;
    }
    self.selectProxyIndex = indexPathRow;
    
    NSString *proxyName = nil;
    if (indexPathRow == 0) {
        //关闭域名切ip
        [DLDomainIPMapManager sharedInstance].enableChangeIPForDomain = NO;
        
        proxyName = DL_PROXY_CONFIGURATION_NAME_NONE;
    }else{
        if (indexPathRow <= self.localMapRelations.count) {
            NSInteger actualIndex = indexPathRow - 1;
            NSDictionary *wifiMapRelationItem = self.localMapRelations[actualIndex];
            NSDictionary *wifiMapRelation = [wifiMapRelationItem.allValues firstObject];
            //开启域名切ip
            [DLDomainIPMapManager sharedInstance].enableChangeIPForDomain = YES;
            //设置映射关系
            [[DLDomainIPMapManager sharedInstance] setCustomizedMapRelation:wifiMapRelation];
            
            proxyName = [wifiMapRelationItem.allKeys firstObject];
        }
    }
    [[CharlesTool sharedInstance] changeDebutonViewTitle:[proxyName isEqualToString:DL_PROXY_CONFIGURATION_NAME_NONE] ? @"" : proxyName];
    [[NSUserDefaults standardUserDefaults] setValue:proxyName forKey:DL_PROXY_CONFIGURATION_KEY];
    
    [self.reloadSignal sendNext:nil];
}

- (BOOL)isSelectProxyItemForCurrentIndexPath:(NSIndexPath *)indexPath{
    return indexPath.row == self.selectProxyIndex;
}

- (void)reloadPlistFileDataSource:(NSMutableArray *)dataArray atIndexPath:(NSInteger)indexPathRow{
    self.localMapRelations = dataArray;
    [self reloadDataWith:indexPathRow + 1];
}

- (void)addEnvironmentalScience:(NSString *)string {
    if (NodeExist(string) && string.length > 0) {
        // 1.处理数据
        NSDictionary *dict = [NSDictionary dictionaryWithObject:[NSDictionary new] forKey:string];
        // 2.存储数据_写入plist中
        [self.localMapRelations addObject:dict];
        [self.localMapRelations writeToFile:self.fileName atomically:YES];
        [self.reloadSignal sendNext:nil];
    }
}

- (void)editerEnvironmentWithNewKey:(NSString *)newKey oldKey:(NSString *)oldKey withIndexPath:(NSIndexPath *)indexPath {
    NSMutableDictionary *dict = self.localMapRelations[indexPath.row - 1];
    if(dict != nil){
        NSDictionary *newDict = [NSDictionary dictionaryWithObject:dict[oldKey] == nil ? @"" : dict[oldKey] forKey:newKey];
        [self.localMapRelations replaceObjectAtIndex:indexPath.row - 1 withObject:newDict];
        [self.localMapRelations writeToFile:self.fileName atomically:YES];
    }
    [self reloadDataWith:indexPath.row];
}

- (void)deleteEnvironmentWithIndexPath:(NSIndexPath *)indexPath {
    [self.localMapRelations removeObjectAtIndex:indexPath.row - 1];
    [self.localMapRelations writeToFile:self.fileName atomically:YES];
    if (self.selectProxyIndex == indexPath.row) {
        [self didCellButtonSelectProxyAtIndexPath:0];
    }
    [self.reloadSignal sendNext:nil];
}

- (void)reloadDataWith:(NSInteger)row {
    if (self.selectProxyIndex == row) {
        self.selectProxyIndex = 0;
        [self didCellButtonSelectProxyAtIndexPath:row];
    }
    [self.reloadSignal sendNext:nil];
}

- (NSMutableArray *)localMapRelations {
    if (_localMapRelations == nil) {
        _localMapRelations = [[NSMutableArray alloc] initWithContentsOfFile:self.fileName];
        if (_localMapRelations == nil || _localMapRelations.count == 0) {
            
//            NSString *localMapRelationPlistFilePath = [[NSBundle mainBundle] pathForResource:@"DomainIPMap" ofType:@"plist"];
//            _localMapRelations = [[NSMutableArray alloc] initWithContentsOfFile:localMapRelationPlistFilePath];
//
//            NSString *path = [[NSBundle bundleForClass:[self class]] pathForResource:@"CharlesSpec" ofType:@"bundle"];
//                NSString *filePath = [[NSBundle bundleWithPath:path]
//            pathForResource:@"DomainIPMap" ofType:@"plist"];
//            _localMapRelations = [[NSMutableArray alloc] initWithContentsOfFile:filePath];
            
            // 读取本地映射关系
            NSString *filePath = [[NSBundle bundleForClass:[self class]] pathForResource:@"DomainIPMap" ofType:@"plist"];
            _localMapRelations = [[NSMutableArray alloc] initWithContentsOfFile:filePath];
        }
    }
    return _localMapRelations;
}

- (NSString *)fileName {
    if (_fileName == nil) {
        NSString *path = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES).firstObject;
        _fileName = [path stringByAppendingPathComponent:@"CustomIPMap.plist"];
    }
    return _fileName;
}

// 改变网络环境
- (NSString *)changeCurrentNetworkEnvironment {
    NSInteger indexPathRow = self.selectProxyIndex + 1;
    indexPathRow = indexPathRow > self.localMapRelations.count ? 0 : indexPathRow;
    [self didCellButtonSelectProxyAtIndexPath:indexPathRow];
    return [DLProxySettingViewModel getCurrentNetworkEnvironment];
}

// 关闭已开启的IP
+ (void)turnOffEnabledIP {
    [DLDomainIPMapManager sharedInstance].enableChangeIPForDomain = NO;
    [[NSUserDefaults standardUserDefaults] setValue:DL_PROXY_CONFIGURATION_NAME_NONE forKey:DL_PROXY_CONFIGURATION_KEY];
}

+ (NSString *)getCurrentNetworkEnvironment {
    NSString *proxyName = [[NSUserDefaults standardUserDefaults] valueForKey:DL_PROXY_CONFIGURATION_KEY];
    return [proxyName isEqualToString:DL_PROXY_CONFIGURATION_NAME_NONE] ? @"" : proxyName;
}

@end
