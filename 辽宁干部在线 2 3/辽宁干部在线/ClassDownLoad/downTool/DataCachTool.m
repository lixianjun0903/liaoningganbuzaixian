//
//  DataCachTool.m
//  辽宁干部在线
//
//  Created by lixianjun on 15-4-20.
//  Copyright (c) 2015年 中青致学. All rights reserved.
//

#import "DataCachTool.h"

@implementation DataCachTool
/**将模型数组写入plist文件*/
+ (void)arryWriteToFile:(NSString *)fileName baseBody:(id)body
{
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        
        NSString *path = [self filePathWithFileName:fileName];
        //写之前先删除原有数据
        NSFileManager *fileManager = [NSFileManager defaultManager];
        [fileManager removeItemAtPath:path error:nil];
        //写入plist文件
        [[body keyValues] writeToFile:path atomically:YES];
    });
}

/**读取plist文件 返回模型*/
+ (NSArray *)arryReadFromFile:(NSString *)fileName
{
    
    NSString *path = [self filePathWithFileName:fileName];
//    return [NSDictionary dictionaryWithContentsOfFile:path];
  return [NSArray arrayWithObject:path];
    
}
/**判断沙盒文件是否存在*/
+ (BOOL)hasFile:(NSString *)fileName
{
    NSFileManager *fileManager = [NSFileManager defaultManager];
    return [fileManager fileExistsAtPath:[self filePathWithFileName:fileName]];
}

/**获取路径*/
+ (NSString *)filePathWithFileName:(NSString *)fileName
{
    // 获取doc的目录
    NSString *docPath = [NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES) lastObject];
    // 创建目录
    NSFileManager *fileManager = [NSFileManager defaultManager];
    NSString *testDirectory = [docPath stringByAppendingPathComponent:@"RHCaches"];
    [fileManager createDirectoryAtPath:testDirectory withIntermediateDirectories:YES attributes:nil error:nil];
    
    // 拼接保存的路径
    return [docPath stringByAppendingPathComponent:[NSString stringWithFormat:@"RHCaches/%@.plist",fileName]];
}

@end
