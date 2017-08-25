//
//  WXRatingView.m
//  MyMovie
//
//  Created by zsm on 14-8-16.
//  Copyright (c) 2014年 zsm. All rights reserved.
//

#import "WXRatingView.h"
#import "UIViewExt.h"
#define kStarHeight 33
#define kStarWidth 35
@implementation WXRatingView

- (id)initWithFrame:(CGRect)frame
          textColor:(UIColor *)textColor
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
        
        //计算缩放比例  (当前视图的高度 * . 6)  / 33
        float scale = self.height * .6 / 33;
        
        //创建子视图
        //1.创建灰色星星视图
        _grayView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, kStarWidth * 5, kStarHeight)];
        //设置背景图片
        _grayView.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"gray.png"]];
        //按照比例进行缩放
        _grayView.transform = CGAffineTransformMakeScale(scale, scale);
        //重新设置位置
        _grayView.left = 0;
        _grayView.top = self.height * .2;
        [self addSubview:_grayView];
        
        //2.创建黄色星星视图
        _yellowView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, kStarWidth * 5, kStarHeight)];
        //设置背景图片
        _yellowView.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"yellow.png"]];
        //按照比例进行缩放
        _yellowView.transform = CGAffineTransformMakeScale(scale, scale);
        //重新设置位置
        _yellowView.left = 0;
        _yellowView.top = self.height * .2;
        [self addSubview:_yellowView];
        
        //---------------------文本--------------------
        //3.个位
        _unitLabel = [[UILabel alloc] initWithFrame:CGRectMake(_grayView.right + 10, self.height * .25, self.height * .75 * .6, self.height * .75)];
        _unitLabel.backgroundColor = [UIColor clearColor];
        _unitLabel.textColor = textColor;
        _unitLabel.font = [UIFont fontWithName:@"Bodoni 72" size:_unitLabel.height];
        _unitLabel.text = @"8";
        [self addSubview:_unitLabel];
        
        //4.创建点文本
        UILabel *pointLabel = [[UILabel alloc] initWithFrame:CGRectMake(_unitLabel.right, 0, self.height * .3, self.height)];
        pointLabel.backgroundColor = [UIColor clearColor];
        pointLabel.textColor = textColor;
        pointLabel.text = @"·";
        pointLabel.font = [UIFont boldSystemFontOfSize:self.height];
        [self addSubview:pointLabel];
        [pointLabel release];
        
        //5.小数位
        _dotLabel = [[UILabel alloc] initWithFrame:CGRectMake(pointLabel.right , 0, self.height * .75 * .6, self.height * .75)];
        _dotLabel.backgroundColor = [UIColor clearColor];
        _dotLabel.textColor = textColor;
        _dotLabel.font = [UIFont fontWithName:@"Bodoni 72" size:_unitLabel.height];
        _dotLabel.text = @"6";
        [self addSubview:_dotLabel];
        
        //设置自身的宽度
        self.width = _dotLabel.right;
        
    }
    return self;
}

//重写set方法
- (void)setAverage:(NSNumber *)average
{
    if (_average != average) {
        [_average release];
        _average = [average copy];
        
        
        double score = [_average doubleValue];
        //设置黄色星星视图的宽度
        _yellowView.width = _grayView.width * score * .1;
        
        //直接给文本去显示
        NSString *scoreString = [NSString stringWithFormat:@"%.1f",score];
        
        _unitLabel.text = [scoreString substringToIndex:1];
        _dotLabel.text = [scoreString substringFromIndex:2];
        
    }
}


- (void)dealloc
{
    [_average release];
    _average = nil;
    
    
    
    [super dealloc];
}


@end
