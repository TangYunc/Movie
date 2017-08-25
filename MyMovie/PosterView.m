//
//  PosterView.m
//  MyMovie
//
//  Created by zsm on 14-8-18.
//  Copyright (c) 2014年 zsm. All rights reserved.
//

#import "PosterView.h"
#import "MovieModel.h"

@implementation PosterView

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
    //1.创建海报的内容视图
    [self _initPosterBodyTableView];
    
    //2.底部的文本视图现实电影标题
    [self _initBottomLabel];
    
    //3.创建灯光视图
    [self _initLightView];
    
    //4.创建遮罩视图
    [self _initMaskView];
    
    //5.创建头部视图
    [self _initHeaderView];
    
    //6.添加下啦手势
    UISwipeGestureRecognizer *swipe = [[UISwipeGestureRecognizer alloc] initWithTarget:self action:@selector(downHeaderView)];
    //轻扫方向
    swipe.direction = UISwipeGestureRecognizerDirectionDown;
    [self addGestureRecognizer:swipe];
    [swipe release];
    
    //7.添加观察者
//    [_posterHeaderTableView addObserver:self forKeyPath:@"selectedIndexPath" options:NSKeyValueObservingOptionNew context:nil];
    [_postBodyTableView addObserver:self forKeyPath:@"selectedIndexPath" options:NSKeyValueObservingOptionNew context:nil];
}

//1.创建海报的内容视图
- (void)_initPosterBodyTableView
{
    CGRect frame = CGRectMake(0, 30, kScreenWidth, kScreenHeight - 64 - 49 - 30 - 40);
    _postBodyTableView = [[PosterBodyTableView alloc] initWithFrame:frame style:UITableViewStylePlain];
    [self addSubview:_postBodyTableView];
}

//2.底部的文本视图现实电影标题
- (void)_initBottomLabel
{
    _bottomLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, _postBodyTableView.bottom + 5, kScreenWidth, 35)];
    //设置背景图片
    _bottomLabel.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"poster_title_home.png"]];
    _bottomLabel.textColor = [UIColor whiteColor];
    _bottomLabel.textAlignment = NSTextAlignmentCenter;
    _bottomLabel.font = [UIFont boldSystemFontOfSize:16.0];
    _bottomLabel.text = @"双枪 2";
    [self addSubview:_bottomLabel];
}

//3.创建灯光视图
- (void)_initLightView
{
    //124 * 204
    //创建左侧灯光视图
    UIImageView *leftLightView = [[UIImageView alloc] initWithFrame:CGRectMake(15, 5, 124, 204)];
    leftLightView.backgroundColor = [UIColor clearColor];
    leftLightView.image = [UIImage imageNamed:@"light.png"];
    [self addSubview:leftLightView];
    [leftLightView release];
    
    //创建右侧灯光视图
    UIImageView *rightLightView = [[UIImageView alloc] initWithFrame:CGRectMake(15, 5, 124, 204)];
    rightLightView.right = kScreenWidth - 15;
    rightLightView.backgroundColor = [UIColor clearColor];
    rightLightView.image = [UIImage imageNamed:@"light.png"];
    [self addSubview:rightLightView];
    [rightLightView release];
}

//4.创建遮罩视图
- (void)_initMaskView
{
    _maskView = [[UIView alloc] initWithFrame:self.bounds];
    _maskView.backgroundColor = [UIColor blackColor];
    _maskView.alpha = 0;
    [self addSubview:_maskView];
    
    //添加点击事件
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(upHeaderView)];
    [_maskView addGestureRecognizer:tap];
    [tap release];
    
    //添加一个上拉事件
    UISwipeGestureRecognizer *swipe = [[UISwipeGestureRecognizer alloc] initWithTarget:self action:@selector(upHeaderView)];
    swipe.direction = UISwipeGestureRecognizerDirectionUp;
    [_maskView addGestureRecognizer:swipe];
    [swipe release];
}

//5.创建头部视图
- (void)_initHeaderView
{
    _headerView = [[UIImageView alloc] initWithFrame:CGRectMake(0, -100, kScreenWidth, 125)];
    //事件开启
    _headerView.userInteractionEnabled = YES;
    //设置背景图片
    UIImage *image = [UIImage imageNamed:@"indexBG_home.png"];
    //设置图片的拉伸位置
    image = [image stretchableImageWithLeftCapWidth:0 topCapHeight:5];
    _headerView.image = image;
    [self addSubview:_headerView];
    
    //---------------创建子视图-------------------
    //1.小的海报列表视图
    _posterHeaderTableView = [[PosterHeaderTableView alloc] initWithFrame:CGRectMake(0, 10, kScreenWidth, 90) style:UITableViewStylePlain];
    [_headerView addSubview:_posterHeaderTableView];
    
    //2.创建一个按钮
    UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
    button.frame = CGRectMake((kScreenWidth - 13)/2.0, 105, 13, 13);
    button.tag = 123;
    [button setImage:[UIImage imageNamed:@"down_home.png"] forState:UIControlStateNormal];
    [button addTarget:self action:@selector(exchangeShowHeaderView) forControlEvents:UIControlEventTouchUpInside];
    [_headerView addSubview:button];
    
}

#pragma mark - 重写set方法,当控制器把数据给PoseterView的时候,PosterView马上就把数据转交给_postBodyTableView
- (void)setDataList:(NSArray *)dataList
{
    if (_dataList != dataList) {
        [_dataList release];
        _dataList = [dataList retain];
        
        //设置电影的标题
        MovieModel *model = _dataList[0];
        _bottomLabel.text = model.title;
        
        //把数据给表示图进行显示
        _postBodyTableView.dataList = _dataList;
        _posterHeaderTableView.dataList = _dataList;
    }
}

#pragma mark - 收起或者放下头视图
- (void)exchangeShowHeaderView
{
    if (_headerView.top == 0) {
        //当前状态是放下的状态(执行收起操作)
        
        //添加动画
        [UIView animateWithDuration:.35 animations:^{
            _headerView.top = -100;
            _maskView.alpha = 0;
        } completion:^(BOOL finished) {
            //获取头视图里面的按钮
            UIButton *button = (UIButton *)[_headerView viewWithTag:123];
            button.imageView.transform = CGAffineTransformIdentity;
        }];
        
    } else if (_headerView.top == -100) {
        //执行放下操作
        //添加动画
        [UIView animateWithDuration:.35 animations:^{
            _headerView.top = 0;
            _maskView.alpha = .5;
        } completion:^(BOOL finished) {
            //获取头视图里面的按钮
            UIButton *button = (UIButton *)[_headerView viewWithTag:123];
            button.imageView.transform = CGAffineTransformMakeRotation(M_PI);;
        }];
    }
}

//收起头视图
- (void)upHeaderView
{
    //添加动画
    [UIView animateWithDuration:.35 animations:^{
        _headerView.top = -100;
        _maskView.alpha = 0;
    } completion:^(BOOL finished) {
        //获取头视图里面的按钮
        UIButton *button = (UIButton *)[_headerView viewWithTag:123];
        button.imageView.transform = CGAffineTransformIdentity;
    }];
}

//放下头视图
- (void)downHeaderView
{
    //添加动画
    [UIView animateWithDuration:.35 animations:^{
        _headerView.top = 0;
        _maskView.alpha = .5;
    } completion:^(BOOL finished) {
        //获取头视图里面的按钮
        UIButton *button = (UIButton *)[_headerView viewWithTag:123];
        button.imageView.transform = CGAffineTransformMakeRotation(M_PI);;
    }];
}

#pragma mark - KVO
- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary *)change context:(void *)context
{
    //判断那一个视图发生了改变
    if ([object isMemberOfClass:[PosterHeaderTableView class]]) {
        //头部的海报视图
        NSLog(@"头部的海报视图改变了");
        //1.判断当前视图的选中的单元格和另一个视图的单元格是否视图同一个索引
        if (_posterHeaderTableView.selectedIndexPath.row != _postBodyTableView.selectedIndexPath.row) {
            //让内容的海报视图滑动到当前的位置
            _postBodyTableView.selectedIndexPath = _posterHeaderTableView.selectedIndexPath;
            [_postBodyTableView scrollToRowAtIndexPath:_postBodyTableView.selectedIndexPath atScrollPosition:UITableViewScrollPositionTop animated:YES];
            
            //设置电影的标题
            MovieModel *model = self.dataList[_postBodyTableView.selectedIndexPath.row];
            
            _bottomLabel.text = model.title;
        }
    } else {
        //内容的海报视图
        NSLog(@"内容的海报视图改变了");
        //1.判断当前视图的选中的单元格和另一个视图的单元格是否视图同一个索引
        if (_posterHeaderTableView.selectedIndexPath.row != _postBodyTableView.selectedIndexPath.row) {
            //让内容的海报视图滑动到当前的位置
            _posterHeaderTableView.selectedIndexPath = _postBodyTableView.selectedIndexPath;
            [_posterHeaderTableView scrollToRowAtIndexPath:_posterHeaderTableView.selectedIndexPath atScrollPosition:UITableViewScrollPositionTop animated:YES];
            
            //设置电影的标题
            MovieModel *model = self.dataList[_postBodyTableView.selectedIndexPath.row];
            
            _bottomLabel.text = model.title;
        }
        
    }
}











@end
