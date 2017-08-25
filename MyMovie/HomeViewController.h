//
//  HomeViewController.h
//  MyMovie
//
//  Created by zsm on 14-8-15.
//  Copyright (c) 2014年 zsm. All rights reserved.
//

#import "BaseViewController.h"
#import "ListTabelView.h"
#import "PosterView.h"
@interface HomeViewController : BaseViewController
{
    PosterView *_posterView;            //海报视图
    ListTabelView *_listTableView;    //列表视图
}

@property (nonatomic,retain)NSArray *dataList;
@end
