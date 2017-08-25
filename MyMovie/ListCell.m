//
//  ListCell.m
//  MyMovie
//
//  Created by zsm on 14-8-16.
//  Copyright (c) 2014年 zsm. All rights reserved.
//

#import "ListCell.h"
#import "UIImageView+WebCache.h"
#import "UIViewExt.h"

@implementation ListCell

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        // Initialization code
        //设置背景颜色
        self.backgroundColor = [UIColor clearColor];
        self.backgroundView = nil;
        
        //取消选中背景样式
        self.selectionStyle = UITableViewCellSelectionStyleNone;
        //设置辅助视图
        self.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
        
        //初始化子视图
        [self _initViews];
    }
    return self;
}

//初始化子视图
- (void)_initViews
{
    //创建海报图片
    _titleImageView = [[UIImageView alloc] initWithFrame:CGRectMake(10, 10, 75, 100)];
    _titleImageView.backgroundColor = [UIColor clearColor];
    [self addSubview:_titleImageView];
    
    //电影标题
    _titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(_titleImageView.right + 10, 20, 200, 20)];
    _titleLabel.backgroundColor = [UIColor clearColor];
    _titleLabel.textColor = [UIColor orangeColor];
    _titleLabel.font = [UIFont boldSystemFontOfSize:18];
    [self addSubview:_titleLabel];
    
    //评分
    _ratingView = [[WXRatingView alloc] initWithFrame:CGRectMake(_titleLabel.left, _titleLabel.bottom + 10, 0, 30) textColor:[UIColor purpleColor]];
    [self addSubview:_ratingView];
    
    //年份
    _yearLabel = [[UILabel alloc] initWithFrame:CGRectMake(_titleImageView.right + 10, _ratingView.bottom + 10, 200, 20)];
    _yearLabel.backgroundColor = [UIColor clearColor];
    _yearLabel.textColor = [UIColor whiteColor];
    _yearLabel.font = [UIFont systemFontOfSize:12];
    [self addSubview:_yearLabel];
    
}

- (void)layoutSubviews
{
    [super layoutSubviews];
    //图片
    //1.第一种方法请求图片
    NSURL *url = [NSURL URLWithString:self.model.images_small];
//    NSData *imageData = [NSData dataWithContentsOfURL:url];
//    UIImage *image = [UIImage imageWithData:imageData];
//    _titleImageView.image = image;
    //2.第二中请求图片的方法
    [_titleImageView setImageWithURL:url];
    
    
    //标题
    _titleLabel.text = self.model.title;
    
    //评分
    _ratingView.average = self.model.average;
    
    //年份
    _yearLabel.text = [NSString stringWithFormat:@"年份:%@",self.model.year];
}

@end
