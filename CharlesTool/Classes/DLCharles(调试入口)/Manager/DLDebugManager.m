//
//  DLDebugManager.m
//  BaseWithRAC-BaseWithRAC
//
//  Created by 郎烨 on 2020/12/14.
//

#import "DLDebugManager.h"

static NSString *supported = @"supportDebuged";

static DLDebugManager *settingInstance = nil;

@implementation DLDebugManager

+ (DLDebugManager *)shareManager
{
    @synchronized(self){
        if (nil == settingInstance) {
            settingInstance = [[DLDebugManager alloc] init];
        }
    }
    return settingInstance;
}

// 支持打开调试模式
- (BOOL)supportDebug {
    BOOL support = NO;
    NSString *supportStr = [[NSUserDefaults standardUserDefaults] valueForKey:supported];
    if ([supportStr isEqualToString:@"1"]) {
        support = YES;
    }
    return support;
}

- (void)setDebuggingInterface:(BOOL)supportDebug {
    if (supportDebug) {
        [[NSUserDefaults standardUserDefaults] setValue:@"1" forKey:supported];
    } else {
        [[NSUserDefaults standardUserDefaults] setValue:@"0" forKey:supported];
    }
    [[NSUserDefaults standardUserDefaults] synchronize];
}

@end
