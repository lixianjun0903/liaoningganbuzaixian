//
//  DataCachTool.h
//  辽宁干部在线
//
//  Created by lixianjun on 15-4-20.
//  Copyright (c) 2015年 中青致学. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface DataCachTool : NSObject
/**将模型数组写入plist文件*/
+ (void)arryWriteToFile:(NSString *)fileName baseBody:(id)body;

/**读取plist文件 返回模型*/
+ (NSArray *)arryReadFromFile:(NSString *)fileName;

/**判断沙盒文件是否存在*/
+ (BOOL)hasFile:(NSString *)fileName;
///**获取路径*/
//+ (NSString *)filePathWithFileName:(NSString *)fileName;

@end
