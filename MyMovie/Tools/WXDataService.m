//
//  WXDataService.m
//  MyMovie
//
//  Created by zsm on 14-8-16.
//  Copyright (c) 2014年 zsm. All rights reserved.
//

#import "WXDataService.h"
#import "JSONKit.h"
@implementation WXDataService

//通过文件的名字解析出里面的内容
+ (id)getJsonDataWithFileName:(NSString *)fileName
{
    
    //获取json文件的路径
    NSString *path = [[[NSBundle mainBundle] resourcePath] stringByAppendingPathComponent:fileName];
    
    //获取文件里面的内容
    NSData *jsonData = [NSData dataWithContentsOfFile:path];
    
    //json解析
    if (kVersion >= 5.0) {
        //使用系统的方法解析
        id result = [NSJSONSerialization JSONObjectWithData:jsonData options:NSJSONReadingMutableContainers error:nil];
        
        return result;
    } else {
        //使用jsonKit
        id result = [jsonData objectFromJSONData];
        return result;
    }
    
    
}
@end
