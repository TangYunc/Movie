//
//  MovieHeaderView.m
//  MyMovie
//
//  Created by zsm on 14-8-23.
//  Copyright (c) 2014年 zsm. All rights reserved.
//

#import "MovieHeaderView.h"
#import "MoviePlayerViewController.h"

@implementation MovieHeaderView

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
    }
    return self;
}

- (void)awakeFromNib
{
    [super awakeFromNib];
    //设置背景图片为透明
    _bgImageView.backgroundColor = [UIColor clearColor];
    
    //设置圆角
    _bgImageView.layer.cornerRadius = 5; //设置圆角的半径
    _bgImageView.layer.masksToBounds = YES; //裁剪
    
    //设置描边
    _bgImageView.layer.borderColor = [UIColor grayColor].CGColor;
    _bgImageView.layer.borderWidth = 1;
    
    //阴影效果
//    _bgImageView.layer.shadowColor
    
    //给四张图片添加一个事件
    NSArray *imageViews = @[_imageViewOne,_imageViewTwo,_imageViewThree,_imageViewFour];
    for (int i = 0; i < imageViews.count; i++) {
        //获取图片视图
        UIImageView *imageView = imageViews[i];
        imageView.tag = i;
        //开启点击事件
        imageView.userInteractionEnabled = YES;
        //添加手势
        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapAction:)];
        [imageView addGestureRecognizer:tap];
        [tap release];
    }
}

- (void)setModel:(MovieDetailModel *)model
{
    if (_model != model) {
        [_model release];
        _model = [model retain];
        
        //赋值
        //图片
        NSURL *imageUrl = [NSURL URLWithString:self.model.image];
        [_titleImageView setImageWithURL:imageUrl];
        
        //标题
        _titleLabel.text = self.model.titleCn;
        
        //导演
        _directorsLabel.text = [self.model.directors componentsJoinedByString:@"、"];
        
        //演员
        _actorsLabel.text = [self.model.actors componentsJoinedByString:@"、"];
        
        //类型
        _typeLabel.text = [self.model.type componentsJoinedByString:@"、"];
        
        //地点和时间
        _locationDateLabel.text = self.model.locationDate;
        
        //给四张图片赋值
        NSArray *imageViews = @[_imageViewOne,_imageViewTwo,_imageViewThree,_imageViewFour];
        for (int i = 0; i < self.model.videos.count; i++) {
            //获取视图
            UIImageView *imageView = imageViews[i];
            //获取对应的数据url,image
            NSDictionary *subDic = self.model.videos[i];
            NSURL *imageUrl = [NSURL URLWithString:subDic[@"image"]];
            //设置到图片上
            [imageView setImageWithURL:imageUrl];
        }
        
    }
}

#pragma mark - UITap Action
- (void)tapAction:(UITapGestureRecognizer *)tap
{
    //获取点击的视图的tag值
    NSInteger tag = tap.view.tag;
    //获取对应的数据url,image
    NSDictionary *subDic = self.model.videos[tag];
    NSURL *movieUrl = [NSURL URLWithString:subDic[@"url"]];
    
    //创建视频播放的视图控制器
    MoviePlayerViewController *moviePlayerVC = [[MoviePlayerViewController alloc] init];
    moviePlayerVC.movieUrl = movieUrl;
    moviePlayerVC.title = @"预告片";
    
    //导航了
    [self.viewController.navigationController pushViewController:moviePlayerVC animated:YES];
    
    //释放了
    [moviePlayerVC release];
}

- (void)dealloc {
    [_titleImageView release];
    [_titleLabel release];
    [_directorsLabel release];
    [_actorsLabel release];
    [_typeLabel release];
    [_locationDateLabel release];
    [_bgImageView release];
    [_imageViewOne release];
    [_imageViewTwo release];
    [_imageViewThree release];
    [_imageViewFour release];
    [super dealloc];
}
@end
