//
//  MoreViewController.m
//  MyMovie
//
//  Created by zsm on 14-8-15.
//  Copyright (c) 2014年 zsm. All rights reserved.
//

#import "MoreViewController.h"
#import "SDImageCache.h"

@interface MoreViewController ()

@end

@implementation MoreViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
        self.title = @"更多";
        
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
    //初始化数据
    [self _loadData];
    
    //初始化子视图
    [self _initViews];
    
    [self cacheSize];

}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    
    //刷新表视图
    [_tableView reloadData];
}
//初始化子视图
- (void)_initViews
{
    self.view.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"bg_main.png"]];
    _tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 00, kScreenWidth, kScreenHeight - 64 - 49) style:UITableViewStyleGrouped];
    _tableView.delegate = self;
    _tableView.dataSource = self;
    //设置背景图片
    _tableView.backgroundColor = [UIColor clearColor];
    _tableView.backgroundView = nil;
//    _tableView.bounces = NO;
//    _tableView.layer.borderColor = [UIColor grayColor].CGColor;
//    _tableView.layer.borderWidth = 1;
    //设置填充
    [self.view addSubview:_tableView];
    
                            
}

//初始化数据
- (void)_loadData
{
    //初始化标题数组
    _titles = [@[@"清除缓存",@"给个评价",@"商务合作",@"检测新版本",@"欢迎页",@"关于"] retain];
    
    //初始化图片名字数组
    _imageNames = [@[@"moreClear.png",
                     @"moreScore.png",
                     @"moreBusiness.png",
                     @"moreVersion.png",
                     @"moreWelcome.png",
                     @"moreAbout.png"] retain];
}

#pragma mark - UITableView DataSource
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return _titles.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *identifier = @"moreCellId";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier];
    if (cell == nil) {
        cell = [[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifier] autorelease];
        
        //去除背景颜色
        cell.backgroundColor = [UIColor clearColor];
        cell.backgroundView = nil;
        
        //去掉选中样式
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        
        //设置文本的颜色
        cell.textLabel.textColor = [UIColor grayColor];
        cell.textLabel.font = [UIFont systemFontOfSize:14];
        
        //---------------创建子视图-----------------
        UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(100, 0, 200, 44)];
        label.backgroundColor = [UIColor clearColor];
        label.textColor = [UIColor whiteColor];
        label.textAlignment = NSTextAlignmentRight;
        label.font = [UIFont systemFontOfSize:14];
        label.tag = 101;
        [cell.contentView addSubview:label];
        [label release];
    }
    //获取图片的名字
    NSString *imageName = _imageNames[indexPath.row];
    cell.imageView.image = [UIImage imageNamed:imageName];
    
    //获取标题
    cell.textLabel.text = _titles[indexPath.row];
    
    UILabel *label = (UILabel *)[cell.contentView viewWithTag:101];
    if (indexPath.row == 0) {
        //显示文本
        label.hidden = NO;
        label.text = [NSString stringWithFormat:@"%.2fM",[self cacheSize]];
    } else {
        //隐藏文本
        label.hidden = YES;
    }
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.row == 0) {
        //点击的是清除缓存
        UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"清除缓存" message:@"是否清楚?" delegate:self cancelButtonTitle:@"NO" otherButtonTitles:@"YES", nil];
        
        //弹出alertView
        [alertView show];
        [alertView release];
    }
}

#pragma mark - UIAlertView Delegate
- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (buttonIndex == 0) {
        NSLog(@"取消");
    } else {
        NSLog(@"确定");
        //清楚缓存
        [[SDImageCache sharedImageCache] clearDisk];
        //刷新表视图
        [_tableView reloadData];
    }
}

//计算缓存的大小
- (float)cacheSize
{
    long long sum = 0;
    //缓存文件的路径
    NSString *path = [NSHomeDirectory() stringByAppendingPathComponent:@"Library/Caches/ImageCache"];
    
    //计算文件的大小
    NSFileManager *fileManager = [NSFileManager defaultManager];
    //获取目录下所有子文件的路径
    NSArray *subPaths = [fileManager subpathsAtPath:path];
    NSLog(@"subPaths:%@",subPaths);
    //获取所有文件的完整路径
    for (NSString *subPath in subPaths) {
        //获取图片的完整路径
        NSString *filePath = [path stringByAppendingPathComponent:subPath];
        //通过文件的路径获取文件的属性
        NSDictionary *fileDic = [fileManager attributesOfItemAtPath:filePath error:nil];
        //文件的大小
        long long size = [fileDic fileSize];
        sum += size;
    }
    
    return sum /(1000.0 * 1000.0);
}

//内存警告的时候调用的方法
- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
    NSLog(@"内存警告了");
    
    //判断当前的根视图是否在window上
    if (self.view.window == nil) {
        self.view = nil;
        NSLog(@"不在window上");
        /*
            1.只能释放在viewDidLoad里面实例化的全局变量
            2.不能释放外面传进来的全局变量,和在初始化方法里面创建的全局变量
         */
        [_titles release];
        _titles = nil;
        
        [_imageNames release];
        _imageNames = nil;
        
        [_tableView release];
        _tableView = nil;
        
        
    }
    
}



@end
