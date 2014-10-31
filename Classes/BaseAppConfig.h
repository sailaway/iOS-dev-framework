//
//  AppConfig.h
//  iOSDevFramwork
//
//  Created by dean on 14-10-31.
//  Copyright (c) 2014年 idf. All rights reserved.
//

#import "BaseObject.h"
#import "LevelDB.h"

@interface BaseAppConfig : BaseObject

+ (BaseAppConfig *)getGlobalAppConfig:(LevelDB *)db cls:(Class)cls;

@end
