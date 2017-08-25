//
//  MovieModel.h
//  MyMovie
//
//  Created by zsm on 14-8-16.
//  Copyright (c) 2014年 zsm. All rights reserved.
//

/*
     {
         "box" : 27361000,
         "new" : true,
         "subject" : {
             "rating" : {
                 "stars" : "40",
                 "average" : 7.3,
                 "min" : 0,
                 "max" : 10
                 },
             "collect_count" : 49,
             "images" : {
                 "small" : "http:\/\/img3.douban.com\/view\/photo\/icon\/public\/p1943399384.jpg",
                 "large" : "http:\/\/img3.douban.com\/view\/photo\/photo\/public\/p1943399384.jpg",
                 "medium" : "http:\/\/img3.douban.com\/view\/photo\/thumb\/public\/p1943399384.jpg"
                 },
             "id" : "3170961",
             "alt" : "http:\/\/movie.douban.com\/subject\/3170961\/",
             "title" : "双枪",
             "subtype" : "movie",
             "year" : "2013",
             "original_title" : "2 Guns"
             },
         "rank" : 1
     }
 */

#import <Foundation/Foundation.h>

@interface MovieModel : NSObject

@property(nonatomic,copy)NSString *title;           //电影的标题
@property(nonatomic,copy)NSString *original_title;  //英文标题
@property(nonatomic,copy)NSString *year;            //年份
@property(nonatomic,copy)NSNumber *average;         //评分
@property(nonatomic,copy)NSString *images_small;    //小图
@property(nonatomic,copy)NSString *images_medium;   //中图
@property(nonatomic,copy)NSString *images_large;    //大图
@end
