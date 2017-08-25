//
//  ListTabelView.h
//  MyMovie
//
//  Created by zsm on 14-8-16.
//  Copyright (c) 2014年 zsm. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ListTabelView : UITableView<UITableViewDataSource,UITableViewDelegate>

@property (nonatomic,retain)NSArray *dataList;
@end
