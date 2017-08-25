//
//  BaseNavigationController.m
//  MyMovie
//
//  Created by zsm on 14-8-15.
//  Copyright (c) 2014年 zsm. All rights reserved.
//

#import "BaseNavigationController.h"

@interface BaseNavigationController ()

@end

@implementation BaseNavigationController

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
    //取消导航栏的透明效果
    self.navigationBar.translucent = NO;
    
    //设置导航栏的样式
    self.navigationBar.barStyle = UIBarStyleBlack;
    
    //设置导航栏的背景图片
    UIImage *image = [UIImage imageNamed:@"nav_bg_all.png"];
    
    NSLog(@"version:%f",kVersion);
    //判断当前的系统版本
    if (kVersion >= 7.0) {
        //转换成CGImageRef
        CGImageRef imageRef = image.CGImage;
        
        //创建一个CGImageRef变量
        CGImageRef endImageRef = CGImageCreateWithImageInRect(imageRef, CGRectMake(160, 0, kScreenWidth, 64));
        
        //重新给Image赋值
        image = [UIImage imageWithCGImage:endImageRef];
        
        //内存管理
        CGImageRelease(endImageRef);
    }
    [self.navigationBar setBackgroundImage:image forBarMetrics:UIBarMetricsDefault];
    
}

//旋转
- (BOOL)shouldAutorotate
{
    return self.topViewController.shouldAutorotate;
}







@end
