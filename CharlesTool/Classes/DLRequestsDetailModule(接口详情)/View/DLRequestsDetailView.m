//
//  DLRequestsDetailView.m
//  NetSchool
//
//  Created by 郎烨 on 2020/12/1.
//  Copyright © 2020 CDEL. All rights reserved.
//

#import "DLRequestsDetailView.h"
#import "DLRequestsDetailCell.h"
#import "DLRequestDetailModel.h"

@interface DLRequestsDetailView ()<UITableViewDelegate, UITableViewDataSource>

@property (nonatomic, strong) DLRequestDetailViewModel *viewModel;

@end

@implementation DLRequestsDetailView

- (instancetype)initWithViewModel:(DLRequestDetailViewModel *)viewModel{
    self = [super init];
    if (self) {
        _viewModel = viewModel;
        [self addViews];
    }
    return self;
}

- (void)addViews{
    UITableView *mainTable = [[UITableView alloc] initWithFrame:CGRectZero];
    [mainTable registerClass:[DLRequestsDetailCell class] forCellReuseIdentifier:NSStringFromClass([DLRequestsDetailCell class])];
    mainTable.delegate = self;
    mainTable.dataSource = self;
    [self addSubview:mainTable];
    mainTable.estimatedRowHeight = 100;
    mainTable.rowHeight = UITableViewAutomaticDimension;
    [mainTable mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self);
    }];
}

#pragma mark - UITableViewDataSource
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return [self.viewModel numberOfItems];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    DLRequestsDetailCell *cell = [tableView dequeueReusableCellWithIdentifier:NSStringFromClass([DLRequestsDetailCell class])];
    if (cell == nil) {
        cell = [[DLRequestsDetailCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:NSStringFromClass([DLRequestsDetailCell class])];
    }
    cell.detailModel = [self.viewModel getRequestInfoItemAtIndexPath:indexPath];
    return cell;
}

//#pragma mark - UITableViewDelegate
//- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
//    DLRequestDetailModel *model = [self.viewModel getRequestInfoItemAtIndexPath:indexPath];
//    UIPasteboard *pasteboard = [UIPasteboard generalPasteboard];
//    pasteboard.string = model.detailContent;
//    [DLLoading DLToolTipInWindow:[NSString stringWithFormat:@"%@-已复制至剪切板",model.title]];
//}
//
//- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
//    return [self.viewModel heightForRowAtIndexPath:indexPath];
//}

@end
