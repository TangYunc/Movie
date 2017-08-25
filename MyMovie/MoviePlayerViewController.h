//
//  MoviePlayerViewController.h
//  MyMovie
//
//  Created by zsm on 14-9-17.
//  Copyright (c) 2014年 zsm. All rights reserved.
//

#import "BaseViewController.h"
#import <MediaPlayer/MediaPlayer.h>
#import "WXSlider.h"

@interface MoviePlayerViewController : BaseViewController<UIGestureRecognizerDelegate>
{
    IBOutlet UIView *_bodyView; //内容视图
    
    IBOutlet UIView *_movieSuperView; //视频视图的父视图
    MPMoviePlayerController *_moviePlayerCtrl; //视频播放控制器
    
    IBOutlet UIView *_volumeView; //音量视图
    
    IBOutlet UIView *_bottomView; //底部选项视图
    
    IBOutlet UILabel *_startTimeLabel;//播放时间
    IBOutlet UILabel *_endTimeLabel;//结束时间
    
    IBOutlet UIButton *_volumeButton;
    
    IBOutlet UIButton *_stateButton;
    WXSlider *_playerSlider;        //视频进度
    WXSlider *_volumeSlider;        //音量
    float _lastVolume;             //静音前的声音
    
}

@property (nonatomic,retain) NSURL *movieUrl;       //视频播放地址
@property (nonatomic,copy) NSString *movieTitle;    //视频的名字

//按钮事件
- (IBAction)volumeAction:(UIButton *)sender;
- (IBAction)pauseAction:(UIButton *)sender;
- (IBAction)zoomAction:(UIButton *)sender;
//点击事件
- (IBAction)tapAction:(id)sender;

@end
