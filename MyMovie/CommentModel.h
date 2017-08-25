//
//  CommentModel.h
//  MyMovie
//
//  Created by zsm on 14-8-25.
//  Copyright (c) 2014年 zsm. All rights reserved.
//
/*
    {
        "userImage" : "http://img2.mtime.com/images/default/head.gif",
        "nickname" : "yangna988",
        "rating" : "9.0",
        "content" : "儿子很喜欢 一直期盼上映"
    }
 */
#import "BaseModel.h"

@interface CommentModel : BaseModel

@property(nonatomic,copy)NSString *userImage;
@property(nonatomic,copy)NSString *nickname;
@property(nonatomic,copy)NSString *rating;
@property(nonatomic,copy)NSString *content;
@end
