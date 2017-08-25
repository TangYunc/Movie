//
//  MovieHeaderView.h
//  MyMovie
//
//  Created by zsm on 14-8-23.
//  Copyright (c) 2014年 zsm. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MovieDetailModel.h"

@interface MovieHeaderView : UIView
{
    IBOutlet UIImageView *_titleImageView;
    IBOutlet UILabel *_titleLabel;
    IBOutlet UIImageView *_bgImageView;
    
    IBOutlet UIImageView *_imageViewFour;
    IBOutlet UIImageView *_imageViewThree;
    IBOutlet UIImageView *_imageViewTwo;
    IBOutlet UIImageView *_imageViewOne;
    IBOutlet UILabel *_locationDateLabel;
    IBOutlet UILabel *_typeLabel;
    IBOutlet UILabel *_directorsLabel;
    IBOutlet UILabel *_actorsLabel;
}

@property(nonatomic,retain)MovieDetailModel *model;
@end
