//
//  CinemaCell.h
//  MyMovie
//
//  Created by zsm on 14-8-25.
//  Copyright (c) 2014年 zsm. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CinemaListModel.h"

@interface CinemaCell : UITableViewCell
{
    IBOutlet UILabel *_lowPriceLabel;
    
    IBOutlet UILabel *_gradeLabel;
    IBOutlet UILabel *_circleNameLabel;
    IBOutlet UILabel *_nameLabel;
    IBOutlet UIImageView *_zImageView;
    IBOutlet UIImageView *_qImageView;
}

@property(nonatomic,retain)CinemaListModel *model;
@end
