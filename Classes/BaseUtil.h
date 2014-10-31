//
//  VisioUtil.h
//  visioiOS
//
//  Created by wangdean on 13-6-17.
//  Copyright (c) 2013年 red_goal. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@interface BaseUtil : NSObject

+ (NSString *)appPlistFile;

+ (BOOL)isValidEmailAddress:(NSString *)email;

+ (NSString *)getResultImageFileByNowTimeWithOver360:(BOOL)over360;

+ (NSString *)getSanpFileWithResultFile:(NSString *)result_file;

+ (UIImage *)getImageSnap:(UIImage *)image;

+ (void)showTipAlertViewWithMessage:(NSString *)msg;

+ (NSString *)getAppDocumentPath;

+ (NSString *)getAppLibraryPath;

+ (NSArray *)listDirectory:(NSString *)path;

+ (BOOL)saveImage:(UIImage *)image atPath:(NSString *)path;

+ (BOOL)saveResultImage:(UIImage *)image atPath:(NSString *)path withThumb:(BOOL)saveThumb;

+ (UIImage *)scaleImage:(UIImage *)image toScale:(float)scaleSize;

+ (BOOL)isNewIphone;

+ (NSString*)getDeviceVersion;

+ (void)saveImg2Album:(UIImage *)image;

+ (double)radius2Degree:(double)degree;
@end
