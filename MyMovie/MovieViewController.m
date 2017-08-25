//
//  MovieViewController.m
//  MyMovie
//
//  Created by zsm on 14-8-15.
//  Copyright (c) 2014年 zsm. All rights reserved.
//

#import "MovieViewController.h"
#import "CinemaListModel.h"
#import "CinemaCell.h"
#import "MBProgressHUD.h"
#import "FilterView.h"

@interface MovieViewController ()

@end

@implementation MovieViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
        self.title = @"影院";
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
    //初始化数据
//    [self _loadData];
    
    //初始化子视图
    [self _initViews];
    
    
    //模仿网络请求
    [self performSelector:@selector(afterLoadData) withObject:nil afterDelay:2.0];
    
    
    
}
//初始化子视图
- (void)_initViews
{
    //设置表示图的背景颜色
    _tableView.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"bg_main.png"]];
    _tableView.backgroundView = nil;
    //刚开始加载的时候,因为没有数据,是隐藏的
    _tableView.hidden = YES;
    _tableView.height = kScreenHeight - 64 - 49 - 35;
    _tableView.top = 35;
    
    
    
    //------------下拉刷新控件------------
    UIRefreshControl *refreshControl = [[UIRefreshControl alloc] initWithFrame:CGRectMake(0, -_tableView.height, _tableView.width, _tableView.height)];
    //添加文本
    refreshControl.attributedTitle = [[[NSAttributedString alloc] initWithString:@"下拉刷新"] autorelease];
    //设置颜色
    refreshControl.tintColor = [UIColor redColor];
    
    //添加事件
    [refreshControl addTarget:self action:@selector(refreshAction:) forControlEvents:UIControlEventValueChanged];
    //添加到表视图上
    [_tableView addSubview:refreshControl];
    
    
    //-------------自定义筛选视图----------------
    [self _initFilterView];
    
    //-------------加载提示-------------------
    MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    hud.tag = 500;
    //提示文本
    hud.labelText = @"正在加载...";
    //是否有遮罩
    hud.dimBackground = YES;
}

//自定义筛选视图
- (void)_initFilterView
{
    //-------------自定义筛选视图----------------
    //1.获取城区数据
    NSDictionary *result = [WXDataService getJsonDataWithFileName:JK_district_list];
    //存放省区的数组
    NSArray *districtList = [result objectForKey:@"districtList"];
    /*
     [   {
     "name" : "东城区",
     "id" : "1029"
     }, {
     "name" : "西城区",
     "id" : "1011"
     }
     ]
     
     @{
     @"东城区":@"1029",
     @"西城区":@"1011"
     }
     */
    //创建一个可变的字典
    NSMutableDictionary *mDic = [NSMutableDictionary dictionary];
    //便利数组
    for (NSDictionary *subDic in districtList) {
        NSString *name = subDic[@"name"];
        NSString *identifier = subDic[@"id"];
        //存到字典里面
        [mDic setObject:identifier forKey:name];
    }
    
    //存放到属性里面
    self.mDic = mDic;
    
    //2.自定义视图
    FilterView *filterView = [[[NSBundle mainBundle] loadNibNamed:@"FilterView" owner:self options:nil] lastObject];
    //设置代理对象
    filterView.delegate = self;
    //设置文本
    
    NSArray *array = @[@"全部"];
    array = [array arrayByAddingObjectsFromArray:[mDic allKeys]];
    NSArray *items = @[array,@[@"全部",@"价格升序",@"价格降序"]];
    filterView.items = items;
    [self.view addSubview:filterView];
}

//初始化数据
- (void)_loadData
{
    //请求影院列表
    NSDictionary *result = [WXDataService getJsonDataWithFileName:JK_cinema_list];
    NSArray *cinemaList = [result objectForKey:@"cinemaList"];
    //转换成数据原型对象
    NSMutableArray *models = [NSMutableArray array];
    for (NSDictionary *subDic in cinemaList) {
        //创建数据原型对象
        CinemaListModel *model = [[CinemaListModel alloc] initWithContentsOfDic:subDic];
        //添加到数组中
        [models addObject:model];
        [model release];
    }
    
    self.dataList = models;
    self.visibleDataList = models;
}

- (void)dealloc {
    [_tableView release];
    [super dealloc];
}
#pragma mark UIRefreshControl Action
- (void)refreshAction:(UIRefreshControl *)refreshControl
{
    NSLog(@"刷新数据了");
    [refreshControl performSelector:@selector(endRefreshing) withObject:nil afterDelay:2];
}

#pragma mark - 模仿网络请求2秒之后加载完成
- (void)afterLoadData
{
    //获取数据
    [self _loadData];
    
    //1.刷新表视图
    [_tableView reloadData];
    //2.显示表视图
    _tableView.hidden = NO;
    
    //3.关闭hud
    MBProgressHUD *hud = (MBProgressHUD *)[self.view viewWithTag:500];
    hud.labelText = @"加载完成";
    [hud hide:YES afterDelay:.5];
}
     
#pragma mark - UITableView DataSource
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.visibleDataList.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *identifier = @"cinemaCellId";
    CinemaCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier];
    if (cell == nil) {
        cell = [[[NSBundle mainBundle] loadNibNamed:@"CinemaCell" owner:self options:nil] lastObject];
        
    }
    //获取单元格对应的数据
    CinemaListModel *model = self.visibleDataList[indexPath.row];
    cell.model = model;
    
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 80;
}

#pragma mark - FilterView Delegate
- (void)filterView:(FilterView *)filterView
didSelectItemOfIndexPath:(NSIndexPath *)indexPath
         itemTitle:(NSString *)itemTitle
AllSelectedIndexPaths:(NSArray *)selectedIndexPaths
        itemTitles:(NSArray *)itemTitles
{
    NSLog(@"indexPath:%@",indexPath);
    NSLog(@"itemTitle:%@",itemTitle);
    NSLog(@"selectedIndexPaths:%@",selectedIndexPaths);
    NSLog(@"itemTitles:%@",itemTitles);
    
    //判断第一个表示图所选的内容
    if ([itemTitles[0] isEqualToString:@"全部"]) {
        self.visibleDataList = self.dataList;
    } else {
        //谓词
        NSString *string = [NSString stringWithFormat:@"self.districtId = '%@'",self.mDic[itemTitles[0]]];
        NSPredicate *predicate = [NSPredicate predicateWithFormat:string];
        self.visibleDataList = [self.dataList filteredArrayUsingPredicate:predicate];
    }
    
    if ([itemTitles[1] isEqualToString:@"全部"]) {
        
    } else if ([itemTitles[1] isEqualToString:@"价格升序" ]) {
        //排序
        self.visibleDataList = [self.visibleDataList sortedArrayUsingComparator:^NSComparisonResult(id obj1, id obj2) {
            CinemaListModel *model1 = (CinemaListModel *)obj1;
            CinemaListModel *model2 = (CinemaListModel *)obj2;
            
            double lowPrice1 = [model1.lowPrice doubleValue];
            double lowPrice2 = [model2.lowPrice doubleValue];
            if (lowPrice1 > lowPrice2) {
                return NSOrderedDescending;
            } else if (lowPrice1 < lowPrice2) {
                return NSOrderedAscending;
            } else {
                return NSOrderedSame;
            }
            
        }];
    } else {
        //排序
        self.visibleDataList = [self.visibleDataList sortedArrayUsingComparator:^NSComparisonResult(id obj1, id obj2) {
            CinemaListModel *model1 = (CinemaListModel *)obj1;
            CinemaListModel *model2 = (CinemaListModel *)obj2;
            
            if ([model1.lowPrice isKindOfClass:[NSNull class]]) {
                model1.lowPrice = @"00.00";
            }
            if ([model2.lowPrice isKindOfClass:[NSNull class]]) {
                model2.lowPrice = @"00.00";
            }
            
            double lowPrice1 = [model1.lowPrice doubleValue];
            double lowPrice2 = [model2.lowPrice doubleValue];
            if (lowPrice1 > lowPrice2) {
                return NSOrderedAscending;
            } else if (lowPrice1 < lowPrice2) {
                return NSOrderedDescending;
            } else {
                return NSOrderedSame;
            }
            
        }];
    }
    
    //刷新
    [_tableView reloadData];
    
}
@end
