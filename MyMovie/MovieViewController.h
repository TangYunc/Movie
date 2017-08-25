//
//  MovieViewController.h
//  MyMovie
//
//  Created by zsm on 14-8-15.
//  Copyright (c) 2014年 zsm. All rights reserved.
//

#import "BaseViewController.h"
#import "FilterView.h"

@interface MovieViewController : BaseViewController<UITableViewDataSource,UITableViewDelegate,FilterViewDelegate>
{
    IBOutlet UITableView *_tableView;
    
}
@property(nonatomic,retain)NSArray *dataList;
@property(nonatomic,retain)NSArray *visibleDataList;
@property(nonatomic,retain)NSDictionary *mDic;
@end
