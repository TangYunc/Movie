//
//  CommonViewController.h
//  MyMovie
//
//  Created by zsm on 14-8-22.
//  Copyright (c) 2014年 zsm. All rights reserved.
//

#import "BaseViewController.h"

@interface CommonViewController : BaseViewController<UIWebViewDelegate>
{
    UIWebView *_webView;
    UIActivityIndicatorView *_actView;  //风火轮视图
}
@end
