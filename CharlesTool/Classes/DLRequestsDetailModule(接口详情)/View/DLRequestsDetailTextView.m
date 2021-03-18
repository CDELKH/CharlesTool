//
//  DLRequestsDetailTextView.m
//  CharlesSpec
//
//  Created by shenglong on 2021/3/3.
//

#import "DLRequestsDetailTextView.h"

@interface DLRequestsDetailTextView ()

@end

@implementation DLRequestsDetailTextView

- (void)dealloc {
#ifdef DEBUG
    NSLog(@"dealloc -- %@", self.class);
#endif
}

// 继承UITextView重写这个方法
- (BOOL)canPerformAction:(SEL)action withSender:(id)sender {
    // 返回NO为禁用，YES为开启
    // 分享、选中全部、复制
    NSString *actionString = NSStringFromSelector(action);
    if ([actionString containsString:@"share"] || [actionString containsString:@"selectAll"] || [actionString containsString:@"copy"]) {
        return YES;
    } else {
        return NO;
    }
    return [super canPerformAction:action withSender:sender];
}

@end
