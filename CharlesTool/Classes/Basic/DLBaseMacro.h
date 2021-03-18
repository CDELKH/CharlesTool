//
//  DLBaseMacro.h
//  Pods
//
//  Created by konghui on 2021/3/16.
//

#ifndef DLBaseMacro_h
#define DLBaseMacro_h

#import "CommUtls.h"

#define NodeExist(node) (node != nil && ![node isEqual:[NSNull null]])

#define iPhoneX [CommUtls iPhoneX]

#define NAVIGATIONBAR_HEIGHT (STATUS_BAR_HEIGHT + 45)

#define STATUS_BAR_HEIGHT   ([CommUtls getSafeAreaTop]?:20)

#endif /* DLBaseMacro_h */
