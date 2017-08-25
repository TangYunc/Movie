//
//  WXSlider.m
//  MyMovie
//
//  Created by zsm on 14-9-17.
//  Copyright (c) 2014年 zsm. All rights reserved.
//

#import "WXSlider.h"
#define VALUE_SCALE(value,min,max) (value - min) / (max - min)
@implementation WXSlider
- (id)init
{
    self = [super init];
    if (self) {
        [self _initViews];
    }
    return self;
}

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
        //初始化子视图
        [self _initViews];
    }
    return self;
}

//初始化子视图
- (void)_initViews
{
    //1.初始化属性
    _value = 0;
    _minValue = 0;
    _maxValue = 1.0;
    self.backgroundColor = [UIColor clearColor];
    
    //2.创建左侧视图
    _minView = [[UIImageView alloc] initWithFrame:CGRectZero];
    _minView.contentMode = UIViewContentModeScaleToFill;
    _minView.backgroundColor = [UIColor blueColor];
    [self addSubview:_minView];
    
    //3.创建右侧视图
    _maxView = [[UIImageView alloc] initWithFrame:CGRectZero];
    _maxView.contentMode = UIViewContentModeScaleToFill;
    _maxView.backgroundColor = [UIColor grayColor];
    [self addSubview:_maxView];
    
    //4.创建滑块视图
    _thumbView = [[UIImageView alloc] initWithFrame:CGRectZero];
    [self addSubview:_thumbView];
    
    //默认的样式
    UIImage *thumbImage = [UIImage imageNamed:@"point.png"];
    UIImage *minImage = [UIImage imageNamed:@"progress_blue_bar.png"];
    minImage = [minImage stretchableImageWithLeftCapWidth:2 topCapHeight:1];
    UIImage *maxImage = [UIImage imageNamed:@"line.png"];
    maxImage = [maxImage stretchableImageWithLeftCapWidth:2 topCapHeight:1];
    
    //设置图片到视图上
    self.thumbImage = thumbImage;
    self.minimunImage = minImage;
    self.maximunImage = maxImage;
    
}

#pragma mark - 重写set方法设置图片
- (void)setThumbImage:(UIImage *)thumbImage
{
    if (_thumbImage != thumbImage) {
        [_thumbImage release];
        _thumbImage = [thumbImage retain];
        
        //设置到视图上
        _thumbView.backgroundColor = [UIColor clearColor];
        _thumbView.image = _thumbImage;
    }
}

- (void)setMinimunImage:(UIImage *)minimunImage
{
    if (_minimunImage != minimunImage) {
        [_minimunImage release];
        _minimunImage = [minimunImage retain];
        
        //设置图片
        _minView.backgroundColor = [UIColor clearColor];
        _minView.image = _minimunImage;
        
    }
}

- (void)setMaximunImage:(UIImage *)maximunImage
{
    if (_maximunImage != maximunImage) {
        [_maximunImage release];
        _maximunImage = [maximunImage retain];
        
        //设置图片
        _maxView.backgroundColor = [UIColor clearColor];
        _maxView.image = _maximunImage;
        
    }
}

#pragma mark - Touch tracking
//是否开始跟踪
- (BOOL)beginTrackingWithTouch:(UITouch *)touch withEvent:(UIEvent *)event
{

    //获取手指在当前空间里点击的位置
    CGPoint firstPoint = [touch locationInView:self];

    //判断一个点是否在一个视图上
    return  CGRectContainsPoint(_thumbView.frame, firstPoint);
}

//正在跟踪
- (BOOL)continueTrackingWithTouch:(UITouch *)touch withEvent:(UIEvent *)event
{
    //获取当前手指的位置
    CGPoint touchPoint = [touch locationInView:self];
    //设置value
    [self moveValueWithPoint:touchPoint];
    //是否时时发送消息
    if (_isJS_sender) {
        //发送事件
        [self sendActionsForControlEvents:UIControlEventValueChanged];
    }
    return YES;
}

- (void)endTrackingWithTouch:(UITouch *)touch withEvent:(UIEvent *)event
{
    //获取当前手指的位置
    CGPoint touchPoint = [touch locationInView:self];
    //设置value
    [self moveValueWithPoint:touchPoint];
    
    //发送事件
    [self sendActionsForControlEvents:UIControlEventValueChanged];
}

//传进来一个坐标，滑块跟着移动
- (void)moveValueWithPoint:(CGPoint )point
{
    if (self.direction == WXSliderDirectionVertica) {
        //设置滑动条的起点
        float start_y = _thumbImage.size.height / 2;
        float lineLenght = self.frame.size.height - _thumbImage.size.height;
        if (point.y < start_y) {
            point.y = start_y;
        }
        
        if (point.y > self.frame.size.height - start_y ) {
            point.y = self.frame.size.height - start_y;
        }
        
        float scale = (lineLenght - (point.y - start_y)) / lineLenght;
        //计算实际的Value
        self.value = (_maxValue - _minValue) * scale + _minValue;
    } else {
        //设置滑动条的起点
        float start_x = _thumbImage.size.width / 2;
        float lineLenght = self.frame.size.width - _thumbImage.size.width;
        if (point.x < start_x) {
            point.x = start_x;
        }
        
        if (point.x > self.frame.size.width - start_x ) {
            point.x = self.frame.size.width - start_x;
        }
        
        float scale = (point.x - start_x) / lineLenght;
        //计算实际的Value
        self.value = (_maxValue - _minValue) * scale + _minValue;
    }
    
    
}

#pragma mark - 重写value的set方法
- (void)setValue:(float)value
{
    _value = MIN(_maxValue, MAX(_minValue, value));
    [self setNeedsLayout];
}

//- (void)setMinValue:(float)minValue
//{
//    _minValue = minValue;
//    if (_value < _minValue) {
//        _value = _minValue;
//    }
//}
//
//- (void)setMaxValue:(float)maxValue
//{
//    _maxValue = MAX(_minValue, maxValue);
//    if (_value > _maxValue) {
//        _value = _maxValue;
//    }
//}

- (void)setDirection:(WXSliderDirection)direction
{
    _direction = direction;
    
    if (_direction == WXSliderDirectionVertica) {
        UIImage *maxImage = [UIImage imageNamed:@"line_h.png"];
        maxImage = [maxImage stretchableImageWithLeftCapWidth:2 topCapHeight:1];
        self.maximunImage = maxImage;
    }
}

- (void)layoutSubviews
{
    [super layoutSubviews];
    if (self.direction == WXSliderDirectionVertica) {
        //设置滑动条的起点
        float start_y = _thumbImage.size.height / 2;
#warning 图片的位置问题
        float start_x = (self.frame.size.width - _minimunImage.size.width) / 2.0 ;
        float lineLenght = self.frame.size.height - _thumbImage.size.height;
        //value在这个视图中的比例
        float scale = VALUE_SCALE(_value, _minValue, _maxValue);
        
        //设置左侧视图的大小和位置
        _minView.frame = CGRectMake(start_x, start_y + lineLenght - lineLenght * scale, _minimunImage.size.width, lineLenght * scale);
        
        //设置右侧侧视图的大小和位置
        _maxView.frame = CGRectMake((self.frame.size.width - _maximunImage.size.width) / 2.0, start_y, _maximunImage.size.width, lineLenght * (1 - scale));
        
        //设置按钮的位置和大小
        _thumbView.frame = CGRectMake(0, 0, _thumbImage.size.width, _thumbImage.size.height);
        _thumbView.center = CGPointMake(self.frame.size.width / 2.0, (start_y + lineLenght) - lineLenght * scale);
    } else {
        //设置滑动条的起点
        float start_x = _thumbImage.size.width / 2;
#warning 图片的位置问题
        float start_y = (self.frame.size.height - _minimunImage.size.height) / 2.0 + 1;
        float lineLenght = self.frame.size.width - _thumbImage.size.width;
        //value在这个视图中的比例
        float scale = VALUE_SCALE(_value, _minValue, _maxValue);
        
        //设置左侧视图的大小和位置
        _minView.frame = CGRectMake(start_x, start_y, lineLenght *scale, _minimunImage.size.height);
        
        //设置右侧侧视图的大小和位置
        _maxView.frame = CGRectMake(start_x + lineLenght *scale, start_y, lineLenght - lineLenght *scale, _maximunImage.size.height);
        
        //设置按钮的位置和大小
        _thumbView.frame = CGRectMake(0, 0, _thumbImage.size.width, _thumbImage.size.height);
        _thumbView.center = CGPointMake(start_x + scale *lineLenght, self.frame.size.height / 2.0);
    }
    
    
    
}

- (void)dealloc
{
    [_thumbImage release];
    _thumbImage = nil;
    
    [_maximunImage release];
    _maximunImage = nil;
    
    [_minimunImage release];
    _minimunImage = nil;
    
    [_thumbView release];
    _thumbView = nil;
    
    [_minView release];
    _minView = nil;
    
    [_maxView release];
    _maxView = nil;
    [super dealloc];
}

@end
