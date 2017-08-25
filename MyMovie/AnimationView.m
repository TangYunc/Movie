//
//  AnimationView.m
//  MyMovie
//
//  Created by zsm on 14-8-26.
//  Copyright (c) 2014年 zsm. All rights reserved.
//

#import "AnimationView.h"

@implementation AnimationView

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
    
    //获取文件的路径
    NSString *filePath = [NSHomeDirectory() stringByAppendingFormat:@"/Documents/fistAnimation.plist"];
    NSDictionary *dic = [NSDictionary dictionaryWithContentsOfFile:filePath];
    if (dic == nil) {
        //第一次打开应用程序
        //第一次的动画效果
        [self _firstAnimation];
        
        
        //把这个文件写入,下次就不是第一打开了
        dic = @{@"first":@YES};
        [dic writeToFile:filePath atomically:YES];
    } else {
        //不是第一次打开应用程序
        NSLog(@"不是第一次打开应用程序");
        
        //默认的都动画效果
        [self _defaultAnimation];
    }
    
    
}

//默认的都动画效果
- (void)_defaultAnimation
{
    //一.设置背景图片 当前屏幕是3.5 还是4.0
    NSString *imageName = kScreenHeight == 480 ? @"Default.png" : @"Default-568h.png";
    //创建背景视图
    UIImageView *bgImageView = [[UIImageView alloc] initWithFrame:self.bounds];
    bgImageView.image = [UIImage imageNamed:imageName];
    [self addSubview:bgImageView];
    [bgImageView release];
    
    //二.创建小图片视图
    //1.获取图片个个数,和大小
    //行数和列数
    int lineNum = 4;
    int rowNum = kScreenHeight == 480 ? 6 : 7;
    //图片的宽度
    float imageWidth = kScreenWidth / 4.0;
    float imageHeight = kScreenHeight / rowNum;
    //图片的个数
    _imageCount = lineNum * rowNum;
    
    //定义当前图片的坐标
    float x = 0;
    float y = 0;
    //循环创建小图片
    NSMutableArray *imageViews = [NSMutableArray array];
    for (int i = 0; i < _imageCount; i++) {
        UIImageView *imageView = [[UIImageView alloc] initWithFrame:CGRectMake(x, y, imageWidth, imageHeight)];
        //隐藏图片
        imageView.alpha = 0;
        imageView.image = [UIImage imageNamed:[NSString stringWithFormat:@"%d.png",i + 1]];
        //添加到视图上
        [self addSubview:imageView];
        //保存到数组中
        [imageViews addObject:imageView];
        
        //释放
        [imageView release];
        
        if (i < lineNum - 1) {
            x += imageWidth;
        } else if (i < (lineNum - 1) + (rowNum - 1)) {
            y += imageHeight;
        } else if (i < (lineNum - 1) * 2 + (rowNum - 1)) {
            x -= imageWidth;
        } else if (i < (lineNum - 1) * 2 + (rowNum - 1) * 2 - 1) {
            y -= imageHeight;
        } else if (i < (lineNum - 1) * 3 + (rowNum - 1) * 2 - 2) {
            x += imageWidth;
        } else if (i < (lineNum - 1) * 3 + (rowNum - 1) * 3 - 4) {
            y += imageHeight;
        } else if (i < (lineNum - 1) * 4 + (rowNum - 1) * 3 - 6) {
            x -= imageWidth;
        } else {
            y -= imageHeight;
        }
    }
    
    //小图片的数组保存到属性中
    self.imageViews = imageViews;
    
    //开始显示图片
    [self showAnimationImageView];
    
}

//开始显示图片
- (void)showAnimationImageView
{
    [UIView animateWithDuration:.15 animations:^{
        UIImageView *imageView = self.imageViews[index];
        imageView.alpha = 1;
    }];
    
    index++;
    if (index < _imageCount) {
        [self performSelector:@selector(showAnimationImageView) withObject:nil afterDelay:.1];
    } else {
        //动画结束把当前视图移除掉
        [self performSelector:@selector(removeFromSuperview) withObject:nil afterDelay:1.5];
    }
    
}

//第一次的动画效果
- (void)_firstAnimation
{
    self.backgroundColor = [UIColor clearColor];
    //1.创建滑动视图
    _scrollView = [[UIScrollView alloc] initWithFrame:self.bounds];
    _scrollView.backgroundColor = [UIColor clearColor];
    //设置翻页效果
    _scrollView.pagingEnabled = YES;
    //取消滑动指示器
    _scrollView.showsHorizontalScrollIndicator = NO;
    _scrollView.showsVerticalScrollIndicator = NO;
    //关闭弹性效果
    _scrollView.bounces = NO;
    //设置代理对象
    _scrollView.delegate = self;
    
    //滑动视图现实的所有的图片
    NSArray *imageNames = @[@"guide1.png",@"guide2.png",@"guide3.png",@"guide4.png",@"guide5.png"];
    //设置内容视图的大小
    _scrollView.contentSize = CGSizeMake(kScreenWidth * (imageNames.count + 1), _scrollView.height);
    //设置内容的视图
    for (int i = 0; i < imageNames.count; i++) {
        //创建图片视图
        UIImageView *imageView = [[UIImageView alloc]initWithFrame:CGRectMake(i * kScreenWidth, 0, kScreenWidth, self.height)];
        //设置图片
        imageView.image = [UIImage imageNamed:imageNames[i]];
        //添加到视图上
        [_scrollView addSubview:imageView];
        [imageView release];
    }
    
    //把滑动视图添加到视图上
    [self addSubview:_scrollView];
    
    
    //2.创建页码视图 173 × 26
    _pageImageView = [[UIImageView alloc] initWithFrame:CGRectMake((kScreenWidth - 86.5) / 2.0,  self.height - 13 - 30, 86.5, 13)];
    _pageImageView.image = [UIImage imageNamed:@"guideProgress1.png"];
    [self addSubview:_pageImageView];
    
}

#pragma mark - UIScrollView Delegate
- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    //获取当前的页数索引
    NSInteger pageIndex = scrollView.contentOffset.x / kScreenWidth;
    NSString *pageImageName = [NSString stringWithFormat:@"guideProgress%d.png",pageIndex + 1];
    _pageImageView.image = [UIImage imageNamed:pageImageName];
    
    //超出图片视图部分,页码视图跟着滑动
    if (scrollView.contentOffset.x >= 4 * kScreenWidth) {
        NSLog(@"-------------");
        //超出图片的宽度
        float width = scrollView.contentOffset.x - 4 * kScreenWidth;
        
        _pageImageView.left = (kScreenWidth - 86.5) / 2.0 - width;
    }
    
    //判断当前偏移量为最大值的时候
//    if (scrollView.contentOffset.x + scrollView.width == scrollView.contentSize.width) {
//        
//    }
    if (pageIndex == 5) {
        [self performSelector:@selector(removeFromSuperview) withObject:nil afterDelay:.1];
    }
}

- (void)dealloc
{
    NSLog(@"动画视图销毁了");
    [_imageViews release];
    _imageViews = nil;
    
    [_scrollView release];
    _scrollView = nil;
    
    [_pageImageView release];
    _pageImageView = nil;
    
    [super dealloc];
}


@end
