//
//  NewsListCell.h
//  MyMovie
//
//  Created by zsm on 14-8-20.
//  Copyright (c) 2014年 zsm. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "NewsListModel.h"

@interface NewsListCell : UITableViewCell
{
    IBOutlet UIImageView *_titleImageView;
    IBOutlet UILabel *_titleLabel;
    IBOutlet UILabel *_summaryLabel;
    IBOutlet UIImageView *_typeImageView;
}

@property(nonatomic,retain)NewsListModel *model;
@end
