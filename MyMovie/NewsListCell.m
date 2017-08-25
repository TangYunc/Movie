//
//  NewsListCell.m
//  MyMovie
//
//  Created by zsm on 14-8-20.
//  Copyright (c) 2014年 zsm. All rights reserved.
//

#import "NewsListCell.h"

@implementation NewsListCell

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        // Initialization code
    }
    return self;
}

- (void)awakeFromNib
{
    [super awakeFromNib];
    
    //设置单元格的背景为透明
    self.backgroundColor = [UIColor clearColor];
    self.backgroundView = nil;
    
    //设置选中背景视图
    UIImageView *selectBg = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, 85)];
    UIImage *image = [UIImage imageNamed:@"selectImage.png"];
    selectBg.image = [image stretchableImageWithLeftCapWidth:1 topCapHeight:0];
    self.selectedBackgroundView = [selectBg autorelease];
}


- (void)layoutSubviews
{
    [super layoutSubviews];
    
    //设置标题图片
    NSURL *url = [NSURL URLWithString:self.model.image];
    [_titleImageView setImageWithURL:url];
    
    //设置标题
    _titleLabel.text = self.model.title;
    
    //设置简介
    _summaryLabel.text = self.model.summary;
    
    //设置新闻类型
    int typeId = [self.model.type intValue];
    if (typeId == 0) {
        //普通新闻
        _typeImageView.image = nil;
        //让文本移动到和标题视图对齐
        _summaryLabel.left = _titleLabel.left;
    } else if (typeId == 1) {
        //图片新闻
        _typeImageView.image = [UIImage imageNamed:@"sctpxw.png"];
        _summaryLabel.left = 124;
    } else {
        //视频新闻
        _typeImageView.image = [UIImage imageNamed:@"scspxw.png"];
        _summaryLabel.left = 124;
    }
}

- (void)dealloc {
    [_titleImageView release];
    [_titleLabel release];
    [_summaryLabel release];
    [_typeImageView release];
    [super dealloc];
}
@end
