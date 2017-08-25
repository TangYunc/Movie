//
//  WXRatingView.h
//  MyMovie
//
//  Created by zsm on 14-8-16.
//  Copyright (c) 2014年 zsm. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface WXRatingView : UIView
{
    //灰色星星视图
    UIView *_grayView;
    
    //黄色星星视图
    UIView *_yellowView;
    
    //分数
    UILabel *_unitLabel;    //各位
    
    UILabel *_dotLabel;     //小数位
    
}

@property (nonatomic,copy)NSNumber *average;

//自定义初始化方法
- (id)initWithFrame:(CGRect)frame
          textColor:(UIColor *)textColor;

@end
