//
//  MovieModel.m
//  MyMovie
//
//  Created by zsm on 14-8-16.
//  Copyright (c) 2014年 zsm. All rights reserved.
//



#import "MovieModel.h"

@implementation MovieModel

- (NSString *)description
{
    NSString *string = [NSString stringWithFormat:@"title:%@,year:%@",self.title,self.year];
    return string;
}

- (void)dealloc
{
    [_title release];
    _title = nil;
    
    [_images_large release];
    _images_large = nil;
    
    //释放...
    [super dealloc];
}
@end
