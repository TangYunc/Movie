//
//  ImageDetailTableView.m
//  MyMovie
//
//  Created by zsm on 14-8-22.
//  Copyright (c) 2014年 zsm. All rights reserved.
//

#import "ImageDetailTableView.h"
#import "ImageListModel.h"

@implementation ImageDetailTableView

- (id)initWithFrame:(CGRect)frame style:(UITableViewStyle)style
{
    self = [super initWithFrame:frame style:style];
    if (self) {
        // Initialization code
        //解决手势冲突(代理对象必须是UIScrollView类的对象)
        self.panGestureRecognizer.delegate = self;
        
        //设置代理对象
        self.dataSource = self;
        self.delegate = self;
        //设置背景颜色
        self.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"bg_main.png"]];
        self.backgroundView = nil;
        //去掉分割线
        self.separatorStyle = UITableViewCellSeparatorStyleNone;
        //开启翻页效果
        self.pagingEnabled = YES;
        
        //设置横向
        //1.逆时针旋转
        self.transform = CGAffineTransformMakeRotation(-M_PI_2);
        //2.重新设置frame
        self.frame = frame;
        //3.隐藏滑动指示器
        self.showsHorizontalScrollIndicator = NO;
        self.showsVerticalScrollIndicator = NO;
        //4.设置单元格的高度
        self.rowHeight = kScreenWidth + 20;
    }
    return self;
}

//当视图的内容在屏幕上绘制的时候
- (void)drawRect:(CGRect)rect
{
    [super drawRect:rect];
    NSIndexPath *indexPath = [NSIndexPath indexPathForRow:self.index inSection:0];
    [self scrollToRowAtIndexPath:indexPath atScrollPosition:UITableViewScrollPositionTop animated:NO];
    
    
}
/*
    1.init的时候是不会调用layoutSubviews
    2.addSubView会出发layoutSubviews
    3.view的frame发生了改变的时候会调用layoutSubviews
    4.如果这个视图是scrollView,滚的时候就会调用layoutSubviews
    5.屏幕发生了旋转的时候也会调用layoutSubviews
    6.当一个子视图的frame发生改变的时候也出发layoutSubviews
    7.手动的调用视图的layoutSubviews [self setNeedsLayout];
 */
//先布局子视图 在渲染到屏幕上
//- (void)layoutSubviews
//{
//    [super layoutSubviews];
//    NSIndexPath *indexPath = [NSIndexPath indexPathForRow:self.index inSection:0];
//    [self scrollToRowAtIndexPath:indexPath atScrollPosition:UITableViewScrollPositionTop animated:NO];
//}

#pragma mark - UIScrollView Delegate
- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    //如果滑动的事表示图(我不在执行下面代码)
    if ([scrollView isMemberOfClass:[self class]]) {
        return;
    }
    
    
    if (scrollView.contentOffset.x == 0 || scrollView.contentOffset.x + scrollView.width >= scrollView.contentSize.width) {
        
    } else {
        //获取滑动视图里面的手势对象,并获取位置
        CGPoint point = [scrollView.panGestureRecognizer locationInView:self];
        int index = point.y / 340;
        //固定表示图
        self.contentOffset = CGPointMake(0, index *  340);
    }
    
    
}

#pragma mark - UITableView DataSource
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.dataList.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *identifier = @"imageDetailCellId";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier];
    if (cell == nil) {
        cell = [[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifier] autorelease];
        //去掉单元格的背景颜色
        cell.backgroundColor = [UIColor clearColor];
        cell.backgroundView = nil;
        //取消单元格的选中事件
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        //顺时针旋转单元格
        cell.contentView.transform = CGAffineTransformMakeRotation(M_PI_2);
        //--------------创建子视图------------
        //1.创建小的滑动视图(主要是为了缩放)
        UIScrollView *scrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(10, 0, kScreenWidth, kScreenHeight)];
        //tag
        scrollView.tag = 201;
        //取消弹性效果
        scrollView.bounces = NO;
        //设置缩放比例
        scrollView.minimumZoomScale = 1.0;
        scrollView.maximumZoomScale = 2.0;
        scrollView.delegate = self;
        scrollView.backgroundColor = [UIColor clearColor];
        [cell.contentView addSubview:scrollView];
        //--------------创建图片---------
        UIImageView *imageView = [[UIImageView alloc] initWithFrame:scrollView.bounds];
        //设置填充方式
        imageView.contentMode = UIViewContentModeScaleAspectFit;
        //tag
        imageView.tag = 2014;
        [scrollView addSubview:imageView];
        [imageView release];
    }
#warning 2.现实数据的时候进行修改
    //获取该单元格的数据
    NSString *imageUrl = self.dataList[indexPath.row];
    NSURL *url = [NSURL URLWithString:imageUrl];
    //获取单元格里面的图片视图
    UIImageView *imageView = (UIImageView *)[cell.contentView viewWithTag:2014];
    [imageView setImageWithURL:url];
    
    
    //设置服用的滑动视图取消放大效果
    UIScrollView *scrollView = (UIScrollView *)[cell.contentView viewWithTag:201];
    [scrollView setZoomScale:1.0];
    return cell;
}

#pragma mark - UIScrollView Delegate
- (UIView *)viewForZoomingInScrollView:(UIScrollView *)scrollView
{
    UIImageView *imageView = (UIImageView *)[scrollView viewWithTag:2014];
    return imageView;
}

#pragma mark - UIGestureRecognizer Delegate
//下面的代理方法只要是YES所有的滑动手势都会响应
- (BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldRecognizeSimultaneouslyWithGestureRecognizer:(UIGestureRecognizer *)otherGestureRecognizer
{
    return YES;
}

@end
