//
//  MainTabBarController.m
//  MyMovie
//
//  Created by zsm on 14-8-15.
//  Copyright (c) 2014年 zsm. All rights reserved.
//

#import "MainTabBarController.h"
#import "HomeViewController.h"
#import "NewsViewController.h"
#import "TopViewController.h"
#import "MoreViewController.h"
#import "MovieViewController.h"
#import "BaseNavigationController.h"
#import "TabBarItem.h"
#import "AnimationView.h"

//hahahah
@interface MainTabBarController ()

@end

@implementation MainTabBarController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view.
    //创建Push动画对象
    _pushAnimation = [[PushAnimation alloc] init];
    _popAnimation = [[PopAnimation alloc] init];
    
    //初始化所有的子视图控制器
    [self _initViewControllers];
    
    //自定义标签栏
    [self _customTabBar];
    
    //添加动画视图
    AnimationView *animationView = [[AnimationView alloc] initWithFrame:self.view.bounds];
    [self.view addSubview:animationView];
    [animationView release];
}

//自定义标签栏
- (void)_customTabBar
{
    
    //1.创建标签栏视图
    _tabBarView = [[UIView alloc] initWithFrame:CGRectMake(0, kScreenHeight - 49, kScreenWidth, 49)];
    //设置背景图片
    _tabBarView.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"tab_bg_all.png"]];
    
    //添加到根视图上
    [self.view addSubview:_tabBarView];
    
    //2.创建选中的背景图片
    _selectedImageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, 42, 42)];
    _selectedImageView.image = [UIImage imageNamed:@"selectTabbar_bg_all1.png"];
    //添加到标签栏上
    [_tabBarView addSubview:_selectedImageView];
    
    //3.创建标签栏上的按钮
    NSArray *titles = @[@"首页",@"新闻",@"TOP",@"影院",@"更多"];
    NSArray *imageNames = @[@"movie_home.png",@"msg_new.png",@"start_top250.png",@"icon_cinema",@"more_setting"];
    for (int i = 0; i < titles.count; i++) {
        //创建按钮
        float width = kScreenWidth / titles.count;
        TabBarItem *item = [[TabBarItem alloc] initWithFrame:CGRectMake(i * width, 0, width, 49)
                                                   imageName:imageNames[i]
                                                       title:titles[i]];
        //tag
        item.tag = i;
        //添加事件
        [item addTarget:self action:@selector(itemAction:) forControlEvents:UIControlEventTouchUpInside];
        //添加到标签栏上
        [_tabBarView addSubview:item];
        [item release];
        
        //设置选中图片的默认位置
        if (i == 0) {
            _selectedImageView.center = item.center;
        }
    }
    
}

//初始化所有的子视图控制器
-(void)_initViewControllers
{
    //首页
    HomeViewController *homeVC = [[HomeViewController alloc] init];
    
    //新闻
    NewsViewController *newsVC = [[NewsViewController alloc] init];
    
    //TOP
    TopViewController *topVC = [[TopViewController alloc] init];
    
    //影院
    MovieViewController *movieVC = [[MovieViewController alloc] init];
    
    //更多
    MoreViewController *moreVC = [[MoreViewController alloc] init];
    
    //创建一个数组存方法所有的子视图控制器
    NSArray *viewControllers = @[homeVC,newsVC,topVC,movieVC,moreVC];
    
    //循环创建导航控制器
    //创建一个存储导航控制器的数组
    NSMutableArray *navCtrls = [[NSMutableArray alloc] init];
    for (int i = 0; i < viewControllers.count; i++) {
        //创建导航控制器
        BaseNavigationController *baseNav = [[BaseNavigationController alloc] initWithRootViewController:viewControllers[i]];
        
        //设置导航控制器的代理对象
        baseNav.delegate = self;
        
        //导航控制器添加到数组中
        [navCtrls addObject:baseNav];
        
        //释放导航控制器
        [baseNav release];
    }
    
    //把导航控制器作为子视图控制器现实在标签控制器上
    self.viewControllers = navCtrls;
    
    //释放
    [homeVC release];
    [newsVC release];
    [topVC release];
    [movieVC release];
    [moreVC release];
    
    [navCtrls release];
    
}

#pragma mark - Item Action
- (void)itemAction:(TabBarItem *)item
{
    self.selectedIndex = item.tag;
    
    //属性动画
    [UIView beginAnimations:nil context:nil];
    [UIView setAnimationDuration:.35];
    
    //改变背景图片的位置
    _selectedImageView.center = item.center;
    [UIView commitAnimations];
}

#pragma mark - UINavigationController Delegate
- (void)navigationController:(UINavigationController *)navigationController willShowViewController:(UIViewController *)viewController animated:(BOOL)animated
{
    //判断当前导航控制器将要导航到第几个控制器
    if (navigationController.viewControllers.count == 1) {
        [UIView beginAnimations:nil context:nil];
        [UIView setAnimationDuration:.35];
        _tabBarView.left = 0;
        
        [UIView commitAnimations];
    } else if (navigationController.viewControllers.count == 2) {
        [UIView beginAnimations:nil context:nil];
        [UIView setAnimationDuration:.35];
        _tabBarView.right = 0;
        [UIView commitAnimations];
    }
}

//7.0之后出的一个协议方法,用来自定义导航动画的
- (id<UIViewControllerAnimatedTransitioning>)navigationController:(UINavigationController *)navigationController
                                  animationControllerForOperation:(UINavigationControllerOperation)operation
                                               fromViewController:(UIViewController *)fromVC
                                                 toViewController:(UIViewController *)toVC
{
    //区分动画效果
    if (operation == UINavigationControllerOperationPush) {
        //执行PUSH动画
        return _pushAnimation;
    } else if (operation == UINavigationControllerOperationPop) {
        //执行POP动画
        return _popAnimation;
    }
    
    return nil;
}

//旋转
- (BOOL)shouldAutorotate
{
    return self.selectedViewController.shouldAutorotate;
}


















@end
