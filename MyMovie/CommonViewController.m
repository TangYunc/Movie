//
//  CommonViewController.m
//  MyMovie
//
//  Created by zsm on 14-8-22.
//  Copyright (c) 2014年 zsm. All rights reserved.
//

#import "CommonViewController.h"
#import "ImageDetailViewController.h"

@interface CommonViewController ()

@end

@implementation CommonViewController

- (void)dealloc
{
    [_webView release];
    _webView = nil;
    [super dealloc];
}

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
        self.title = @"普通新闻";
        self.isBackButton = YES;
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
   
    //初始化子视图
    [self _initViews];
    
    //创建加载提示控件
    [self _initActView];
    
    //加载数据
    [self _loadData];
    
    
}

//记在数据源
- (void)_loadData
{
    //加载本地的模板数据
    NSString *path = [[NSBundle mainBundle] pathForResource:@"news" ofType:@"html"];
    NSString *htmlString = [NSString stringWithContentsOfFile:path encoding:NSUTF8StringEncoding error:nil];
    //获取新闻的数据
    NSDictionary *dic = [WXDataService getJsonDataWithFileName:JK_news_detail];
    //获取我们想要的数据
    NSString *title = dic[@"title"];
    NSString *source = dic[@"source"];
    NSString *time = dic[@"time"];
    NSString *content = dic[@"content"];
    NSString *author = dic[@"author"];
    
    //拼接成完成的数据
    NSString *html = [NSString stringWithFormat:htmlString,title,source,time,content,author];
    
    //获取资源包根目录
    NSURL *baseUrl = [[NSBundle mainBundle] resourceURL];
    [_webView loadHTMLString:html baseURL:baseUrl];
}

//初始化子视图
- (void)_initViews
{
    _webView = [[UIWebView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, kScreenHeight - 64)];
    //设置代理对象
    _webView.delegate = self;
    [self.view addSubview:_webView];
    
    //1.加载网址
//    NSURL *url = [NSURL URLWithString:@"http://www.baidu.com"];
//    NSURLRequest *resquest = [NSURLRequest requestWithURL:url];
//    [_webView loadRequest:resquest];
    
    //2.加载本地的数据
//    NSString *path = [[NSBundle mainBundle]pathForResource:@"text" ofType:@"html"];
//    NSString *htmlString = [NSString stringWithContentsOfFile:path encoding:NSUTF8StringEncoding error:nil];
//    [_webView loadHTMLString:htmlString baseURL:nil];
}

//创建加载提示控件
- (void)_initActView
{
    _actView = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleWhiteLarge];
    //创建导航按钮
    UIBarButtonItem *rightBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:_actView];
    self.navigationItem.rightBarButtonItem = [rightBarButtonItem autorelease];
}


#pragma mark - UIWebView Delegate
//监听web的跳转
- (BOOL)webView:(UIWebView *)webView shouldStartLoadWithRequest:(NSURLRequest *)request navigationType:(UIWebViewNavigationType)navigationType
{
    NSLog(@"url:%@",request.URL);
    /*
        click:http://img31.mtime.cn/CMS/News/2013/08/31/142735.22446758.jpg;
                http://img31.mtime.cn/CMS/News/2013/08/31/142737.60622977.jpg;
                http://img31.mtime.cn/CMS/News/2013/08/31/142834.54337748.jpg;
                http://img31.mtime.cn/CMS/News/2013/08/31/142735.22446758.jpg;
                http://img31.mtime.cn/CMS/News/2013/08/31/142738.86649567.jpg;
                http://img31.mtime.cn/CMS/News/2013/08/31/142856.73878839.jpg;
                http://img31.mtime.cn/CMS/News/2013/08/31/142739.89615182.jpg
     */
    NSString *urlString = [request.URL absoluteString];
    if ([urlString hasPrefix:@"click:"]) {
        //我们点击的是图片事件
        NSArray *urlArray = [urlString componentsSeparatedByString:@";"];
        
        //获取第一条数据(我们所点击的图片)
        NSString *clickUrl = [urlArray objectAtIndex:0];
        
        //截取我们点击图片的完整体质
        NSRange range = [clickUrl rangeOfString:@":"];
        NSString *selectedImageUrl = [clickUrl substringFromIndex:range.location + 1];
        
        //获取我们最终想要的数组(截取数组)
        NSArray *imageUrls = [urlArray subarrayWithRange:NSMakeRange(1, urlArray.count - 1)];
        
        //获取单机图片在数组里面的索引位置
        NSInteger index = [imageUrls indexOfObject:selectedImageUrl];
        
        //创建相册控制器
        ImageDetailViewController *imageDetailVC = [[ImageDetailViewController alloc] init];
        imageDetailVC.dataList = imageUrls;
        imageDetailVC.index = index;
        
        //创建导航控制器
        UINavigationController *navCtrl = [[UINavigationController alloc] initWithRootViewController:imageDetailVC];
        //设置导航栏的样式
        navCtrl.navigationBar.barStyle = UIBarStyleBlackTranslucent;
        
        //通过模态视图弹出
        [self presentViewController:navCtrl animated:YES completion:nil];
        
        //释放
        [imageDetailVC release];
        [navCtrl release];
        
        return NO;
    }
    return YES;
}
- (void)webViewDidStartLoad:(UIWebView *)webView
{
    //开始加载
    [_actView startAnimating];
    //开启状态上的加载提示
    [[UIApplication sharedApplication] setNetworkActivityIndicatorVisible:YES];
}
- (void)webViewDidFinishLoad:(UIWebView *)webView
{
    //结束加载
    [_actView stopAnimating];
    
    //关闭状态上的加载提示
    [[UIApplication sharedApplication] setNetworkActivityIndicatorVisible:NO];
    
    //交互
    //1.客户端让html执行脚本语言
//    [_webView stringByEvaluatingJavaScriptFromString:@"window.alert('点击了')"];
}
- (void)webView:(UIWebView *)webView didFailLoadWithError:(NSError *)error
{
    
}

@end
