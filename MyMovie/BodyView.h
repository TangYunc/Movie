//
//  BodyView.h
//  MyMovie
//
//  Created by zsm on 14-8-19.
//  Copyright (c) 2014年 zsm. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MovieModel.h"
#import "WXRatingView.h"

@interface BodyView : UIView
{
    IBOutlet UIImageView *_imageView;
    IBOutlet UILabel *_titeLabel;
    
    IBOutlet UILabel *_eTitleLabel;
    
    IBOutlet UILabel *_yearLabel;
    
    //星星视图
    WXRatingView *_ratingView;
}

@property (nonatomic,retain) MovieModel *model;
@end
