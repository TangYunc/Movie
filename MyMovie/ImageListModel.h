//
//  ImageListModel.h
//  MyMovie
//
//  Created by zsm on 14-8-20.
//  Copyright (c) 2014年 zsm. All rights reserved.
//

/*
     {
         "id": 2238621,
         "image": "http://img31.mtime.cn/pi/2013/02/04/093444.29353753_1280X720.jpg",
         "type": 6
     }
 */
#import <Foundation/Foundation.h>
#import "BaseModel.h"
@interface ImageListModel : BaseModel

@property(nonatomic,copy)NSNumber *imageId;
@property(nonatomic,copy)NSString *image;
@property(nonatomic,copy)NSNumber *type;
@end
