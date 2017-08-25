//
//  MainTabBarController.h
//  MyMovie
//
//  Created by zsm on 14-8-15.
//  Copyright (c) 2014年 zsm. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "PushAnimation.h"
#import "PopAnimation.h"
@interface MainTabBarController : UITabBarController<UINavigationControllerDelegate>
{
    UIView *_tabBarView;        //自定义的标签栏
    UIImageView *_selectedImageView;    //选中按钮的背景图片
    
    //创建动画对象
    PushAnimation *_pushAnimation;
    PopAnimation *_popAnimation;
}
@end
