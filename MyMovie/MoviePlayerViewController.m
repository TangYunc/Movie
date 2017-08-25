//
//  MoviePlayerViewController.m
//  MyMovie
//
//  Created by zsm on 14-9-17.
//  Copyright (c) 2014年 zsm. All rights reserved.
//

#import "MoviePlayerViewController.h"
#define BODYVIEW_HEIGHT 181
@interface MoviePlayerViewController ()

@end

@implementation MoviePlayerViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
        //开启自定义返回按钮
        self.isBackButton = YES;
        
        
        //----------添加系统内置的通知---------------
        //1.系统音量改变后发送的通知
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(volumeChangedAction:) name:MPMusicPlayerControllerVolumeDidChangeNotification object:nil];
        [[MPMusicPlayerController applicationMusicPlayer] beginGeneratingPlaybackNotifications];

        //2.视频播放时长改变的时候发送的通知
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(movieDurationChangedAction:) name:MPMovieDurationAvailableNotification object:nil];
        
        //3.播放状态改变的时候发送的一个通知
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(playStateDidChangedAction:) name:MPMoviePlayerPlaybackStateDidChangeNotification object:nil];

        //4.播放结束的一个通知
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(playDidFinsh:) name:MPMoviePlayerPlaybackDidFinishNotification object:nil];
    
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view.

    //初始化子视图
    [self _initViews];
}

//初始化子视图
- (void)_initViews
{
    //1.创建导航按钮
    [self _initRightButtonItem];
    
    //2.设置内容视图的大小
    [self _initBodyView];
    
    //3.视频播放控制器
    [self _initMoviePlayerController];
}

//3.视频播放控制器
- (void)_initMoviePlayerController
{
    _moviePlayerCtrl = [[MPMoviePlayerController alloc] init];
    //设置视频路径
    _moviePlayerCtrl.contentURL = self.movieUrl;
    //设置视频的视图大小
    _moviePlayerCtrl.view.frame = _movieSuperView.bounds;
    //禁用响应事件
    _moviePlayerCtrl.view.userInteractionEnabled = NO;
    //手动的设置autosizing
    _moviePlayerCtrl.view.autoresizingMask = UIViewAutoresizingFlexibleLeftMargin |
    UIViewAutoresizingFlexibleWidth |
    UIViewAutoresizingFlexibleRightMargin |
    UIViewAutoresizingFlexibleTopMargin |
    UIViewAutoresizingFlexibleHeight |
    UIViewAutoresizingFlexibleBottomMargin;
    //设置播放的样式
    _moviePlayerCtrl.controlStyle = MPMovieControlStyleNone;
    _moviePlayerCtrl.view.backgroundColor = [UIColor blackColor];
    //添加到视图上现实
    [_movieSuperView addSubview:_moviePlayerCtrl.view];
    //开始播放
    [_moviePlayerCtrl play];
    

    
}

//2.设置内容视图的大小
- (void)_initBodyView
{
    //内容视图的高度
    _bodyView.height = BODYVIEW_HEIGHT;
    
    //设置音量视图透明度
    _volumeView.backgroundColor = [UIColor colorWithRed:0 green:0 blue:0 alpha:.4];
    //底部视图的透明度
    _bottomView.backgroundColor = [UIColor colorWithRed:0 green:0 blue:0 alpha:.4];
    
    //视频进度
    _playerSlider = [[WXSlider alloc] initWithFrame:CGRectMake(80, 0, _bottomView.width - 160, _bottomView.height)];
    //添加事件
    [_playerSlider addTarget:self action:@selector(playerSliderChanged:) forControlEvents:UIControlEventValueChanged];
    [_bottomView addSubview:_playerSlider];
    
    //声音进度
    CGRect volumeSlider_frame = CGRectMake(0,-10,30,110);
    _volumeSlider = [[WXSlider alloc] initWithFrame:volumeSlider_frame];
    //设置方向
    _volumeSlider.direction = WXSliderDirectionVertica;
    //开启时时事件
    _volumeSlider.isJS_sender = YES;
  
    //默认声音的位置
    //设置播放生意
    _volumeSlider.value = [[MPMusicPlayerController applicationMusicPlayer] volume];
    //添加事件
    [_volumeSlider addTarget:self action:@selector(volumeSliderChanged:) forControlEvents:UIControlEventValueChanged];
    [_volumeView addSubview:_volumeSlider];
}

//1.创建导航按钮
- (void)_initRightButtonItem
{
    UIBarButtonItem *rightItem = [[UIBarButtonItem alloc] initWithTitle:@"横屏" style:UIBarButtonItemStylePlain target:self action:@selector(rightItemAction:)];
    self.navigationItem.rightBarButtonItem = [rightItem autorelease];
}

#pragma mark - WXSlider Change
- (void)playerSliderChanged:(WXSlider *)slider
{
    NSTimeInterval duration = slider.value * _moviePlayerCtrl.duration;
    [_moviePlayerCtrl setCurrentPlaybackTime:duration];
    _startTimeLabel.text = [self formatWithPlayTime:duration];
    //取消之前递归
    [NSObject cancelPreviousPerformRequestsWithTarget:self selector:@selector(movieDurationChangedAction:) object:nil];
    //监听进度
    [self performSelector:@selector(movieDurationChangedAction:) withObject:nil afterDelay:1];
}

- (void)volumeSliderChanged:(WXSlider *)slider
{
    NSLog(@"%f",slider.value);
    //设置播放声音的大小
    [[MPMusicPlayerController applicationMusicPlayer] setVolume:slider.value];
}

#pragma mark - UIBarButtonItem Action
- (void)rightItemAction:(UIBarButtonItem *)rightItem
{
    if ([rightItem.title isEqualToString:@"横屏"]) {
        [self hRotation];
        rightItem.title = @"竖屏";
    } else {
        [self sRotation];
        rightItem.title = @"横屏";
    }
}

//竖屏旋转的方法
- (void)sRotation
{
    [UIView animateWithDuration:[[UIApplication sharedApplication] statusBarOrientationAnimationDuration] animations:^{
        //让导航栏变成不透明的
        [self setNavigationBarCustom];
        //旋转导航控制器的根视图
        self.navigationController.view.transform = CGAffineTransformIdentity;
        //重新设定导航控制器的frame
        self.navigationController.view.frame = CGRectMake(0, 0, kScreenWidth, kScreenHeight);
        //修改导航栏的大小
        self.navigationController.navigationBar.frame = CGRectMake(0, 20, kScreenWidth, 44);
        //设置bodyView的高度
        _bodyView.height = BODYVIEW_HEIGHT;
        //视频进度
        _playerSlider.frame = CGRectMake(80, 0, kScreenWidth - 160, _bottomView.height);
        //声音进度
        _volumeSlider.frame = CGRectMake(0,-10,30,110);
    }];
    //旋转状态栏
    [[UIApplication sharedApplication] setStatusBarOrientation:UIInterfaceOrientationPortrait animated:YES];
}

//横屏旋转的方法
- (void)hRotation
{
    [UIView animateWithDuration:[[UIApplication sharedApplication] statusBarOrientationAnimationDuration] animations:^{
        //让导航栏变成透明的
        [self.navigationController.navigationBar setBackgroundImage:nil forBarMetrics:UIBarMetricsDefault];
        self.navigationController.navigationBar.barStyle = UIBarStyleBlackTranslucent;
        self.navigationController.navigationBar.translucent = YES;

        //旋转导航控制器的根视图
        self.navigationController.view.transform = CGAffineTransformMakeRotation(M_PI_2);
        //重新设定导航控制器的frame
        self.navigationController.view.frame = CGRectMake(0, 0, kScreenWidth, kScreenHeight);
        //修改导航栏的大小
        self.navigationController.navigationBar.frame = CGRectMake(0, 20, kScreenHeight, 32);
        //设置bodyView的高度
        _bodyView.height = kVersion >= 7.0 ? kScreenWidth : kScreenWidth - 20;
        //视频进度
        _playerSlider.frame = CGRectMake(80, 0, kScreenHeight - 160, _bottomView.height);
        //声音进度
        _volumeSlider.frame =  CGRectMake(0,-10,30,230);
        
    }];
    //旋转状态栏
    [[UIApplication sharedApplication] setStatusBarOrientation:UIInterfaceOrientationLandscapeRight animated:YES];
}

//设置导航栏
- (void)setNavigationBarCustom
{
    //取消导航栏的透明效果
    self.navigationController.navigationBar.translucent = NO;
    
    //设置导航栏的样式
    self.navigationController.navigationBar.barStyle = UIBarStyleBlack;
    
    //设置导航栏的背景图片
    UIImage *image = [UIImage imageNamed:@"nav_bg_all.png"];
    
    NSLog(@"version:%f",kVersion);
    //判断当前的系统版本
    if (kVersion >= 7.0) {
        //转换成CGImageRef
        CGImageRef imageRef = image.CGImage;
        
        //创建一个CGImageRef变量
        CGImageRef endImageRef = CGImageCreateWithImageInRect(imageRef, CGRectMake(160, 0, kScreenWidth, 64));
        
        //重新给Image赋值
        image = [UIImage imageWithCGImage:endImageRef];
        
        //内存管理
        CGImageRelease(endImageRef);
    }
    [self.navigationController.navigationBar setBackgroundImage:image forBarMetrics:UIBarMetricsDefault];
}

//手动旋转状态栏必须实现下面的方法
- (BOOL)shouldAutorotate
{
    return NO;
}

- (NSUInteger)supportedInterfaceOrientations
{
    return [UIApplication sharedApplication].statusBarOrientation;
}

#pragma mark - 重写backButton 的方法
- (void)backAction:(UIButton *)button
{
    //关闭播放
    [_moviePlayerCtrl stop];
    //先竖屏旋转
    [self sRotation];
    [self.navigationController performSelector:@selector(popViewControllerAnimated:) withObject:@YES afterDelay:[[UIApplication sharedApplication] statusBarOrientationAnimationDuration]];
}

- (void)dealloc
{
    [_bodyView release];
    _bodyView = nil;
    
    [_movieSuperView release];
    [_volumeView release];
    [_bottomView release];
    [_startTimeLabel release];
    [_endTimeLabel release];
    [_volumeButton release];
    [_stateButton release];
    [super dealloc];
}









- (IBAction)volumeAction:(UIButton *)sender {
    if (_volumeSlider.value != 0) {
        _lastVolume = _volumeSlider.value;
        //设置按钮的图片
        [[MPMusicPlayerController applicationMusicPlayer] setVolume:0];
        _volumeSlider.value = 0;
        //设置按钮的图片
        [sender setImage:[UIImage imageNamed:@"volume_mute.png"] forState:UIControlStateNormal];
    } else {
    
        //设置按钮的图片
        [[MPMusicPlayerController applicationMusicPlayer] setVolume:_lastVolume];
        _volumeSlider.value = _lastVolume;
        //设置按钮的图片
        [sender setImage:[UIImage imageNamed:@"volume.png"] forState:UIControlStateNormal];
    }
    
}

- (IBAction)pauseAction:(UIButton *)sender {
    if (_moviePlayerCtrl.playbackState == MPMoviePlaybackStateStopped || _moviePlayerCtrl.playbackState == MPMoviePlaybackStatePaused ) {
        //播放
        [_moviePlayerCtrl play];
        [sender setImage:[UIImage imageNamed:@"pause.png"] forState:UIControlStateNormal];
    } else if (_moviePlayerCtrl.playbackState == MPMoviePlaybackStatePlaying) {
        //暂停
        [_moviePlayerCtrl pause];
        [sender setImage:[UIImage imageNamed:@"play.png"] forState:UIControlStateNormal];
    }
}

- (IBAction)zoomAction:(UIButton *)sender {
    if (_moviePlayerCtrl.scalingMode == MPMovieScalingModeAspectFit) {
        //设置成全屏的
        _moviePlayerCtrl.scalingMode = MPMovieScalingModeAspectFill;
        //修改按钮图片
        [sender setImage:[UIImage imageNamed:@"zoomout.png"] forState:UIControlStateNormal];
    } else {
        //设置成默认模式
        _moviePlayerCtrl.scalingMode = MPMovieScalingModeAspectFit;
        //修改按钮图片
        [sender setImage:[UIImage imageNamed:@"zoomin.png"] forState:UIControlStateNormal];
    }
}

#pragma mark - 注册系统通知
//声音改变
- (void)volumeChangedAction:(NSNotification *)notification
{
    float volume = [[MPMusicPlayerController applicationMusicPlayer] volume];
    if (volume == 0) {
        _volumeSlider.value = volume;
        //设置按钮的图片
        [_volumeButton setImage:[UIImage imageNamed:@"volume_mute.png"] forState:UIControlStateNormal];
    } else {
        _volumeSlider.value = volume;
        //设置按钮的图片
        [_volumeButton setImage:[UIImage imageNamed:@"volume.png"] forState:UIControlStateNormal];
    }
}

//时长改变
- (void)movieDurationChangedAction:(NSNotification *)notification
{
    NSLog(@"--");
    //时间的改变
    //00：00：00
    _startTimeLabel.text = [self formatWithPlayTime:_moviePlayerCtrl.currentPlaybackTime];
    //进度条的改变
    _playerSlider.value = _moviePlayerCtrl.currentPlaybackTime / _moviePlayerCtrl.duration;
    //设置视频的总时长
    _endTimeLabel.text = [self formatWithPlayTime:_moviePlayerCtrl.duration];
    
    [self performSelector:@selector(movieDurationChangedAction:) withObject:nil afterDelay:1];
}

//通过数字转换成时间格式 100 ——> 00:01:40
- (NSString *)formatWithPlayTime:(NSTimeInterval)duration
{
    int hour = 0;
    int minute = 0;
    int second = 0;
    hour = duration / 3600;
    minute = ((int)duration % 3600) / 60;
    second = (int)duration % 60;
    return [NSString stringWithFormat:@"%02d:%02d:%02d",hour,minute,second];
}

//播放状态改变的时候接受到的通知
- (void)playStateDidChangedAction:(NSNotification *)notification
{
    if (_moviePlayerCtrl.playbackState == MPMoviePlaybackStateStopped || _moviePlayerCtrl.playbackState == MPMoviePlaybackStatePaused ) {

        [_stateButton setImage:[UIImage imageNamed:@"play.png"] forState:UIControlStateNormal];
        
        //取消递归
        [NSObject cancelPreviousPerformRequestsWithTarget:self selector:@selector(movieDurationChangedAction:) object:nil];
    } else if (_moviePlayerCtrl.playbackState == MPMoviePlaybackStatePlaying) {
        [_stateButton setImage:[UIImage imageNamed:@"pause.png"] forState:UIControlStateNormal];
        
        //监听进度
        [self performSelector:@selector(movieDurationChangedAction:) withObject:nil afterDelay:1];
        
    }
}

//视频播放完成
- (void)playDidFinsh:(NSNotification *)notification
{
    _playerSlider.value = 0;
    _moviePlayerCtrl.currentPlaybackTime = 0;
    _startTimeLabel.text = [self formatWithPlayTime:0];
    
}

#pragma mark - Tap Action
//点击事件
- (IBAction)tapAction:(id)sender
{
    UITapGestureRecognizer *tap = (UITapGestureRecognizer *)sender;
    //禁用手势
    [tap setEnabled:NO];
    [UIView animateWithDuration:.35 animations:^{
        if (_volumeView.alpha == 1) {
            _volumeView.alpha = 0;
            _bottomView.alpha = 0;
            if ([self.navigationItem.rightBarButtonItem.title isEqualToString:@"竖屏"]) {
                //隐藏导航栏
                [self.navigationController setNavigationBarHidden:YES animated:YES];
            }
        } else {
            _volumeView.alpha = 1;
            _bottomView.alpha = 1;
            if ([self.navigationItem.rightBarButtonItem.title isEqualToString:@"竖屏"]) {
                //显示导航栏
                [self.navigationController setNavigationBarHidden:NO animated:YES];
            }
        }
    } completion:^(BOOL finished) {
        //开启手势
        [tap setEnabled:YES];
    }];
}

#pragma mark - UIGestureRecognizerDelegate
- (BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldReceiveTouch:(UITouch *)touch
{
    if ([touch.view isKindOfClass:[UIControl class]]) {
        return NO;
    }
    return YES;
}
@end
