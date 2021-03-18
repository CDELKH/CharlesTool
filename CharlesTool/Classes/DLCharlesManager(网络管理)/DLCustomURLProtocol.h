//
//  DLCustomURLProtocol.h
//  NetSchool
//
//  Created by konghui on 2020/9/23.
//  Copyright © 2020 CDEL. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface DLCustomURLProtocol : NSURLProtocol

// 该方法为iOS的私有方法，建议上线时注释掉
+ (void)DL_unregisterScheme;

@end

NS_ASSUME_NONNULL_END
