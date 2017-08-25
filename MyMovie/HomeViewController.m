//
//  HomeViewController.m
//  MyMovie
//
//  Created by zsm on 14-8-15.
//  Copyright (c) 2014年 zsm. All rights reserved.
//

#import "HomeViewController.h"
#import "MovieModel.h"

@interface HomeViewController ()

@end

@implementation HomeViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
        self.title = @"首页";
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

    
    //打印数组
    NSLog(@"dataList:%@",self.dataList);
}

//初始化数据
- (void)_loadData
{
    //获取电影数据
     NSDictionary *dic = [WXDataService getJsonDataWithFileName:JK_us_box];
    
    //获取电影信息列表数据
    NSArray *subjects = [dic objectForKey:@"subjects"];
//    NSLog(@"subjects = %@",subjects);
    //把数组里面的字典整理成我们想要的数据原型对象
    //创建一个可变数组(存放model)
    NSMutableArray *models = [[NSMutableArray alloc] init];
    for (NSDictionary *subDic in subjects) {
        //创建数据原型对象
        MovieModel *model = [[MovieModel alloc] init];
        //给数据原型对象里面的属性进行赋值
        model.title = subDic[@"subject"][@"title"];
        model.original_title = subDic[@"subject"][@"original_title"];
        model.year = subDic[@"subject"][@"year"];
        model.images_small = subDic[@"subject"][@"images"][@"small"];
        model.images_medium = subDic[@"subject"][@"images"][@"medium"];
        model.images_large = subDic[@"subject"][@"images"][@"large"];
        model.average = subDic[@"subject"][@"rating"][@"average"];
        
        //把model对象添加到数组中
        [models addObject:model];
        [model release];
    }
    
    self.dataList = models;
    
    //释放
    [models release];
}

//初始化子视图
- (void)_initViews
{
    //1.创建列表视图
    _listTableView = [[ListTabelView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, kScreenHeight - 20 - 49 - 44) style:UITableViewStylePlain];
    //把数据给表示图对象
    _listTableView.dataList = self.dataList;
    [self.view addSubview:_listTableView];
    
    //2.创建海报视图
    _posterView = [[PosterView alloc] initWithFrame:_listTableView.bounds];
    _posterView.backgroundColor = [UIColor grayColor];
    //吧数据给海报视图
    _posterView.dataList = self.dataList;
    [self.view addSubview:_posterView];
    
   
    //3.创建右侧的导航按钮
    [self _initRightBarButtonItem];
}

//创建右侧的导航按钮
- (void)_initRightBarButtonItem
{
    //------------------创建导航按钮----------------------
    UIView *rightItem = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 50, 30)];
    rightItem.backgroundColor = [UIColor clearColor];
    //1.创建海报按钮
    UIButton *posterButton = [UIButton buttonWithType:UIButtonTypeCustom];
    posterButton.frame = rightItem.bounds;
    //tag
    posterButton.tag = 100;
    //设置背景图片
    [posterButton setBackgroundImage:[UIImage imageNamed:@"exchange_bg_home.png"] forState:UIControlStateNormal];
    //设置标题图片
    [posterButton setImage:[UIImage imageNamed:@"poster_home.png"] forState:UIControlStateNormal];
    //添加事件
    [posterButton addTarget:self action:@selector(rightBarButtonItemAction:) forControlEvents:UIControlEventTouchUpInside];
    [rightItem addSubview:posterButton];
    
    //2.创建列表按钮
    UIButton *listButton = [UIButton buttonWithType:UIButtonTypeCustom];
    listButton.frame = rightItem.bounds;
    //tag
    listButton.tag = 101;
    //设置背景图片
    [listButton setBackgroundImage:[UIImage imageNamed:@"exchange_bg_home.png"] forState:UIControlStateNormal];
    //设置标题图片
    [listButton setImage:[UIImage imageNamed:@"list_home.png"] forState:UIControlStateNormal];
    //添加事件
    [listButton addTarget:self action:@selector(rightBarButtonItemAction:) forControlEvents:UIControlEventTouchUpInside];
    [rightItem addSubview:listButton];
    
    //创建导航按钮
    UIBarButtonItem *rightBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:rightItem];
    self.navigationItem.rightBarButtonItem = rightBarButtonItem;
    
    //释放
    [rightItem release];
    [rightBarButtonItem release];
}


#pragma mark - RightBarButtonItem Action
- (void)rightBarButtonItemAction:(UIButton *)button
{
    //判断向那个方向旋转
    BOOL isRight = button.tag == 101 ? YES : NO;
    
    //切换海报和列表视图
    [self exchangeSubviewWithSuperView:self.view isRight:isRight];
    
    //切换海报和列表的按钮
    [self exchangeSubviewWithSuperView:button.superview isRight:isRight];
    
}

//根据父视图旋转切换子视图
- (void)exchangeSubviewWithSuperView:(UIView *)superView isRight:(BOOL)isRight
{
    [UIView beginAnimations:nil context:nil];
    [UIView setAnimationDuration:.35];
    [UIView setAnimationTransition:isRight ? UIViewAnimationTransitionFlipFromLeft : UIViewAnimationTransitionFlipFromRight forView:superView cache:YES];

    //切换该视图两个子视图的索引位置
    [superView exchangeSubviewAtIndex:0 withSubviewAtIndex:1];

    [UIView commitAnimations];
}




@end
