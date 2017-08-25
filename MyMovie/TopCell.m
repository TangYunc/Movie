//
//  TopCell.m
//  MyMovie
//
//  Created by zsm on 14-8-23.
//  Copyright (c) 2014年 zsm. All rights reserved.
//

#import "TopCell.h"

@implementation TopCell

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
        [self _initViews];
    }
    return self;
}

- (void)_initViews
{
    //创建图片视图
    _imageView = [[UIImageView alloc] initWithFrame:CGRectZero];
    _imageView.backgroundColor = [UIColor clearColor];
    [self.contentView addSubview:_imageView];
    
    //创建文本
    _titleLabel = [[UILabel alloc] initWithFrame:CGRectZero];
    _titleLabel.backgroundColor = [UIColor colorWithRed:0 green:0 blue:0 alpha:.5];
    _titleLabel.textColor = [UIColor whiteColor];
    _titleLabel.textAlignment = NSTextAlignmentCenter;
    _titleLabel.font = [UIFont systemFontOfSize:12];
    [_imageView addSubview:_titleLabel];
    
    //创建星星视图
    _ratingView = [[WXRatingView alloc] initWithFrame:CGRectMake(0, 0, 0, 20) textColor:[UIColor orangeColor]];
    [self.contentView addSubview:_ratingView];
}

- (void)layoutSubviews
{
    [super layoutSubviews];
    //1.图片视图
    _imageView.frame = CGRectMake((self.width - 75) / 2.0, 10, 75, 100);
    //获取图片URL
    NSURL *url = [NSURL URLWithString:self.model.images_small];
    [_imageView setImageWithURL:url];
    
    //2.文本视图
    _titleLabel.frame = CGRectMake(0, _imageView.height - 20, _imageView.width, 20);
    _titleLabel.text = self.model.title;
    
    //3.星星视图
    _ratingView.top = _imageView.bottom + 10;
    _ratingView.average = self.model.average;
}

@end
