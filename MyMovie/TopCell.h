//
//  TopCell.h
//  MyMovie
//
//  Created by zsm on 14-8-23.
//  Copyright (c) 2014年 zsm. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "WXRatingView.h"
#import "MovieModel.h"

@interface TopCell : UICollectionViewCell
{
    UIImageView *_imageView;
    UILabel *_titleLabel;
    WXRatingView *_ratingView;
}

@property(nonatomic,retain)MovieModel *model;
@end
