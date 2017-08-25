//
//  ImageDetailViewController.m
//  MyMovie
//
//  Created by zsm on 14-8-22.
//  Copyright (c) 2014年 zsm. All rights reserved.
//

#import "ImageDetailViewController.h"
#import "ImageListModel.h"

@interface ImageDetailViewController ()

@end

@implementation ImageDetailViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
        self.title = @"图片详情";
        //开启返回按钮
        self.isBackButton = YES;
        
        //如果SDK是7.0
        if (kVersion >= 7.0) {
            //取消由于导航栏透明引起的自动填充效果
            self.automaticallyAdjustsScrollViewInsets = NO;
        }
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view.
    self.view.backgroundColor = [UIColor redColor];
    
    //初始化子视图
    [self _initViews];
    
    //添加单机事件
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapAction:)];
    [self.view addGestureRecognizer:tap];
    [tap release];
}

//初始化子视图
- (void)_initViews
{
    //创建表视图
    CGRect frame = CGRectMake(-10, 0, kScreenWidth + 20, kScreenHeight);
    _tableView = [[ImageDetailTableView alloc] initWithFrame:frame style:UITableViewStylePlain];
    //传数据
    _tableView.dataList = self.dataList;
    _tableView.index = self.index;
    
    [self.view addSubview:_tableView];
}



//重写父类的放回方法
- (void)backAction:(UIButton *)button
{
    //关闭模态视图
    [self dismissViewControllerAnimated:YES completion:nil];
}



#pragma mark - 视图点击事件(收起和方向导航栏)
- (void)tapAction:(UITapGestureRecognizer *)tap
{
//    NSLog(@"adf");
    //判断当前导航栏的状态
    BOOL isShow = self.navigationController.navigationBarHidden;
    
    //取当前状态的反值
  
    
    //隐藏状态栏
    [[UIApplication sharedApplication] setStatusBarHidden:!isShow withAnimation:UIStatusBarAnimationSlide];
    
    //隐藏导航栏
    [self.navigationController setNavigationBarHidden:!isShow animated:YES];
    //使用视图控制器对象去设置状态栏隐藏
//    if (kVersion >= 7.0) {
//        [self prefersStatusBarHidden];
//        //刷新状态栏
//        [self setNeedsStatusBarAppearanceUpdate];
//    }

}
/*
    View controller-based status bar appearance :默认是 YES
    如果是NO:让应用程序对象(UIApplication去控制所有状态栏的设置)
 */
- (BOOL)prefersStatusBarHidden
{
    return self.navigationController.navigationBarHidden;
}


@end
