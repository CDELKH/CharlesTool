//
//  CharlesTool.m
//  NetSchool
//
//  Created by 郎烨 on 2020/12/8.
//  Copyright © 2020 CDEL. All rights reserved.
//

#import "CharlesTool.h"
#import "DLDebugManager.h"
#import "DLDebugEntranceView.h"
#import "DLCustomURLProtocol.h"
#import "DLGatewayRequestManager.h"
#import "DLDebugSetViewController.h"
#import "CommUtls.h"
#import <ReactiveCocoa/RACEXTScope.h>

@interface CharlesTool ()

@property (nonatomic, assign) BOOL isShow;
@property (nonatomic, strong) DLDebugEntranceView *debugView;

@end

@implementation CharlesTool

#pragma mark - 单例
+ (instancetype)sharedInstance {
    static CharlesTool *shareInstance;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        shareInstance = [super allocWithZone:NULL];
    });
    return shareInstance;
}

+ (id)allocWithZone:(struct _NSZone *)zone {
    return [CharlesTool sharedInstance];
}

+ (id)copy {
    return [CharlesTool sharedInstance];
}

+ (void)isTurnOnDefaultDebugging:(BOOL)isDefault {
    if (isDefault) {
        [[DLDebugManager shareManager] setDebuggingInterface:YES];
        [self registerProtocolScheme:[DLDebugManager shareManager].supportDebug];
    } else {
        [self registerProtocolScheme:[DLDebugManager shareManager].supportDebug];
    }
}

+ (void)registerProtocolScheme:(BOOL)isOpen {
    
    if (!isOpen) return;
    [CharlesTool isShowDebugView:isOpen];
    
    [DLDomainIPMapManager sharedInstance].delegate = [DLGatewayRequestManager sharedInstance];
    [NSURLProtocol registerClass:[DLCustomURLProtocol class]];
    [DLCustomURLProtocol DL_unregisterScheme];
    
    [[CharlesTool sharedInstance] observeIsShowDebugView];
}

+ (void)debugSetViewControllerController {
    DLDebugSetViewController *proxySettingVC = [[DLDebugSetViewController alloc] init];
    proxySettingVC.hidesBottomBarWhenPushed = YES;
    [[CommUtls getCurrentVC].navigationController pushViewController:proxySettingVC animated:YES];
}

// 是否展示debugView
+ (void)isShowDebugView:(BOOL)isShow {
    [CharlesTool sharedInstance].isShow = isShow;
}

// 观察debug调试的入口是否显示
- (void)observeIsShowDebugView {
    @weakify(self)
    [[[RACObserve(self, isShow) distinctUntilChanged]
      deliverOn:[RACScheduler mainThreadScheduler]] subscribeNext:^(id x) {
        @strongify(self)
        self.debugView.hidden = ![x boolValue];
    }];
}

// 改变选择的环境的名字
- (void)changeDebutonViewTitle:(NSString *)string {
    [self.debugView changeDebutonViewTitle:string];
}

// debug调试入口的View
- (DLDebugEntranceView *)debugView {
    if (_debugView == nil) {
        CGFloat width = [UIScreen mainScreen].bounds.size.width;
        _debugView = [[DLDebugEntranceView alloc] initWithFrame:CGRectMake(width - 70, 350, 70, 70)];
        UIWindow *window = [UIApplication sharedApplication].windows.lastObject;
        [window addSubview:_debugView];
    }
    return _debugView;
}

@end
