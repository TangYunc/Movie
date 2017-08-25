//
//  ImageListModel.m
//  MyMovie
//
//  Created by zsm on 14-8-20.
//  Copyright (c) 2014年 zsm. All rights reserved.
//

#import "ImageListModel.h"

@implementation ImageListModel

//1.适合个别的几个内容映射不进去

//- (id)initWithContentsOfDic:(NSDictionary *)dic
//{
//    self = [super initWithContentsOfDic:dic];
//    if (self) {
//        self.imageId = dic[@"id"];
//    }
//    return self;
//}

//2.重写映射关系
- (NSDictionary *)keyToAtt:(NSDictionary *)dic
{
    return @{@"id":@"imageId",@"image":@"image",@"type":@"type"};
}


- (void)dealloc
{
    //释放...
    [super dealloc];
}


- (NSString *)description
{
    return [NSString stringWithFormat:@"imageId:%@,image:%@,type:%@",self.imageId,self.image,self.type];
}
@end
