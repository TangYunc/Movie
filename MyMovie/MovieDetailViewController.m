//
//  MovieDetailViewController.m
//  MyMovie
//
//  Created by zsm on 14-8-23.
//  Copyright (c) 2014年 zsm. All rights reserved.
//

#import "MovieDetailViewController.h"
#import "MovieDetailModel.h"
#import "MovieHeaderView.h"
#import "CommentModel.h"
#import "CommentCell.h"

@interface MovieDetailViewController ()

@end

@implementation MovieDetailViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
        self.isBackButton = YES;
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    //创建字典
    _stateDic = [[NSMutableDictionary alloc] init];
    
    //初始化数据
    [self _loadData];
    
    //初始化子视图
    [self _initViews];
}

//初始化数据
- (void)_loadData
{
    //1.请求电影详情数据
    NSDictionary *result = [WXDataService getJsonDataWithFileName:JK_movie_detail];
    //创建model对象
    _model = [[MovieDetailModel alloc] initWithContentsOfDic:result];
    
    //2.请求该电影评论的数据
    NSDictionary *dic = [WXDataService getJsonDataWithFileName:JK_movie_comment];
    //存储评论条数
    self.commentCount = [[dic objectForKey:@"count"] integerValue];
    NSArray *list = [dic objectForKey:@"list"];
    //把数据转换成数据原型
    NSMutableArray *models = [NSMutableArray array];
    for (NSDictionary *subDic in list) {
        //创建model
        CommentModel *model = [[CommentModel alloc] initWithContentsOfDic:subDic];
        //存放到数组中
        [models addObject:model];
        [model release];
    }
    //保存数据到全局变量中
    self.dataList = models;
    
}

//初始化子视图
- (void)_initViews
{
    //设置表示图的背景
    _tableView.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"bg_main.png"]];
    _tableView.backgroundView = nil;
    
    //设置头视图
    MovieHeaderView *headerView = [[[NSBundle mainBundle] loadNibNamed:@"MovieHeaderView" owner:self options:nil] lastObject];
    headerView.model = self.model;
    _tableView.tableHeaderView = headerView;
}

- (void)dealloc {
    [_tableView release];
    [super dealloc];
}

#pragma mark - UITableView DataSource
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.dataList.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *identifier = @"movieDetailCellId";
    CommentCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier];
    if (cell == nil) {
        cell = [[[NSBundle mainBundle] loadNibNamed:@"CommentCell" owner:self options:nil] lastObject];
        //单元格的背景
        cell.backgroundColor = [UIColor clearColor];
        cell.backgroundView = nil;
    }
    
    //获取单元格对应的数据原型对象
    CommentModel *model = self.dataList[indexPath.row];
    
    cell.model = model;
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    //1.获取当前单元格对应的key
    NSString *key = [NSString stringWithFormat:@"%d",indexPath.row];
    //2.获取单元格的状态
    BOOL isShow = [[_stateDic objectForKey:key] boolValue];
    if (isShow == NO) {
        return 70;
    } else {
        //获取当前单元格现实的文本
        CommentModel *model = self.dataList[indexPath.row];
        CGSize size = [model.content sizeWithFont:[UIFont systemFontOfSize:14.0] constrainedToSize:CGSizeMake(216, 1000)];
        
        return size.height + (70 - 14);
    }
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    //创建头视图
    UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, 20)];
    //设置背景颜色
    label.backgroundColor = [UIColor colorWithRed:1 green:1 blue:1 alpha:.6];
    //设置字体
    label.font = [UIFont boldSystemFontOfSize:14];
    label.textColor = [UIColor orangeColor];
    label.text = [NSString stringWithFormat:@"  共%d条评论",self.commentCount];
    return [label autorelease];
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    //1.获取当前单元格在配置字典里面对应的KEY
    NSString *key = [NSString stringWithFormat:@"%d",indexPath.row];
    //2.获取当前单元格的状态
    BOOL state = [[_stateDic objectForKey:key] boolValue];
    //3.对原有的状态进行改变
    [_stateDic setObject:@(!state) forKey:key];
    //4.刷新(指定集合)单元格
    [tableView reloadRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
}
@end
