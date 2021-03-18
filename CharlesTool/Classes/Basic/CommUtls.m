//
//  CommUtls.m
//  CharlesTool
//
//  Created by konghui on 2021/3/16.
//

#import "CommUtls.h"

@implementation CommUtls

+ (UIColor *)colorWithHexString:(NSString *)stringToConvert
{
    NSString *cString = [[stringToConvert stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]] uppercaseString];
    
    // String should be 6 or 8 characters
    if ([cString length] < 6)
        return [UIColor whiteColor];
    
    // strip 0X if it appears
    if ([cString hasPrefix:@"0X"])
        cString = [cString substringFromIndex:2];
    else if ([cString hasPrefix:@"#"])
        cString = [cString substringFromIndex:1];
    if ([cString length] != 6)
        return [UIColor whiteColor];
    // Separate into r, g, b substrings
    NSRange range;
    range.location = 0;
    range.length = 2;
    NSString *rString = [cString substringWithRange:range];
    
    range.location = 2;
    NSString *gString = [cString substringWithRange:range];
    
    range.location = 4;
    NSString *bString = [cString substringWithRange:range];
    
    // Scan values
    unsigned int r, g, b;
    [[NSScanner scannerWithString:rString] scanHexInt:&r];
    [[NSScanner scannerWithString:gString] scanHexInt:&g];
    [[NSScanner scannerWithString:bString] scanHexInt:&b];
    
    return [UIColor colorWithRed:((float)r / 255.0f)
                           green:((float)g / 255.0f)
                            blue:((float)b / 255.0f)
                           alpha:1.0f];
}

+ (UIViewController *)getCurrentVC {
    return [self getCurrentVC:0];
}

+ (UIViewController *)getCurrentVC:(NSInteger)index {
    if ([NSThread isMainThread]) {
        UIViewController *result = nil;
        UIWindow * window = [[UIApplication sharedApplication] keyWindow];
        if (window.windowLevel != UIWindowLevelNormal) {
            NSArray *windows = [[UIApplication sharedApplication] windows];
            for(UIWindow * tmpWin in windows) {
                if (tmpWin.windowLevel == UIWindowLevelNormal && tmpWin.subviews.count) {
                    window = tmpWin;
                    break;
                }
            }
        }
        if ([window subviews].count < 1) {
            return nil;
        }
        UIView *frontView = [[window subviews] objectAtIndex:(window.subviews.count>index?index:0)];
        id nextResponder = [frontView nextResponder];
        if ([nextResponder isKindOfClass:[UIViewController class]]) {
            result = nextResponder;
        } else {
            result = window.rootViewController;
            if (result.presentedViewController) {
                // 避免使用presentViewController方式推出页面找不到对应的VC
                result = result.presentedViewController;
            }
        }
        if (!result) {
            result = [self getCurrentVCSecond];
        }
        if (result) {
            return [self findTureVC:result];
        }
    }
    return nil;
}

+ (UIViewController *)getCurrentVCSecond {
    UIViewController *appRootVC = [UIApplication sharedApplication].keyWindow.rootViewController;
    UIViewController *topVC = appRootVC;
    if (topVC.presentedViewController) {
        topVC = topVC.presentedViewController;
    }
    return topVC;
}

+ (UIViewController *)findTureVC:(UIViewController *)vc {
    if ([vc isKindOfClass:[UITabBarController class]]) {
        return [self findTureVC:((UITabBarController *)vc).selectedViewController];
    } else if ([vc isKindOfClass:[UINavigationController class]]) {
        return [self findTureVC:((UINavigationController *)vc).viewControllers.lastObject];
    }
    return vc;
}

+ (BOOL)iPhoneX {
    if ([[UIDevice currentDevice] userInterfaceIdiom] == UIUserInterfaceIdiomPhone) {
        if ([self getSafeAreaHeight] > 0) {
            return YES;
        }
    }
    return NO;
}

+ (CGFloat)getSafeAreaHeight {
    static CGFloat cus_safeAreaBottom = -1;
    if (cus_safeAreaBottom >= 0) {
        return cus_safeAreaBottom;
    }
    CGFloat safeAreaBottom = 0;
    if (@available(iOS 11.0, *)) {
        /// 动态获取该值的话，在横屏状态下会有变化，在应用内会有影响
        safeAreaBottom = [UIApplication sharedApplication].delegate.window.safeAreaInsets.bottom;
    }
    if ([UIApplication sharedApplication].statusBarOrientation == UIDeviceOrientationPortrait) {
        cus_safeAreaBottom = safeAreaBottom;
    }
    return safeAreaBottom;
}

+ (CGFloat)getSafeAreaTop {
    static CGFloat cus_safeAreaTop = -1;
    if (cus_safeAreaTop >= 0) {
        return cus_safeAreaTop;
    }
    CGFloat safeAreaTop = 0;
    if (@available(iOS 11.0, *)) {
        /// 动态获取该值的话，在横屏状态下会有变化，在应用内会有影响
        safeAreaTop = [UIApplication sharedApplication].delegate.window.safeAreaInsets.top;
    }
    if ([UIApplication sharedApplication].statusBarOrientation == UIDeviceOrientationPortrait) {
        cus_safeAreaTop = safeAreaTop;
    }
    return safeAreaTop;
}

@end
