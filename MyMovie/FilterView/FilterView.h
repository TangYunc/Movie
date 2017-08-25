//
//  FilterView.h
//  MyMovie
//
//  Created by zsm on 14-8-23.
//  Copyright (c) 2014年 zsm. All rights reserved.
//

#import <UIKit/UIKit.h>
@class FilterView;
@protocol FilterViewDelegate <NSObject>

//点击事调用的协议方法
- (void)filterView:(FilterView *)filterView
didSelectItemOfIndexPath:(NSIndexPath *)indexPath
         itemTitle:(NSString *)itemTitle
AllSelectedIndexPaths:(NSArray *)selectedIndexPaths

        itemTitles:(NSArray *)itemTitles;

@end
@interface FilterView : UIView<UITableViewDataSource,UITableViewDelegate>
{
    IBOutlet UIView *_headerView;
    
    IBOutlet UIView *_contentView;
}
@property(nonatomic,assign)id<FilterViewDelegate> delegate;
@property (nonatomic,retain)NSArray *items;
@property(nonatomic,retain)NSMutableArray *selectedIndexPaths;
@end
