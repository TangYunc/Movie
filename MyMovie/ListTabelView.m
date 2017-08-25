//
//  ListTabelView.m
//  MyMovie
//
//  Created by zsm on 14-8-16.
//  Copyright (c) 2014年 zsm. All rights reserved.
//

#import "ListTabelView.h"
#import "MovieModel.h"
#import "ListCell.h"

@implementation ListTabelView

#warning 重点
//重点*****************子类化表示图的时候(一定改初始化方法)
- (id)initWithFrame:(CGRect)frame style:(UITableViewStyle)style
{
    self = [super initWithFrame:frame style:style];
    if (self) {
        // Initialization code
        //设置代理对象
        self.dataSource = self;
        self.delegate = self;
        
        //设置高度
        self.rowHeight = 120;
        
        //设置分割线的颜色
        self.separatorColor = [UIColor grayColor];
        
        //设置背景图片
        self.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"bg_main.png"]];
        self.backgroundView = nil;
    }
    return self;
}

#pragma mark - UITableView DataSource
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.dataList.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *identifier = @"listCellId";
    ListCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier];
    if (cell == nil) {
        cell = [[[ListCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifier] autorelease];
    }
    //获取当前单元格的model对象
    MovieModel *model = self.dataList[indexPath.row];
    cell.model = model;
    return cell;
}

@end
