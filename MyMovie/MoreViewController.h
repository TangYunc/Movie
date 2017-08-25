//
//  MoreViewController.h
//  MyMovie
//
//  Created by zsm on 14-8-15.
//  Copyright (c) 2014年 zsm. All rights reserved.
//

#import "BaseViewController.h"

@interface MoreViewController : BaseViewController<UITableViewDataSource,UITableViewDelegate,UIAlertViewDelegate>
{
    NSArray *_titles;
    NSArray *_imageNames;
    UITableView *_tableView;
}
@end
