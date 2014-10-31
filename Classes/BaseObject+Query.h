//
//  QueryBean.h
//  iOSDevFramwork
//
//  Created by dean on 14-10-31.
//  Copyright (c) 2014年 idf. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "BaseObject.h"

@interface BaseObject(Query)

+ (NSMutableDictionary *)queryAssignColumnWithDb:(LevelDB *)db cls:(Class)cls col:(NSString *)col;

+ (NSMutableArray *)queryByColumnAndVal:(LevelDB *)db cls:(Class)cls col:(NSString *)col val:(NSString *)val;

+ (NSMutableArray *)queryByColCondition:(LevelDB *)db cls:(Class)cls col:(NSString *)col condition:(BOOL(^)(NSString *col,NSString *val))condition;

+ (NSMutableArray *)queryByColsCondition:(LevelDB *)db cls:(Class)cls cols:(NSArray *)cols condition:(BOOL(^)(NSString *col,NSString *val))condition;

+ (NSMutableSet *)beanAllIds:(LevelDB *)db cls:(Class)cls;

+ (NSMutableArray *)queryByBeanCondition:(LevelDB *)db cls:(Class)cls condition:(BOOL(^)(id obj))condition;

+ (NSMutableArray *)loadDBAllBeans:(LevelDB *)db cls:(Class)cls;

@end
