//
//  MovieDetailViewController.h
//  MyMovie
//
//  Created by zsm on 14-8-23.
//  Copyright (c) 2014年 zsm. All rights reserved.
//

#import "BaseViewController.h"
@class MovieDetailModel;
@interface MovieDetailViewController : BaseViewController<UITableViewDataSource,UITableViewDelegate>

{
    IBOutlet UITableView *_tableView;
    NSMutableDictionary *_stateDic; //当前单元格的高度配置字典
    
}
@property(nonatomic,retain)MovieDetailModel *model; //头视图数据原型
@property(nonatomic,assign)NSInteger commentCount;  //评论数
@property(nonatomic,retain)NSArray *dataList;       //评论数据
@end
