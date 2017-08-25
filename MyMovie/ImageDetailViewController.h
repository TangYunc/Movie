//
//  ImageDetailViewController.h
//  MyMovie
//
//  Created by zsm on 14-8-22.
//  Copyright (c) 2014年 zsm. All rights reserved.
//

#import "BaseViewController.h"
#import "ImageDetailTableView.h"

@interface ImageDetailViewController : BaseViewController<UITableViewDataSource,UITableViewDelegate,UIGestureRecognizerDelegate>
{
    ImageDetailTableView *_tableView;
}
@property (nonatomic,assign)NSInteger index;    //图片在数组中的索引位置
@property (nonatomic,retain)NSArray *dataList;  //所有的图片数据的数组
@end
