//
//  CinemaCell.m
//  MyMovie
//
//  Created by zsm on 14-8-25.
//  Copyright (c) 2014年 zsm. All rights reserved.
//

#import "CinemaCell.h"

@implementation CinemaCell

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
    //设置背景
    self.backgroundView = nil;
    self.backgroundColor = [UIColor clearColor];
}

- (void)layoutSubviews
{
    [super layoutSubviews];
    
    //设置影院名字
    _nameLabel.text = self.model.name;
    //适应内容的大小
    [_nameLabel sizeToFit];
    
    //分数
    _gradeLabel.text = self.model.grade;
    _gradeLabel.left = _nameLabel.right + 5;
    
    //附近标注建筑
    if ([self.model.circleName  isKindOfClass:[NSNull class]]) {
        _circleNameLabel.text = @"暂无位置";
    } else {
        _circleNameLabel.text = self.model.circleName;
    }
    
    
    //优惠价格
    _lowPriceLabel.text = [NSString stringWithFormat:@"￥%@",self.model.lowPrice];
    
    //判断是否有座
    BOOL isSeat = [self.model.isSeatSupport boolValue];
    if (isSeat) {
        //座的图片显示
        _zImageView.hidden = NO;
        
        //优惠券在原有的位置
        _qImageView.left = 40;
        
    } else {
        //座的图片隐藏
        _zImageView.hidden = YES;
        
        //优惠券在座的位置
        _qImageView.left = _zImageView.left;
    }
    
    //判断是否有优惠券
    BOOL isCoupon =  [self.model.isCouponSupport boolValue];
    if (isCoupon) {
        //优惠券显示
        _qImageView.hidden = NO;
    } else {
        //优惠券隐藏
        _qImageView.hidden = YES;
    }
    
    
}
- (void)dealloc {
    [_lowPriceLabel release];
    [_nameLabel release];
    [_circleNameLabel release];
    [_gradeLabel release];
    [_zImageView release];
    [_qImageView release];
    [super dealloc];
}
@end
