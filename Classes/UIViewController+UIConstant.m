//
//  UIViewController+UIConstant.m
//  kiddie_ios_admin
//
//  Created by dean on 14-10-28.
//  Copyright (c) 2014年 dk. All rights reserved.
//

#import "UIViewController+UIConstant.h"

@implementation UIViewController (UIConstant)

- (int)sysBarheight{
    double version = [[UIDevice currentDevice].systemVersion doubleValue];
    if (version >= 7.0) {
        return 20;
    }
    return 0;
}

- (int)uiHeight{
    int h = [[UIScreen mainScreen]bounds].size.height - [self sysBarheight];
    return h;
}
- (int)uiWidth{
    int w = [[UIScreen mainScreen]bounds].size.width;
    return w;
}

@end
