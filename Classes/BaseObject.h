//
//  BaseObject.h
//  iOSDevFramwork
//
//  Created by dean on 14-10-30.
//  Copyright (c) 2014年 idf. All rights reserved.
//

#import "JSONModel.h"
#import "LevelDB.h"

@protocol BaseObject
@end

@interface BaseObject : JSONModel

- (instancetype)init;

@property (retain,nonatomic)NSString *identify;

+ (instancetype)loadFromDB:(LevelDB *)db cls:(Class)cls ID:(NSString *)ID;

- (NSString *)tableName;

- (NSString *)joinKeyWithColumn:(NSString *)col andID:(NSString *)ID;

- (NSString *)joinKeyWithColumnAndSelfID:(NSString *)col;

- (NSString *)joinKeyWithColumn:(NSString *)col;

- (NSArray *)columns;

- (BOOL)validateForSave;

- (BOOL)save2DB:(LevelDB *)db;

- (BOOL)saveColumnValue2DB:(LevelDB *)db column:(NSString *)col val:(NSString *)val;

- (BOOL)deleteFromDB:(LevelDB *)db;

- (BOOL)deleteColumnValueFromDB:(LevelDB *)db column:(NSString *)col;

+ (NSArray *)getBeanListByIds:(LevelDB *)db cls:(Class)cls ids:(NSArray *)ids;

@end
