//
//  WXSlider.h
//  MyMovie
//
//  Created by zsm on 14-9-17.
//  Copyright (c) 2014年 zsm. All rights reserved.
//

#import <UIKit/UIKit.h>
typedef NS_ENUM(NSInteger, WXSliderDirection) {
    WXSliderDirectionHorizontal, //default
    WXSliderDirectionVertica
};
@interface WXSlider : UIControl
{

    UIImageView *_thumbView;    //滑块视图
    UIImageView *_minView;      //已经滑动过的视图
    UIImageView *_maxView;      //未滑动现实的视图
}
@property (nonatomic,assign) WXSliderDirection direction;
@property (nonatomic,assign) BOOL isJS_sender;
@property (nonatomic,assign) float value;
@property (nonatomic,assign) float minValue;
@property (nonatomic,assign) float maxValue;
@property (nonatomic,retain) UIImage *thumbImage;
@property (nonatomic,retain) UIImage *minimunImage;
@property (nonatomic,retain) UIImage *maximunImage;
@end
