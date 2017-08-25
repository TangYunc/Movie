//
//  MovieDetailModel.m
//  MyMovie
//
//  Created by zsm on 14-8-23.
//  Copyright (c) 2014年 zsm. All rights reserved.
//

#import "MovieDetailModel.h"

@implementation MovieDetailModel

- (id)initWithContentsOfDic:(NSDictionary *)dic
{
    self = [super initWithContentsOfDic:dic];
    if (self) {
        self.locationDate = [NSString stringWithFormat:@"%@%@",dic[@"release"][@"location"],dic[@"release"][@"date"]];
    }
    return self;
}
@end
