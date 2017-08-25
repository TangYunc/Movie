//
//  PosterView.h
//  MyMovie
//
//  Created by zsm on 14-8-18.
//  Copyright (c) 2014年 zsm. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "PosterBodyTableView.h"
#import "PosterHeaderTableView.h"
@interface PosterView : UIView
{
    PosterBodyTableView *_postBodyTableView;    //大的海报视图
    UILabel *_bottomLabel;                      //电影标题底部的文本
    UIView *_maskView;                          //遮罩视图
    UIImageView *_headerView;                   //头部视图
    PosterHeaderTableView *_posterHeaderTableView;//头部视图的海报视图
}

@property(nonatomic,retain)NSArray *dataList;
@end
