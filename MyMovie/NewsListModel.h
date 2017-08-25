//
//  NewsListModel.h
//  MyMovie
//
//  Created by zsm on 14-8-20.
//  Copyright (c) 2014年 zsm. All rights reserved.
//

/*
     {
         "id" : 1491520,
         "type" : 0,
         "title" : "科幻大作《全面回忆》全新预告片发布",
         "summary" : "",
         "image" : "http://img31.mtime.cn/mg/2012/06/28/100820.21812355.jpg"
     }
 */

#import <Foundation/Foundation.h>

@interface NewsListModel : NSObject

@property (nonatomic,copy)NSNumber *newsId;
@property (nonatomic,copy)NSNumber *type;
@property (nonatomic,copy)NSString *title;
@property (nonatomic,copy)NSString *summary;
@property (nonatomic,copy)NSString *image;

- (id)initWithContentsOfDic:(NSDictionary *)dic;
@end
