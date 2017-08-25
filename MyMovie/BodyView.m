//
//  BodyView.m
//  MyMovie
//
//  Created by zsm on 14-8-19.
//  Copyright (c) 2014年 zsm. All rights reserved.
//

#import "BodyView.h"

@implementation BodyView

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
    }
    return self;
}

//通过xib文件创建的视图,不会调用init初始化方法,会调用awakeFromNib作为初始化方法
- (void)awakeFromNib
{
    [super awakeFromNib];
    
    //创建星星视图
    _ratingView = [[WXRatingView alloc] initWithFrame:CGRectMake(10, _yearLabel.bottom + 10, 320, 30) textColor:[UIColor purpleColor]];
    [self addSubview:_ratingView];
}


//复写set方法
- (void)setModel:(MovieModel *)model
{
    if (_model != model) {
        [_model release];
        _model = [model retain];
        
        //设置图片
        NSURL *url = [NSURL URLWithString:self.model.images_small];
        [_imageView setImageWithURL:url];
        
        //中文名字
        _titeLabel.text = self.model.title;
        
        //英文名字
        _eTitleLabel.text = self.model.original_title;
        
        //年份
        _yearLabel.text = [NSString stringWithFormat:@"年份:%@",self.model.year];
        
        //星星视图的评分
        _ratingView.average = self.model.average;
    }
}

- (void)dealloc {
    [_imageView release];
    [_titeLabel release];
    [_eTitleLabel release];
    [_yearLabel release];
    [super dealloc];
}
@end
