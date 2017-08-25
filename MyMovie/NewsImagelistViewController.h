//
//  NewsImagelistViewController.h
//  MyMovie
//
//  Created by zsm on 14-8-20.
//  Copyright (c) 2014年 zsm. All rights reserved.
//

#import "BaseViewController.h"

@interface NewsImagelistViewController : BaseViewController<UITableViewDataSource,UITableViewDelegate>
{
    UITableView *_tableView;
}

@property(nonatomic,retain)NSArray *dataList;
@property(nonatomic,retain)NSArray *data2d;
@end
