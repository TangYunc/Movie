//
//  CommentCell.h
//  MyMovie
//
//  Created by zsm on 14-8-25.
//  Copyright (c) 2014年 zsm. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CommentModel.h"

@interface CommentCell : UITableViewCell
{
    IBOutlet UIImageView *_userImageView;
    
    IBOutlet UILabel *_ratingLabel;
    IBOutlet UILabel *_contentLabel;
    IBOutlet UIImageView *_bgImageView;
    IBOutlet UILabel *_userNameLabel;
}

@property(nonatomic,retain)CommentModel *model;
@end
