//
//  CommUtls.h
//  CharlesTool
//
//  Created by konghui on 2021/3/16.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface CommUtls : NSObject

+ (UIViewController *)getCurrentVC;

+ (UIColor *)colorWithHexString:(NSString *)stringToConvert;

/**
 *  是否是全面屏iPhone
 */
+ (BOOL)iPhoneX;

+ (CGFloat)getSafeAreaTop;

@end

NS_ASSUME_NONNULL_END
