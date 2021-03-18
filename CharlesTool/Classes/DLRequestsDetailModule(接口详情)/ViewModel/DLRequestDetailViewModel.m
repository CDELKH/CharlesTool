//
//  DLRequestDetailViewModel.m
//  NetSchool
//
//  Created by 郎烨 on 2020/12/1.
//  Copyright © 2020 CDEL. All rights reserved.
//

#import "DLRequestDetailViewModel.h"
#import "DLRequestDetailModel.h"
#import "DLDomainIPMapManager.h"

@interface DLRequestDetailViewModel ()

@property (nonatomic, strong) NSMutableArray *array;
@property (nonatomic, strong) NSMutableArray *listTitleArray;
@property (nonatomic, strong) NSMutableDictionary *cacheHeightDic;

@end

@implementation DLRequestDetailViewModel

- (NSInteger)numberOfItems {
    return self.array.count;
}

- (DLRequestDetailModel *)getRequestInfoItemAtIndexPath:(NSIndexPath *)indexPath {
    DLRequestDetailModel *model = self.array[indexPath.row];
    return model;
}

- (CGFloat)heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    NSString *infoKey = [NSString stringWithFormat:@"%ld", indexPath.row];
    CGFloat cellHeight = 0;
    if (self.cacheHeightDic[infoKey]) {
        cellHeight = [self.cacheHeightDic[infoKey] floatValue];
    }else{
        DLRequestDetailModel *model = [self getRequestInfoItemAtIndexPath:indexPath];
        cellHeight = [model.detailContent boundingRectWithSize:CGSizeMake([UIScreen mainScreen]. bounds.size.width - 2 * 15, CGFLOAT_MAX) options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName :[UIFont systemFontOfSize:15]} context:nil].size.height + 5 + 10 + 5 + 25;
        self.cacheHeightDic[infoKey] = @(cellHeight);
    };
    return cellHeight;
}

- (void)setInfo:(NSDictionary *)info {
    for (int i = 0; i < self.listTitleArray.count; i++) {
        DLRequestDetailModel *model = [DLRequestDetailModel new];
        model.title = self.listTitleArray[i];
        switch (i) {
            case 0:
                model.detailContent = info[DL_CHARLES_REQUEST_INFO_KEY_URL];
                break;
            case 1:
                model.detailContent = info[DL_CHARLES_REQUEST_INFO_KEY_STATUSCODE];
                break;
            case 2:
                model.detailContent = info[DL_CHARLES_REQUEST_INFO_KEY_PARAMAS];
                break;
            case 3:
                model.detailContent = info[DL_CHARLES_REQUEST_INFO_KEY_RESPONSEDATA];
                break;
            case 4:
                model.detailContent = info[DL_CHARLES_REQUEST_INFO_KEY_ERROR];
                break;
            default:
                break;
        }
        [self.array addObject:model];
    }
}

- (NSMutableArray *)listTitleArray {
    if (_listTitleArray == nil) {
        _listTitleArray = [NSMutableArray arrayWithArray: @[@"接口路径",@"Code状态",@"请求参数",@"响应结果",@"错误信息"]];
    }
    return _listTitleArray;
}

- (NSMutableArray *)array {
    if (_array == nil) {
        _array = [NSMutableArray array];
    }
    return _array;
}

- (NSMutableDictionary *)cacheHeightDic {
    if (_cacheHeightDic == nil) {
        _cacheHeightDic = [NSMutableDictionary dictionary];
    }
    return _cacheHeightDic;
}

@end
