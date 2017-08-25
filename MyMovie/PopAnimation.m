//
//  PopAnimation.m
//  MyMovie
//
//  Created by zsm on 14-8-15.
//  Copyright (c) 2014年 zsm. All rights reserved.
//

#import "PopAnimation.h"

@implementation PopAnimation
//动画时间
- (NSTimeInterval)transitionDuration:(id <UIViewControllerContextTransitioning>)transitionContext
{
    return .35;
}


//自定义动画效果
- (void)animateTransition:(id <UIViewControllerContextTransitioning>)transitionContext
{
    //1.获取将要显示的视图控制器
    UIViewController *toViewController = [transitionContext viewControllerForKey:UITransitionContextToViewControllerKey];
    toViewController.view.right = 0;
    //手动的把将要显示控制器的根视图添加的视图上
    [[transitionContext containerView] addSubview:toViewController.view];
    
    //2.获取当前现实的视图控制器
    UIViewController *fromViewController = [transitionContext viewControllerForKey:UITransitionContextFromViewControllerKey];
    
    
    [UIView animateWithDuration:[self transitionDuration:transitionContext] animations:^{
        //设置动画效果
        fromViewController.view.left = kScreenWidth;
        toViewController.view.left = 0;
    } completion:^(BOOL finished) {
        //动画结束调用的
        
        //需要结束导航动画
        [transitionContext completeTransition:![transitionContext transitionWasCancelled]];
    }];
}
@end
