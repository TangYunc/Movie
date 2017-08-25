//
//  NewsViewController.m
//  MyMovie
//
//  Created by zsm on 14-8-15.
//  Copyright (c) 2014年 zsm. All rights reserved.
//

#import "NewsViewController.h"
#import "NewsListModel.h"
#import "NewsListCell.h"
#import "NewsImagelistViewController.h"
#import "CommonViewController.h"

@interface NewsViewController ()

@end

@implementation NewsViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
        self.title = @"新闻";
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
    //初始化数据
    [self _loadData];
    
    //初始化子视图
    [self _initViews];
}

//初始化数据
- (void)_loadData
{
    NSArray *result = [WXDataService getJsonDataWithFileName:JK_news_list];
    
    //把数据转换成数据原型对象
    NSMutableArray *models = [NSMutableArray array];
    for (NSDictionary *subDic in result) {
        //创建数据原型对象
        NewsListModel *model = [[NewsListModel alloc] initWithContentsOfDic:subDic];
        //存放到数组中
        [models addObject:model];
        [model release];
    }
    
    //保存到控制器的属性中
    self.dataList = models;
//    _dataList = models; //错误的
    NSLog(@"%@",self.dataList);
    
}

//初始化子视图
- (void)_initViews
{
    //创建表视图
    _tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, kScreenHeight - 64 - 49) style:UITableViewStylePlain];
    //设置代理
    _tableView.dataSource = self;
    _tableView.delegate = self;
    
    //设置背景颜色
    _tableView.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"bg_main.png"]];
    _tableView.backgroundView = nil;
    
    //添加到视图上
    [self.view addSubview:_tableView];
}

#pragma mark - UITableView DataSource
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.dataList.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    //如果是第一个单元格
    if (indexPath.row == 0) {
        static NSString *headerIdentifier = @"newslistHeaderCellId";
        UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:headerIdentifier];
        if (cell == nil) {
            cell = [[[NSBundle mainBundle] loadNibNamed:@"NewsListHeaderCell" owner:self options:nil] lastObject];
        }
        //获取当前单元格对应的数据原型对象
        NewsListModel *model = [self.dataList objectAtIndex:indexPath.row];
        //设置图片
        UIImageView *imageView = (UIImageView *)[cell.contentView viewWithTag:101];
        [imageView setImageWithURL:[NSURL URLWithString:model.image]];
        //设置标题
        UILabel *label = (UILabel *)[cell.contentView viewWithTag:102];
        label.text = model.title;
        
        return cell;
    } else {
        static NSString *identifier = @"newslistCellId";
        NewsListCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier];
        if (cell == nil) {
            cell = [[[NSBundle mainBundle] loadNibNamed:@"NewsListCell" owner:self options:nil] lastObject];
        }
        //获取当前单元格对应的数据原型对象
        NewsListModel *model = [self.dataList objectAtIndex:indexPath.row];
        
        cell.model = model;
        return cell;
    }
    
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.row == 0) {
        return 150;
    } else {
        return 85;
    }
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    //获取当前单元格现实的数据
    NewsListModel *model = self.dataList[indexPath.row];
    
    //获取新闻类型
    NSInteger typeId = [model.type integerValue];
    if (typeId == 0) {
        //普通新闻
        CommonViewController *commonVC = [[CommonViewController alloc] init];
        [self.navigationController pushViewController:commonVC animated:YES];
        [commonVC release];
        
    } else if (typeId == 1) {
        //图片新闻
        NewsImagelistViewController *newsImageListVC = [[NewsImagelistViewController alloc] init];
        [self.navigationController pushViewController:newsImageListVC animated:YES];
        //释放
        [newsImageListVC release];
    } else {
        //视频新闻
    }
}













@end
