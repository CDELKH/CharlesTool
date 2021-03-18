//
//  DLFilterDomainViewController.m
//  CharlesSpec
//
//  Created by konghui on 2021/2/6.
//

#import "DLFilterDomainViewController.h"
#import "DLFilterDomainView.h"

@interface DLFilterDomainViewController ()

@property (nonatomic, strong) DLFilterDomainView *mainView;

@end

@implementation DLFilterDomainViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self.navigationBarView.titleLabel setText:@"筛选域名"];
    [self addViews];
}

- (void)addViews{
    DLFilterDomainView *mainView = [[DLFilterDomainView alloc] init];
    [self.view addSubview:mainView];
    [self nearByNavigationBarView:mainView isShowBottom:NO];
}

@end
