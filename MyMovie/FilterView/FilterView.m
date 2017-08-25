//
//  FilterView.m
//  MyMovie
//
//  Created by zsm on 14-8-23.
//  Copyright (c) 2014年 zsm. All rights reserved.
//

#import "FilterView.h"
#import "UIViewExt.h"

//获取当前设备屏幕的物理尺寸
#define kHeight 35
#define kWidth [UIScreen mainScreen].bounds.size.width
@implementation FilterView

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        
    }
    return self;
}


- (void)awakeFromNib
{
    [super awakeFromNib];
    self.height = kHeight;
    
    //创建头视图的子视图
    [self _headerViewSubView];
}

//创建内容视图的子视图
- (void)_contentViewSubView
{
    //设置背景颜色
    _contentView.backgroundColor = [UIColor colorWithRed:1 green:1 blue:1 alpha:.8];
    //设置_contentView视图的大小
    _contentView.height = _items.count * 30 + 10;
    //清楚内容视图所有的子视图
    for (UIView *subView in _contentView.subviews) {
        [subView removeFromSuperview];
    }
    
    //根据数据创建视图
    for (int i = 0; i < _items.count; i++) {
        //创建滑动视图
        CGRect frame = CGRectMake(0, i * 30 + 8, kWidth, 23);
        UITableView *tableView = [[UITableView alloc] initWithFrame:frame style:UITableViewStylePlain];
        
        //设置代理对象
        tableView.delegate = self;
        tableView.dataSource = self;
        
        //设置背景颜色
        tableView.backgroundColor = [UIColor clearColor];
        tableView.backgroundView = nil;
        tableView.tag = i;
        
        //隐藏单元格分割线
        tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        
        //1.逆时针旋转90度
        tableView.transform = CGAffineTransformMakeRotation(-M_PI_2);
        
        //2.重新设置frame
        tableView.frame = frame;
        
        //3.滑动指示器
        tableView.showsHorizontalScrollIndicator = NO;
        tableView.showsVerticalScrollIndicator = NO;
        
        //设置滑动动画的速度
        tableView.decelerationRate = UIScrollViewDecelerationRateFast;
        
        //设置填充
        [tableView setContentInset:UIEdgeInsetsMake(10, 0, 10, 0)];
        
        //添加到视图上
        [_contentView addSubview:tableView];
        [tableView release];
        
    }
    _contentView.bottom = self.bottom;
}

//创建头视图的子视图
- (void)_headerViewSubView
{
    _headerView.backgroundColor = [UIColor whiteColor];
    _headerView.height = kHeight + 1;
    //1.筛选按钮
    UIButton *searchButton = [UIButton buttonWithType:UIButtonTypeCustom];
    searchButton.frame = CGRectMake(self.frame.size.width - 70, 0, 70 , kHeight);
    //设置标题大小
    searchButton.titleLabel.font = [UIFont systemFontOfSize:14];
    [searchButton setTitle:@"筛 选 " forState:UIControlStateNormal];
    //设置颜色
    [searchButton setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    UIColor *color = [UIColor colorWithRed: 41.0/255.0f green: 142.0/255.0f blue:253.0/255.0f alpha:1.0f];
    [searchButton setTitleColor:color forState:UIControlStateSelected];
    //设置标题41 *33
    UIImage *image = [UIImage imageNamed:@"searchImage.png"];
    [searchButton setImage:image forState:UIControlStateNormal];
    //设置方向
    searchButton.transform = CGAffineTransformMakeRotation(M_PI);
    searchButton.titleLabel.transform = CGAffineTransformMakeRotation(-M_PI);
    
    //添加事件
    [searchButton addTarget:self action:@selector(buttonAction:) forControlEvents:UIControlEventTouchUpInside];
    [_headerView addSubview:searchButton];
}
#pragma mark - 复写setItem:方法
- (void)setItems:(NSArray *)items
{
    if (_items != items) {
        [_items release];
        _items = [items retain];
        
        //创建所有选中索引位置的数组
        _selectedIndexPaths = [[NSMutableArray alloc] init];
        for (int i = 0; i < _items.count; i++) {
            NSIndexPath *indexPath = [NSIndexPath indexPathForRow:0 inSection:i];
            [_selectedIndexPaths addObject:indexPath];
        }
        
        //创建内容视图的子视图
        [self _contentViewSubView];
    }
}

#pragma mark - UIButton Action
- (void)buttonAction:(UIButton *)button
{
    button.selected = !button.selected;
    
    //如果没有筛选
    if (_items.count == 0) {
        return;
    }
    [UIView animateWithDuration:.3 animations:^{
        if (self.height == kHeight) {
            self.height = kHeight + _contentView.height;
        } else {
            self.height = kHeight;
        }
    }];
    
    if (button.selected == YES) {
        button.imageView.transform = CGAffineTransformMakeRotation(M_PI);
    } else {
        button.imageView.transform = CGAffineTransformIdentity;
    }
}

#pragma mark - UITableView DataSource
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    NSArray *array2d = _items[tableView.tag];
    return array2d.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *identifier = @"FilterCellId";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier];
    if (cell == nil) {
        cell = [[[NSBundle mainBundle] loadNibNamed:@"FilterView" owner:self options:nil] objectAtIndex:0];
        
        //4.顺时针旋转单元格的内容视图
        cell.contentView.transform = CGAffineTransformMakeRotation(M_PI_2);
        
        //设置单元格的背景
        cell.backgroundColor = [UIColor clearColor];
        cell.backgroundView = nil;
        
        //设置选中背景
        UIImage *image = [UIImage imageNamed:@"select.png"];
        image = [image stretchableImageWithLeftCapWidth:10 topCapHeight:10];
        UIImageView *imageView = [[UIImageView alloc] initWithImage:image];
        cell.selectedBackgroundView = [imageView autorelease];
        
    }
    
    NSArray *array2d = _items[tableView.tag];
    UILabel *label = (UILabel *)[cell.contentView viewWithTag:2014];
    label.text = array2d[indexPath.row];

    return cell;
}

//单元格的高度
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSArray *array2d = _items[tableView.tag];
    NSString *title = array2d[indexPath.row];
    return title.length * 12 + 20;
}

//单元格点击事件
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    //调用点击的协议方法
    if ([self.delegate respondsToSelector:@selector(filterView:didSelectItemOfIndexPath:itemTitle:AllSelectedIndexPaths:itemTitles:)]) {
        
        //用代理对象调用协议方法
        //获取选中单元格的索引位置
        NSIndexPath *selectedIndexPath = [NSIndexPath indexPathForRow:indexPath.row inSection:tableView.tag];
        NSString *itemTitle = _items[selectedIndexPath.section][selectedIndexPath.row];
        
        //挨个的获取表示图里面选中单元格的索引位置数组
        _selectedIndexPaths[tableView.tag] = selectedIndexPath;
        
        NSMutableArray *itemTitles = [NSMutableArray array];
        for (int i = 0; i < _selectedIndexPaths.count; i++) {
            NSIndexPath *tIndexPath = [_selectedIndexPaths objectAtIndex:i];
            NSString *title = _items[i][tIndexPath.row];
            [itemTitles addObject:title];
        }
        
        
        [self.delegate filterView:self
         didSelectItemOfIndexPath:selectedIndexPath
                        itemTitle:itemTitle
            AllSelectedIndexPaths:_selectedIndexPaths
                       itemTitles:itemTitles];
    }
}

- (void)drawRect:(CGRect)rect
{
    [super drawRect:rect];
    //首次加载现实选中第一个
    for (UITableView *tableView in _contentView.subviews) {
        NSIndexPath *indexPath = [NSIndexPath indexPathForRow:0 inSection:0];
        [tableView selectRowAtIndexPath:indexPath animated:NO scrollPosition:UITableViewScrollPositionNone];
    }
}

- (void)dealloc {
    [_headerView release];
    [_contentView release];
    [_items release];
    [super dealloc];
}
@end
