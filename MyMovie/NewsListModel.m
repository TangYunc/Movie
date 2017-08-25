//
//  NewsListModel.m
//  MyMovie
//
//  Created by zsm on 14-8-20.
//  Copyright (c) 2014年 zsm. All rights reserved.
//

#import "NewsListModel.h"

@implementation NewsListModel

- (id)initWithContentsOfDic:(NSDictionary *)dic
{
    self = [super init];
    if (self != nil) {
        //就给自身的属性赋值
        self.newsId = dic[@"id"];
        self.type = dic[@"type"];
        self.title = dic[@"title"];
        self.summary = dic[@"summary"];
        self.image = dic[@"image"];
    }
    return self;
}


- (void)dealloc
{
    //释放...
    
    [super dealloc];
}


- (NSString *)description
{
    return [NSString stringWithFormat:@"title:%@,tpye:%@",self.title,self.type];
}
@end
