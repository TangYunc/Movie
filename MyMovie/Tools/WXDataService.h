//
//  WXDataService.h
//  MyMovie
//
//  Created by zsm on 14-8-16.
//  Copyright (c) 2014年 zsm. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface WXDataService : NSObject

//通过文件的名字解析出里面的内容
+ (id)getJsonDataWithFileName:(NSString *)fileName;
@end
