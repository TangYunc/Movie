//
//  ListCell.h
//  MyMovie
//
//  Created by zsm on 14-8-16.
//  Copyright (c) 2014年 zsm. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MovieModel.h"
#import "WXRatingView.h"

@interface ListCell : UITableViewCell
{
    UIImageView *_titleImageView;
    UILabel *_titleLabel;
    WXRatingView *_ratingView;
    UILabel *_yearLabel;
}

@property (nonatomic,retain)MovieModel *model;
@end
