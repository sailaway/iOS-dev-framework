//
//  AppConfig.m
//  iOSDevFramwork
//
//  Created by dean on 14-10-31.
//  Copyright (c) 2014年 idf. All rights reserved.
//

#import "BaseAppConfig.h"

#define AppConfigID @"app_constant_id"

@implementation BaseAppConfig

+ (BaseAppConfig *)getGlobalAppConfig:(LevelDB *)db cls:(Class)cls{
    BaseAppConfig *app = (BaseAppConfig *)[BaseObject loadFromDB:db cls:cls ID:AppConfigID];
    return app;
}

@end
