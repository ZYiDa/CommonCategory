//
//  NSString+FileManager.m
//  FileManager
//
//  Created by  on 2018/4/28.
//  Copyright © 2018年 zcz. All rights reserved.
//

#import "NSString+FileManager.h"

@implementation NSString (FileManager)


#pragma mark --
+ (NSArray *)getPathsWithDirectoryType:(NSSearchPathDirectory)type{
    return NSSearchPathForDirectoriesInDomains(type, NSUserDomainMask, YES);
}

#pragma mark -- 获取沙盒根目录
+ (NSString *)getHomeDirectory{
    return NSHomeDirectory();
}

#pragma mark -- 获取 Documents 路径
+ (NSString *)getDocumentsPath{
    NSArray *paths = [self getPathsWithDirectoryType:NSDocumentDirectory];
    return [paths objectAtIndex:0];
}

#pragma mark -- 获取 Library 路径
+ (NSString *)getLibraryPath{
    NSArray *paths = [self getPathsWithDirectoryType:NSLibraryDirectory];
    return [paths objectAtIndex:0];
}

#pragma mark -- 获取 Library 文件夹下 Cache 文件夹的路径
+(NSString *)getLibraryCachesPath{
    NSArray *paths = [self getPathsWithDirectoryType:NSCachesDirectory];
    return [paths objectAtIndex:0];
}

#pragma mark -- 获取 Library 文件夹下 Preference 文件夹的路径
+ (NSString *)getLibraryPreferencePath{
    NSArray *paths = [self getPathsWithDirectoryType:NSPreferencePanesDirectory];
    return [paths objectAtIndex:0];
}

#pragma mark -- 获取 tmp 临时文件夹的路径
+ (NSString *)getTmpPath{
    return NSTemporaryDirectory();
}

#pragma mark -- NSFileManager
+ (NSFileManager *)fileManager{
    NSFileManager *manager = [NSFileManager defaultManager];
    return manager;
}

#pragma mark -- 获取一个目录下所有的文件名
+ (NSArray *)getAllFileNamesAtPath:(NSString *)path{
    NSFileManager *manager = [self fileManager];
    return [manager subpathsAtPath:path];
}

#pragma mark -- 创建一个新的文件夹
+ (NSString *)createNewDirectoryWithPath:(NSString *)path andName:(NSString *)name{
    NSFileManager *manager = [self fileManager];
    NSString *newDirectoryPath = [path stringByAppendingPathComponent:name];
    NSError *error;
    BOOL isDir = NO;
    BOOL isExist = [manager fileExistsAtPath:newDirectoryPath isDirectory:&isDir];
    if (!isDir && !isExist) {
        BOOL isSuccess = [manager createDirectoryAtPath:newDirectoryPath withIntermediateDirectories:YES attributes:nil error:&error];
        return isSuccess ? newDirectoryPath:@"路径创建失败";
    }
    /*
     *路径创建失败的可能原因有：1-没有权限；2-路径已存在；3-名称错误；4-其它
     */
    return @"路径创建失败";
}

#pragma mark -- 在目录下写入文件
+ (BOOL)writeFileToPath:(NSString *)path withFileName:(NSString *)fileNmame andFileContent:(NSString *)fileContent{
    NSString *filePath = [path stringByAppendingPathComponent:@"/xxx.txt"];
    BOOL isWriteSuccess = [fileContent writeToFile:filePath atomically:YES encoding:NSUTF8StringEncoding error:nil];
    return isWriteSuccess;
}

#pragma mark -- 移除一个文件/文件夹
+(BOOL)removeItemAtPath:(NSString *)path{
    NSFileManager *maanager = [self fileManager];
    NSError *error;
    BOOL ret = [maanager removeItemAtPath:path error:&error];
    if (!ret) {
        NSLog(@"**** Failed:%@ ****",error);
    }
    return ret;
}

@end
