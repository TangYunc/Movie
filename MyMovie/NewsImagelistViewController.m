//
//  NewsImagelistViewController.m
//  MyMovie
//
//  Created by zsm on 14-8-20.
//  Copyright (c) 2014年 zsm. All rights reserved.
//

#import "NewsImagelistViewController.h"
#import "ImageListModel.h"
#import "ImageDetailViewController.h"
#import "BaseNavigationController.h"

@interface NewsImagelistViewController ()

@end

@implementation NewsImagelistViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
        self.title = @"图片新闻";
        //开启返回按钮
        self.isBackButton = YES;
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
    //初始化数据源
    [self _loadData];
    
    //初始化子视图
    [self _initViews];
}

//初始化子视图
- (void)_initViews
{
    _tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, kScreenHeight - 64) style:UITableViewStylePlain];
    //设置代理对象
    _tableView.dataSource = self;
    _tableView.delegate = self;
    
    //设置背景图片
    _tableView.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"bg_main.png"]];
    _tableView.backgroundView = nil;
    
    //去除分割线
    _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    
    [self.view addSubview:_tableView];
}

//初始化数据源
- (void)_loadData
{
    NSArray *result = [WXDataService getJsonDataWithFileName:JK_image_list];
    //把数据转换成model对象
    NSMutableArray *models = [NSMutableArray array];
    for (NSDictionary *subDic in result) {
        //创建model对象
        ImageListModel *model = [[ImageListModel alloc] initWithContentsOfDic:subDic];
        //model添加到数组中
        [models addObject:model];
        [model release];
    }
    
    self.dataList = models;
    NSLog(@"%@",self.dataList);
    
    /*
        @[@"1",@"2",@"3",@"4",@"5",@"6",@"7"]
        @[@[@"1",@"2",@"3",@"4"],@[@"5",@"6",@"7"]]
     
        @[@[@"1",@"2",@"3",@"5"],@[]]
     */
    //把一维数组整理成二维数组
    
    //创建二维的大数组
    NSMutableArray *data2d = [NSMutableArray array];
    //小数组的指针变量
    NSMutableArray *array2d = nil;
    for (int i = 0; i < self.dataList.count; i++) {
        //每四次创建一个小数组
        if (i % 4 == 0) {
            array2d = [NSMutableArray array];
            //添加到大数组中
            [data2d addObject:array2d];
        }
        
        //数据添加到小数组中
        [array2d addObject:self.dataList[i]];
        
    }
    //把二维数组保存到属性中
    self.data2d = data2d;
    
    
}

#pragma mark - UITableView DataSource
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.data2d.count;
}

- (UITableViewCell *)
tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *identifier = @"imageCellId";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier];
    if (cell == nil) {
        cell = [[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifier] autorelease];
        
        //清楚单元格的背景颜色
        cell.backgroundColor = [UIColor clearColor];
        cell.backgroundView = nil;
        
        //取消选中样式
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        
        //创建图片
        for (int i = 0; i < 4; i++) {
            //创建图片视图
            float width = (kScreenWidth - 50) / 4.0;
            UIImageView *imageView = [[UIImageView alloc] initWithFrame:CGRectMake(i * (width + 10) + 10, 5, width, width)];
            imageView.backgroundColor = [UIColor clearColor];
            imageView.tag = 50 + i;
            [cell.contentView addSubview:imageView];
            [imageView release];
            
            //给图片添加手势
            imageView.userInteractionEnabled = YES;
            //创建手势对象
            UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapAction:)];
            [imageView addGestureRecognizer:tap];
            [tap release];
        }
    }
    //获取当前单元格对应的小数组
    NSArray *array2d = [self.data2d objectAtIndex:indexPath.row];
    
    for (int i = 0; i < array2d.count; i++) {
        //获取数组里面的model对象
        ImageListModel *model = array2d[i];
        NSURL *url= [NSURL URLWithString:model.image];
        //获取对应的图像视图
        UIImageView *imageView = (UIImageView *)[cell.contentView viewWithTag:50 + i];
        //设置图片
        [imageView setImageWithURL:url];
//        [imageView setHidden:NO];
    }
    
    for (NSInteger i = array2d.count; i < 4; i++) {
        //获取对应的图像视图
        UIImageView *imageView = (UIImageView *)[cell.contentView viewWithTag:50 + i];
        imageView.image = nil;
//        [imageView setHidden:YES];
        
    }
    
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return (kScreenWidth - 50) / 4.0 + 10;
}

#pragma mark - UITap Action
- (void)tapAction:(UITapGestureRecognizer *)tap
{
    CGPoint point = [tap locationInView:_tableView];
    NSInteger rowIndex = point.y / ((kScreenWidth - 50) / 4.0 + 10);
    NSInteger lIndex = point.x / ((kScreenWidth - 50) / 4.0 + 10);
    //获取图片的位置索引
    NSInteger index = rowIndex * 4 + lIndex;
    
    //创建图片详情视图
    ImageDetailViewController *imageDetailVC = [[ImageDetailViewController alloc] init];
    //传值
    imageDetailVC.index = index;
    
#warning 1.整理数据
    //整理数据
    NSMutableArray *imageUrls = [NSMutableArray array];
    for (int i = 0; i < self.dataList.count; i++) {
        ImageListModel *model = self.dataList[i];
        [imageUrls addObject:model.image];
    }
    imageDetailVC.dataList = imageUrls;
    
    //创建导航控制器
    UINavigationController *navCtrl = [[UINavigationController alloc] initWithRootViewController:imageDetailVC];
    //设置导航栏的样式
    navCtrl.navigationBar.barStyle = UIBarStyleBlackTranslucent;
    //通过模态视图打开控制器
    [self presentViewController:navCtrl animated:YES completion:nil];
    //释放
    [navCtrl release];
    [imageDetailVC release];
}



@end
