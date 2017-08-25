//
//  TabBarItem.m
//  MyMovie
//
//  Created by zsm on 14-8-15.
//  Copyright (c) 2014年 zsm. All rights reserved.
//

#import "TabBarItem.h"

@implementation TabBarItem

- (id)initWithFrame:(CGRect)frame
          imageName:(NSString *)imageName
              title:(NSString *)title
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
        
        //1.创建标题图片
        _titleImageView = [[UIImageView alloc] initWithFrame:CGRectMake((self.width - 19) / 2.0, 8, 19, 20)];
        //图片的填充方式
        _titleImageView.contentMode = UIViewContentModeScaleAspectFit;
        //设置图片
        _titleImageView.image = [UIImage imageNamed:imageName];
        [self addSubview:_titleImageView];
        
        //2.标题文本
        _titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, _titleImageView.bottom + 2, self.width, 12)];
        _titleLabel.backgroundColor = [UIColor clearColor];
        _titleLabel.textAlignment = NSTextAlignmentCenter;
        _titleLabel.textColor = [UIColor whiteColor];
        _titleLabel.font = [UIFont systemFontOfSize:10];
        _titleLabel.text = title;
        [self addSubview:_titleLabel];
    }
    return self;
}

- (void)dealloc
{
    [_titleLabel release];
    _titleLabel = nil;
    
    [_titleImageView release];
    _titleImageView = nil;
    [super dealloc];
}

@end
