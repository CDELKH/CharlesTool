//
//  DLRequestsDetailViewController.m
//  NetSchool
//
//  Created by 郎烨 on 2020/12/1.
//  Copyright © 2020 CDEL. All rights reserved.
//

#import "DLRequestsDetailViewController.h"
#import "DLRequestsDetailView.h"
#import "DLRequestDetailViewModel.h"

@interface DLRequestsDetailViewController ()

@property (nonatomic, strong) DLRequestDetailViewModel *viewModel;

@end

@implementation DLRequestsDetailViewController

- (instancetype)initWithDictionary:(NSDictionary *)dict;{
    self = [super init];
    if (self) {
        _viewModel = [[DLRequestDetailViewModel alloc] init];
        _viewModel.info = dict;
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self.navigationBarView.titleLabel setText:@"接口详情"];
    
    DLRequestsDetailView *mainView = [[DLRequestsDetailView alloc] initWithViewModel:self.viewModel];
    [self.view addSubview:mainView];
    [self nearByNavigationBarView:mainView isShowBottom:NO];
}

@end
