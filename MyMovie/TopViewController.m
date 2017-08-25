//
//  TopViewController.m
//  MyMovie
//
//  Created by zsm on 14-8-15.
//  Copyright (c) 2014年 zsm. All rights reserved.
//

#import "TopViewController.h"
#import "MovieModel.h"
#import "TopCell.h"
#import "MovieDetailViewController.h"

@interface TopViewController ()

@end

@implementation TopViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
        self.title = @"TOP250";
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
    //初始化数据
    [self _loadData];
    
    //创建子视图
    [self _initViews];
}

//创建子视图
- (void)_initViews
{
    //控制UICollectionView 的样式和布局等
    UICollectionViewFlowLayout *layout = [[UICollectionViewFlowLayout alloc] init];
    //1.设置每个item的大小
    layout.itemSize = CGSizeMake(kScreenWidth / 3.0, 150);
    
    //2.设置滑动方向
//    layout.scrollDirection = UICollectionViewScrollDirectionVertical;
    
    //3.设置头视图的大小
//    layout.headerReferenceSize = CGSizeMake(kScreenWidth, 100);
    
    //4.设置行的间距
    layout.minimumLineSpacing = 0;
    
    //5.设置列的间距
    layout.minimumInteritemSpacing = 0;
    
    _collectionView = [[UICollectionView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, kScreenHeight - 64 - 49) collectionViewLayout:layout];
    
    //设置代理对象
    _collectionView.dataSource = self;
    _collectionView.delegate = self;
    
    //取消滑动指示器
    _collectionView.showsHorizontalScrollIndicator = NO;
    _collectionView.showsVerticalScrollIndicator = NO;
    
    //设置背景
    _collectionView.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"bg_main.png"]];
    _collectionView.backgroundView = nil;
    
    //设置item的重用类
    [_collectionView registerClass:[TopCell class]     forCellWithReuseIdentifier:@"TopCellId"];
    //设置组的头视图重用类
//    [_collectionView registerClass:[UICollectionReusableView class] forSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:@"headerId"];
    
    
    [self.view addSubview:_collectionView];
    [layout release];
}

//初始化数据
- (void)_loadData
{
    NSDictionary *result = [WXDataService getJsonDataWithFileName:JK_top250];
    NSArray *subjects = result[@"subjects"];
    //创建一个可变数组存放model
    NSMutableArray *models = [NSMutableArray array];
    for (NSDictionary *subDic in subjects) {
        //创建model
        MovieModel *model = [[MovieModel alloc] init];
        //赋值
        model.title = subDic[@"title"];
        model.average = subDic[@"rating"][@"average"];
        model.images_small = subDic[@"images"][@"small"];
        
        //添加到数组中
        [models addObject:model];
        [model release];
    }
    
    //把数据存放到全局变量中
    self.dataList = models;
    
}

#pragma mark - UICollectionView Delegate
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    return self.dataList.count;
}

// The cell that is returned must be retrieved from a call to -dequeueReusableCellWithReuseIdentifier:forIndexPath:
- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    //如果有闲置的就拿到使用,如果没有,系统自动的去创建
    TopCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"TopCellId" forIndexPath:indexPath];
    //获取对应视图的model数据
    MovieModel *model = [self.dataList objectAtIndex:indexPath.row];
    cell.model = model;
    //手动的调用layoutSubviews
    [cell setNeedsLayout];
    return cell;
}

//item的点击事件
- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    NSLog(@"点击了item");
    //获取选中item的数据
    MovieModel *model = self.dataList[indexPath.row];
    //创建电影详情控制器
    MovieDetailViewController *movieDetailVC = [[MovieDetailViewController alloc] init];
    movieDetailVC.title = model.title;
    //导航
    [self.navigationController pushViewController:movieDetailVC animated:YES];
    [movieDetailVC release];
}

//设置组的头视图和尾视图
//- (UICollectionReusableView *)collectionView:(UICollectionView *)collectionView viewForSupplementaryElementOfKind:(NSString *)kind atIndexPath:(NSIndexPath *)indexPath
//{
//    UICollectionReusableView *headerView = [collectionView dequeueReusableSupplementaryViewOfKind:kind withReuseIdentifier:@"headerId" forIndexPath:indexPath];
//    headerView.backgroundColor = [UIColor orangeColor];
//    return headerView;
//}

#pragma mark - UICollectionViewDelegateFlowLayout
//任意的设置item的大小
//- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath
//{
//    return CGSizeMake(indexPath.row * 20, 100);
//}
@end
