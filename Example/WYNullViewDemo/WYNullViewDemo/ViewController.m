//
//  ViewController.m
//  WYNullViewDemo
//
//  Created by wyman on 2017/7/28.
//  Copyright © 2017年 wyman. All rights reserved.
//

#import "ViewController.h"
#import "MJRefresh.h"
#import "NSString+TextHeight.h"
#import "WYNullView.h"

//
// 可以打开以下宏测试NullView，显示不同的操作逻辑：
//
// 显示空视图: --》 1.如果没有设置则此框架创建一个NullView来展示
//           --》 2.如果设置了【+ (void)wy_configGlobleNullView:】则以globalView展示
//           --》 3.如果显示前使用 【- (void)wy_configNullView:】 defaultNullView返回了view则依靠此view则依靠此view做空视图展示
//           --》 4.如果显示时使用 【- (void)wy_showNullView: heightOffset:】defaultNullView返回了view则依靠此view做空视图展示
//
// 总结：以调用show方法前最近设置的nullView为标准，类似css就近原则，一般可以在初始化是配置config，到时候只使用【- (void)wy_showNullView】即可
//
// 情况1：整个工程全局都是一种NULLView的样式，可以如下配置
//          + (void)wy_configGlobleNullView:(UIView *(^)(NullView *defaultNullView))nullViewHandle;
//
// 情况2：整个工程有几种NULLView的样式，可以写一个Null单例来管理nullViewHandle
//
// 注意：如果在defaultNullView中返回新的view则之前的addtarget失效
//

#define DEFAULT_NULLVIEW_TEST
#define GLOBAL_NULLVIEW_TEST
//#define CONFIG_NULLVIEW_TEST
//#define CUSTOM_NULLVIEW_TEST

@interface ViewController ()<UITableViewDelegate, UITableViewDataSource>

@property (nonatomic, weak) UITableView *tableView;
@property (nonatomic, strong) NSArray<NSString *> *dataSourceArray;

@end

@implementation ViewController

#pragma mark - 模拟网络请求
///
/// 模拟网络请求，依次标记为有数据和没有数据
///
/// Simulate request data from NetWork, mark value empty data or full of data
///
static BOOL showNullView = YES;
- (void)loadFromNet {
    self.dataSourceArray = nil;
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1.25 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        [self dataSourceArray];
        
#ifdef DEFAULT_NULLVIEW_TEST
        if (showNullView) { // 无数据，empty data -》 show nullview
            [self.tableView wy_showNullView];
        } else { // 有数据，data -》 hide nullview
             [self.tableView wy_hideNullView];
        }
#endif
        
#ifdef CONFIG_NULLVIEW_TEST
        if (showNullView) { // 无数据，empty data -》 show nullview
            [self.tableView wy_showNullView];
        } else { // 有数据，data -》 hide nullview
            [self.tableView wy_hideNullView];
        }
#endif
        
#ifdef CUSTOM_NULLVIEW_TEST
        // 基于NullView 进行修改，可修改frame，image，text
        if (showNullView) { // 无数据，empty data -》 show nullview
            [self.tableView wy_showNullView:^UIView *(NullView *defaultNullView) {
                defaultNullView.desText = @"基于NullView自定义";
                defaultNullView.frame = CGRectMake(10, 10, defaultNullView.frame.size.width, defaultNullView.frame.size.height);
                defaultNullView.backgroundColor = [UIColor cyanColor];
                return defaultNullView;
            } heightOffset:0.0];
        } else { // 有数据，data -》 hide nullview
            [self.tableView wy_hideNullView];
        }
#endif
        
        
         showNullView = !showNullView;
        [self.tableView.mj_header endRefreshing];
    });
}

- (void)viewDidLoad {
    [super viewDidLoad];
    [self.tableView.mj_header beginRefreshing];
    // 设置空视图的点击事件
    // Add target SEL for nullview click event
    [self.tableView wy_nullViewAddTarget:self.tableView.mj_header action:@selector(beginRefreshing)];
#ifdef CONFIG_NULLVIEW_TEST
    [self.tableView wy_configNullView:^UIView *(NullView *defaultNullView) {
        defaultNullView.desText = @"预先配置NullView";
        return defaultNullView;
    }];
#endif
    
#ifdef GLOBAL_NULLVIEW_TEST
    [UIView wy_configGlobleNullView:^UIView *(NullView *defaultNullView) {
        defaultNullView.desText = @"全局配置的NullView";
        return defaultNullView;
    }];
#endif
    
    // 测试白名单
//    UISwitch *switch1 = [[UISwitch alloc] initWithFrame:CGRectMake(10, 60, 44, 44)];
//    [self.tableView addSubview:switch1];
//    UISwitch *switch2 = [[UISwitch alloc] initWithFrame:CGRectMake(10, 100, 44, 44)];
//    [self.tableView addSubview:switch2];
//    [[self.tableView wy_objWhitelist] addObject:makeWeakReference(switch1)];
//    [[self.tableView wy_classWhitelist] addObject:makeWeakReference(NSClassFromString(@"UISwitch"))];

    
}

#pragma mark - lazy property
- (UITableView *)tableView {
    if (!_tableView) {
        UITableView *tempTableView = [[UITableView alloc] initWithFrame:[UIScreen mainScreen].bounds style:UITableViewStylePlain];
        [self.view addSubview:tempTableView];
        _tableView = tempTableView;
        _tableView.delegate = self;
        _tableView.dataSource = self;
        _tableView.mj_header = [MJRefreshStateHeader headerWithRefreshingTarget:self refreshingAction:@selector(loadFromNet)];
    }
    return _tableView;
}

- (NSArray<NSString *> *)dataSourceArray {
    if (!_dataSourceArray) {
        _dataSourceArray = @[@"This project is a simple example of how to use this library",
                             @"You will be surprised",
                             @"How easy it is use of the lib in the view content is empty",
                             @"This lib has been designed in a way where you won't need to extend UIView class",
                             @"You will be able to fully customize the content and appearance of the empty states for your application",
                             @"If you think it's useful, star to me",
                             @"Free to share with ideas, issue or pull requests"];
    }
    return _dataSourceArray;
}

#pragma mark - UITableViewDataSource
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.dataSourceArray.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"WYNullViewDemoCell"];
    if (!cell) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"WYNullViewDemoCell"];
        cell.textLabel.numberOfLines = 0;
        cell.textLabel.preferredMaxLayoutWidth = [UIScreen mainScreen].bounds.size.width;
        
    }
    cell.textLabel.text = self.dataSourceArray[indexPath.row];
    CGFloat h = [self.dataSourceArray[indexPath.row] wy_getHeightWithMaxWidth:[UIScreen mainScreen].bounds.size.width font:[UIFont systemFontOfSize:17.0]] + 2*20;
    CGFloat w = [UIScreen mainScreen].bounds.size.width;
    cell.textLabel.frame = CGRectMake(0, 0, w, h);
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return [self.dataSourceArray[indexPath.row] wy_getHeightWithMaxWidth:[UIScreen mainScreen].bounds.size.width font:[UIFont systemFontOfSize:17.0]]+2*20;
}


@end









