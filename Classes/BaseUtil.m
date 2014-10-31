//
//  VisioUtil.m
//  visioiOS
//
//  Created by wangdean on 13-6-17.
//  Copyright (c) 2013年 red_goal. All rights reserved.
//

#import "BaseUtil.h"
#import <Foundation/Foundation.h>
#import <math.h>
#import "sys/utsname.h"

#define kSnapHeight 120.0f

@implementation BaseUtil

+ (BOOL)isValidEmailAddress:(NSString *)email {
    NSString *emailRegex = @"[A-Z0-9a-z._%+-]+@[A-Z0-9a-z.-]+\\.[A-Za-z]{2,4}";
    NSPredicate *emailTest = [NSPredicate predicateWithFormat:@"SELF MATCHES %@",emailRegex];
    return [emailTest evaluateWithObject:email];
}

+ (NSString *)getResultImageFileByNowTimeWithOver360:(BOOL)over360 {
    NSString *documentsDirectory = [BaseUtil getAppDocumentPath];
	NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
	[dateFormatter setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
	NSString *destinationPath = [documentsDirectory stringByAppendingFormat:@"/result_%@ %d.jpg", [dateFormatter stringFromDate:[NSDate date]],over360];
    return destinationPath;
}

+ (void)showTipAlertViewWithMessage:(NSString *)msg {
    UIAlertView *alert = [[UIAlertView alloc]initWithTitle:@"提示" message:msg delegate:nil cancelButtonTitle:@"确定" otherButtonTitles: nil];
    [alert show];
//    [[[[iToast makeText:msg]setGravity:iToastGravityBottom]setDuration:2000] show:iToastTypeInfo];
}

+ (NSString *)appPlistFile {
    NSString *dir = [BaseUtil getAppDocumentPath];
    NSString *dbPath = [dir stringByAppendingString:@"/kiddie.plist"];
    return dbPath;
}

+ (NSString *)getAppDocumentPath {
    NSArray *array = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *path = [array count] > 0 ? [array objectAtIndex:0] : nil;
    
    NSError *error;
    NSFileManager *fileManager = [NSFileManager defaultManager];
    BOOL ok = [fileManager createDirectoryAtPath:path withIntermediateDirectories:YES attributes:nil error:&error];
    if(!ok){
        NSLog(@"document path create failed for: %@",error);
    }
    
    return path;
}

+ (NSString *)getAppLibraryPath {
    NSArray *array = NSSearchPathForDirectoriesInDomains(NSLibraryDirectory, NSUserDomainMask, YES);
    NSString *path = [array count] > 0 ? [array objectAtIndex:0] : nil;
    
    NSError *error;
    NSFileManager *fileManager = [NSFileManager defaultManager];
    BOOL ok = [fileManager createDirectoryAtPath:path withIntermediateDirectories:YES attributes:nil error:&error];
    if(!ok){
        NSLog(@"library path create failed for: %@",error);
    }
    
    return path;
}

+ (NSArray *)listDirectory:(NSString *)path {
    NSError *error;
    NSArray *array = [[NSFileManager defaultManager]contentsOfDirectoryAtPath:path error:&error];
    return array;
}

+ (BOOL)saveImage:(UIImage *)image atPath:(NSString *)path {
    NSError *error;
    NSData *data = [NSData dataWithData:UIImageJPEGRepresentation(image, 1.0)];
    BOOL ok = [data writeToFile:path options:NSDataWritingFileProtectionComplete error:&error];
    if(!ok){
        NSLog(@"saveImage failed for: %@",error);
    }
    return ok;
}

+ (NSString *)getSanpFileWithResultFile:(NSString *)result_file {
    NSString *file = [result_file stringByReplacingOccurrencesOfString:@"result_" withString:@"snap_"];
    return file;
}

+ (UIImage *)getImageSnap:(UIImage *)image {
    float scale = kSnapHeight / image.size.height;
    UIImage *snapImage = [BaseUtil scaleImage:image toScale:scale];
    return snapImage;
}

+ (BOOL)saveResultImage:(UIImage *)image atPath:(NSString *)path withThumb:(BOOL)saveThumb {
    BOOL ok = [BaseUtil saveImage:image atPath:path];
    if (ok) {
        UIImage *snap = [BaseUtil getImageSnap:image];
        ok = [BaseUtil saveImage:snap atPath:[BaseUtil getSanpFileWithResultFile:path]];
    }
    return ok;
}

#define kUseNewResizeFunction 0
+ (UIImage *)scaleImage:(UIImage *)image toScale:(float)scaleSize {
    
#if kUseNewResizeFunction
    UIImage *newImg = [image resizedImage:CGSizeMake(image.size.width * scaleSize, image.size.height * scaleSize) interpolationQuality:kCGInterpolationLow];
    return newImg;
#else
    UIGraphicsBeginImageContext(CGSizeMake(image.size.width * scaleSize, image.size.height * scaleSize));
    [image drawInRect:CGRectMake(0, 0, image.size.width * scaleSize, image.size.height * scaleSize)];
    UIImage *scaledImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return scaledImage;
#endif
}

+ (BOOL)isNewIphone {
    NSString *deviceVersion = [BaseUtil getDeviceVersion];
    if ([deviceVersion rangeOfString:@"4S"].location != NSNotFound) {
        return true;
    }
    if ([deviceVersion rangeOfString:@"iPhone"].location != NSNotFound) {
        if ([deviceVersion rangeOfString:@"5"].location != NSNotFound) {
            return true;
        }
    } else if([deviceVersion rangeOfString:@"iPod"].location != NSNotFound){
        if ([deviceVersion rangeOfString:@"5"].location != NSNotFound) {
            return true;
        }
    }
    return false;
}

+ (NSString*)getDeviceVersion {
    struct utsname systemInfo;
    uname(&systemInfo);
    NSString *deviceString = [NSString stringWithCString:systemInfo.machine encoding:NSUTF8StringEncoding];
    if ([deviceString isEqualToString:@"iPhone1,1"])    return @"iPhone 1G";
    if ([deviceString isEqualToString:@"iPhone1,2"])    return @"iPhone 3G";
    if ([deviceString isEqualToString:@"iPhone2,1"])    return @"iPhone 3GS";
    if ([deviceString isEqualToString:@"iPhone3,1"])    return @"iPhone 4";
    if ([deviceString isEqualToString:@"iPhone4,1"])    return @"iPhone 4S";
    if ([deviceString isEqualToString:@"iPhone5,2"])    return @"iPhone 5";
    if ([deviceString isEqualToString:@"iPhone3,2"])    return @"Verizon iPhone 4";
    if ([deviceString isEqualToString:@"iPod1,1"])      return @"iPod 1G";
    if ([deviceString isEqualToString:@"iPod2,1"])      return @"iPod 2G";
    if ([deviceString isEqualToString:@"iPod3,1"])      return @"iPod 3G";
    if ([deviceString isEqualToString:@"iPod4,1"])      return @"iPod 4G";
    if ([deviceString isEqualToString:@"iPod5,1"])      return @"iPod 5G";
    if ([deviceString isEqualToString:@"iPad1,1"])      return @"iPad";
    if ([deviceString isEqualToString:@"iPad2,1"])      return @"iPad 2 (WiFi)";
    if ([deviceString isEqualToString:@"iPad2,2"])      return @"iPad 2 (GSM)";
    if ([deviceString isEqualToString:@"iPad2,3"])      return @"iPad 2 (CDMA)";
    if ([deviceString isEqualToString:@"i386"])         return @"Simulator";
    if ([deviceString isEqualToString:@"x86_64"])       return @"Simulator";
    NSLog(@"NOTE: Unknown device type: %@", deviceString);
    return deviceString;
}

+ (void)saveAlbumSuccess {
    [self showTipAlertViewWithMessage:@"save image success"];
}

+ (void)saveImg2Album:(UIImage *)image {
    UIImageWriteToSavedPhotosAlbum(image, nil, nil, nil);
}


#pragma mark math

+ (double)radius2Degree:(double)degree {
    return degree * 180 / M_PI;
}


@end
