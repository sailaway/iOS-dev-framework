//
//  BaseObject.m
//  iOSDevFramwork
//
//  Created by dean on 14-10-30.
//  Copyright (c) 2014年 idf. All rights reserved.
//

#import <objc/runtime.h>
#import "BaseObject.h"

@interface BaseObject ()

@end

@implementation BaseObject

- (instancetype)init{
    self = [super init];
    if (self) {
        self.identify = [[NSUUID UUID] UUIDString];
    }
    return self;
}

+ (instancetype)loadFromDB:(LevelDB *)db cls:(Class)cls ID:(NSString *)ID{
    BaseObject *obj = [[cls alloc]init];
    obj.identify = ID;
    NSArray *arr = [obj columns];
    NSMutableDictionary *dict = [[NSMutableDictionary alloc]init];
    for (NSString *col in arr) {
        NSString *key = [obj joinKeyWithColumnAndSelfID:col];
        id val = [db objectForKey:key];
        if (val) {
            [dict setObject:val forKey:col];
        }
    }
    [dict setObject:ID forKey:@"identify"];
    NSError *err;
    BaseObject *newObj = [[cls alloc]initWithDictionary:dict error:&err];
    return newObj;
}

+(BOOL)propertyIsOptional:(NSString*)propertyName{
    return YES;
}

- (NSString *)tableName{
    return NSStringFromClass([self class]);
}
- (NSString *)joinKeyWithColumn:(NSString *)col andID:(NSString *)ID{
    return [NSString stringWithFormat:@"%@%@%@",[self tableName],col,ID];
}
- (NSString *)joinKeyWithColumnAndSelfID:(NSString *)col{
    return [self joinKeyWithColumn:col andID:self.identify];
}
- (NSString *)joinKeyWithColumn:(NSString *)col{
    return [NSString stringWithFormat:@"%@%@",[self tableName],col];
}

- (NSArray *)columns{
    NSMutableArray *cols = [[NSMutableArray alloc]init];
    unsigned int propertyCount;
    objc_property_t *properties = class_copyPropertyList([self class], &propertyCount);
    for (unsigned int i = 0; i < propertyCount; i++) {
        objc_property_t property = properties[i];
        const char *propertyName = property_getName(property);
        NSString *name = [NSString stringWithUTF8String:propertyName];
        [cols addObject:name];
    }
    free(properties);
    return cols;
}

- (BOOL)save2DB:(LevelDB *)db{
    if (![self validateForSave]) {
        NSLog(@"%@ save2DB not validate",[self class]);
        return false;
    }
    NSDictionary *dict = [self toDictionary];
    BOOL old_safe = db.safe;
    db.safe = true;
    for (NSString *col in dict) {
        [self saveColumnValue2DB:db column:col val:[dict objectForKey:col]];
    }
    db.safe = old_safe;
    return true;
}

- (BOOL)validateForSave{
    return true;
}

- (BOOL)saveColumnValue2DB:(LevelDB *)db column:(NSString *)col val:(NSString *)val{
    NSString *key = [self joinKeyWithColumnAndSelfID:col];
    [db setObject:val forKey:key];
    return true;
}

- (BOOL)deleteFromDB:(LevelDB *)db{
    NSArray *arr = [self columns];
    for (NSString *col in arr) {
        [self deleteColumnValueFromDB:db column:col];
    }
    return true;
}

- (BOOL)deleteColumnValueFromDB:(LevelDB *)db column:(NSString *)col{
    NSString *key = [self joinKeyWithColumnAndSelfID:col];
    [db removeObjectForKey:key];
    return true;
}

+ (NSArray *)getBeanListByIds:(LevelDB *)db cls:(Class)cls ids:(NSArray *)ids{
    NSMutableArray *beans = [[NSMutableArray alloc]init];
    for (NSString *ID in ids) {
        id obj = [BaseObject loadFromDB:db cls:cls ID:ID];
        [beans addObject:obj];
    }
    return beans;
}

@end
