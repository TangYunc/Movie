//
//  CommentCell.m
//  MyMovie
//
//  Created by zsm on 14-8-25.
//  Copyright (c) 2014年 zsm. All rights reserved.
//

#import "CommentCell.h"

@implementation CommentCell

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
    //设置背景图片
    UIImage *image = [UIImage imageNamed:@"movieDetail_comments_frame.png"];
    image = [image stretchableImageWithLeftCapWidth:100 topCapHeight:30];
    _bgImageView.image = image;
}

- (void)layoutSubviews
{
    [super layoutSubviews];
    //显示头像
    NSURL *url = [NSURL URLWithString:self.model.userImage];
    [_userImageView setImageWithURL:url];
    
    //设置用户名
    _userNameLabel.text = self.model.nickname;
    
    //设置评分
    _ratingLabel.text = self.model.rating;
    

    
    //设置内容
    _contentLabel.text = self.model.content;
    
    //-------------设置内容的展开和收起
    /*
    _contentLabel.height =  self.height - (70 - 14);
    
    //设置单元格背景视图的高度
    _bgImageView.height = self.height - 10;
    */
    
    if (self.height == 70) {
        _contentLabel.numberOfLines = 1;
    } else {
        _contentLabel.numberOfLines = 0;
    }
    
}
- (void)dealloc {
    [_userImageView release];
    [_bgImageView release];
    [_userNameLabel release];
    [_contentLabel release];
    [_ratingLabel release];
    [super dealloc];
}
@end
