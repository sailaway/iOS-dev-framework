//
//  QueryBean.m
//  iOSDevFramwork
//
//  Created by dean on 14-10-31.
//  Copyright (c) 2014年 idf. All rights reserved.
//

#import "BaseObject+Query.h"

@implementation  BaseObject(Query)

+ (NSMutableDictionary *)queryAssignColumnWithDb:(LevelDB *)db cls:(Class)cls col:(NSString *)col{
    BaseObject *obj = [[cls alloc]init];
    __block NSString *keyPrefix = [obj joinKeyWithColumn:col];
    NSMutableArray *keys = [[NSMutableArray alloc]init];
    [db enumerateKeysBackward:false startingAtKey:keyPrefix filteredByPredicate:nil andPrefix:keyPrefix usingBlock:^(LevelDBKey *key, BOOL *stop) {
        NSString *k = NSStringFromLevelDBKey(key);
        k = [k substringFromIndex:keyPrefix.length];
        [keys addObject:k];
    }];
    
    NSMutableDictionary *dict = [[NSMutableDictionary alloc]init];
    for (NSString *key in keys) {
        id val = [db objectForKey:key];
        NSString *ID = [key substringFromIndex:keyPrefix.length];
        [dict setObject:val forKey:ID];
    }
    return dict;
}

+ (NSMutableArray *)queryByColumnAndVal:(LevelDB *)db cls:(Class)cls col:(NSString *)col val:(NSString *)val{
    BaseObject *obj = [[cls alloc]init];
    NSString *keyPrefix = [obj joinKeyWithColumn:col];
    NSMutableArray *keys = [[NSMutableArray alloc]init];
    [db enumerateKeysBackward:false startingAtKey:keyPrefix filteredByPredicate:nil andPrefix:keyPrefix usingBlock:^(LevelDBKey *key, BOOL *stop) {
        NSString *k = NSStringFromLevelDBKey(key);
        NSString *value = [NSString stringWithFormat:@"%@",[db objectForKey:NSStringFromLevelDBKey(key)]];
        if ([value  isEqualToString:val]) {
            NSString *ID = [k substringFromIndex:keyPrefix.length];
            [keys addObject:ID];
        }
    }];
    return keys;
}

+ (NSMutableArray *)queryByColCondition:(LevelDB *)db cls:(Class)cls col:(NSString *)col condition:(BOOL(^)(NSString *col,NSString *val)) condition{
    BaseObject *obj = [[cls alloc]init];
    NSMutableArray *keys = [[NSMutableArray alloc]init];
    __block NSString *keyPrefix = [obj joinKeyWithColumn:col];
    __block BOOL (^cond)(NSString *col,NSString *val) = condition;
    [db enumerateKeysBackward:false startingAtKey:keyPrefix filteredByPredicate:nil andPrefix:keyPrefix usingBlock:^(LevelDBKey *key, BOOL *stop) {
        NSString *k = NSStringFromLevelDBKey(key);
        NSString *ID = [k substringFromIndex:keyPrefix.length];
        NSString *value = [NSString stringWithFormat:@"%@",[db objectForKey:NSStringFromLevelDBKey(key)]];
        if (cond(col,value)) {
            [keys addObject:ID];
        }
    }];
    
    return keys;
}

+ (NSMutableArray *)queryByColsCondition:(LevelDB *)db cls:(Class)cls cols:(NSArray *)cols condition:(BOOL(^)(NSString *col,NSString *val))condition{
    BaseObject *obj = [[cls alloc]init];
    NSString *firstCol = [cols objectAtIndex:0];
    NSMutableArray *arr = [BaseObject queryByColCondition:db cls:cls col:firstCol condition:condition];
    NSString *keyPrefix;
    for (int i = 1; i < cols.count; i++) {
        NSString *col = [cols objectAtIndex:i];
        keyPrefix = [obj joinKeyWithColumn:col];
        for (int j = 0; j < arr.count;) {
            NSString *ID = [arr objectAtIndex:j];
            NSString *k = [obj joinKeyWithColumn:col andID:ID];
            NSString *value = [NSString stringWithFormat:@"%@",[db objectForKey:k]];
            if(!condition(col,value)){
                [arr removeObject:ID];
            } else {
                j++;
            }
        }
    }
    return arr;
}

+ (NSMutableSet *)beanAllIds:(LevelDB *)db cls:(Class)cls{
    NSString *oneUUID = [[NSUUID UUID]UUIDString];
    __block NSUInteger uuidLen = oneUUID.length;
    BaseObject *obj = [[cls alloc]init];
    __block NSString *pre = [obj tableName];
    NSMutableSet *keys = [[NSMutableSet alloc]init];
    [db enumerateKeysBackward:false startingAtKey:pre filteredByPredicate:nil andPrefix:pre usingBlock:^(LevelDBKey *key, BOOL *stop) {
        NSString *k = NSStringFromLevelDBKey(key);
        NSString *ID = [k substringFromIndex:(k.length - uuidLen)];
        [keys addObject:ID];
    }];
    return keys;
}

+ (NSMutableArray *)queryByBeanCondition:(LevelDB *)db cls:(Class)cls condition:(BOOL(^)(id obj))condition{
    NSSet *keys = [BaseObject beanAllIds:db cls:cls];
    NSMutableArray *arr = [[NSMutableArray alloc]init];
    for (NSString *ID in keys) {
        BaseObject *obj = [BaseObject loadFromDB:db cls:cls ID:ID];
        if (condition(obj)) {
            [arr addObject:obj];
        }
    }
    return arr;
}

+ (NSMutableArray *)loadDBAllBeans:(LevelDB *)db cls:(Class)cls{
    NSSet *keys = [BaseObject beanAllIds:db cls:cls];
    NSMutableArray *arr = [[NSMutableArray alloc]init];
    for (NSString *ID in keys) {
        BaseObject *obj = [BaseObject loadFromDB:db cls:cls ID:ID];
        [arr addObject:obj];
    }
    return arr;
}

@end
