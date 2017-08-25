//
//  AppDelegate.m
//  MyMovie
//
//  Created by zsm on 14-8-15.
//  Copyright (c) 2014年 zsm. All rights reserved.
//

#import "AppDelegate.h"
#import "MainTabBarController.h"

@implementation AppDelegate

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    _window = [[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
    // Override point for customization after application launch.
    self.window.backgroundColor = [UIColor blackColor];
    
    //创建标签控制器
    MainTabBarController *mainTVC = [[MainTabBarController alloc] init];
    
    //给window作为根视图控制器
    self.window.rootViewController = [mainTVC autorelease];
    
    //设置状态栏的样式
    [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleBlackOpaque];
    
    //显示window并设置成主window
    [self.window makeKeyAndVisible];
    
    return YES;
}


@end
