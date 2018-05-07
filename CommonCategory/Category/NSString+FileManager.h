//
//  NSString+FileManager.h
//  FileManager
//
//  Created by  on 2018/4/28.
//  Copyright © 2018年 zcz. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSString (FileManager)
/*
 *获取沙盒根目录
 */
+ (NSString *)getHomeDirectory;

/*
 *获取 Document 文件夹路径
 */
+ (NSString *)getDocumentsPath;

/*
 *获取 Library 文件夹路径
 */
+ (NSString *)getLibraryPath;

/*
 *获取 Library 文件夹下 Cache 文件夹的路径
 */
+ (NSString *)getLibraryCachesPath;

/*
 *获取 Library 文件夹下 Preference 文件夹的路径
 */
+ (NSString *)getLibraryPreferencePath;

/*
 *获取 tmp 临时文件夹的路径
 */
+ (NSString *)getTmpPath;

/*
 *获取一个目录下所有的文件名
 */
+ (NSArray *)getAllFileNamesAtPath:(NSString *)path;

/*
 *创建一个新的文件夹
 */
+ (NSString *)createNewDirectoryWithPath:(NSString *)path andName:(NSString *)name;


/*
 *在目录下写入文件
 */
+ (BOOL)writeFileToPath:(NSString *)path withFileName:(NSString *)fileNmame andFileContent:(NSString *)fileContent;

/*
 *移除一个文件/文件夹
 */
+ (BOOL)removeItemAtPath:(NSString *)path;
@end
