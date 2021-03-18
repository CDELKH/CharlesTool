//
//  DLDebugManager.h
//  BaseWithRAC-BaseWithRAC
//
//  Created by 郎烨 on 2020/12/14.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface DLDebugManager : NSObject

+ (DLDebugManager *)shareManager;

// 支持打开调试模式
- (BOOL)supportDebug;
- (void)setDebuggingInterface:(BOOL)supportDebug;

@end

NS_ASSUME_NONNULL_END
