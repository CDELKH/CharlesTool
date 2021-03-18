//
//  DLRequestsInfoViewController.m
//  NetSchool
//
//  Created by konghui on 2020/11/10.
//  Copyright © 2020 CDEL. All rights reserved.
//

#import "DLRequestsInfoViewController.h"
#import "DLRequestsInfoViewModel.h"
#import "DLRequestsInfoView.h"
#import "DLRequestsDetailViewController.h"
#import "DLProxySettingViewModel.h"

@interface DLRequestsInfoViewController ()

@property (nonatomic, strong) DLRequestsInfoViewModel *viewModel;
@property (nonatomic, strong) DLRequestsInfoView *mainView;

@end

@implementation DLRequestsInfoViewController

- (instancetype)init{
    self = [super init];
    if (self) {        
        _viewModel = [[DLRequestsInfoViewModel alloc] init];
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    NSString *environmentName = [DLProxySettingViewModel getCurrentNetworkEnvironment];
    if (!environmentName || environmentName.length == 0) {
        environmentName = @"初始环境";
    }
    [self.navigationBarView.titleLabel setText:environmentName];
    self.navigationBarView.navagationBarStyle = Left_right_button_show;
    // 时间排序—默认倒叙
    [self.navigationBarView.rightLabel setText:@"时间排序"];
    DLRequestsInfoView *mainView = [[DLRequestsInfoView alloc] initWithViewModel:self.viewModel];
    [self.view addSubview:mainView];
    [self nearByNavigationBarView:mainView isShowBottom:NO];
    self.mainView = mainView;
    [self bindSignals];
}

- (void)rightButtonClick {
    [self.viewModel dataSourceReversalDisplay];
}

- (void)bindSignals{
    @weakify(self)
    [self.viewModel.jumpToDetailSignal subscribeNext:^(id x) {
        @strongify(self)
        DLRequestsDetailViewController *detailVC = [[DLRequestsDetailViewController alloc] initWithDictionary:(NSDictionary *)x];
        [self.navigationController pushViewController:detailVC animated:YES];
    }];
}

@end
