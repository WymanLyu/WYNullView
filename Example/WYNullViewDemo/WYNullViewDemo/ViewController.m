//
//  ViewController.m
//  WYNullViewDemo
//
//  Created by wyman on 2017/7/28.
//  Copyright © 2017年 wyman. All rights reserved.
//

#import "ViewController.h"
#import "NSString+TextHeight.h"

@interface ViewController ()<UITableViewDelegate, UITableViewDataSource>

@property (nonatomic, weak) UITableView *tableView;
@property (nonatomic, strong) NSArray<NSString *> *dataSourceArray;

@end

@implementation ViewController

- (UITableView *)tableView {
    if (!_tableView) {
        UITableView *tempTableView = [[UITableView alloc] initWithFrame:[UIScreen mainScreen].bounds style:UITableViewStylePlain];
        [self.view addSubview:tempTableView];
        _tableView = tempTableView;
        _tableView.delegate = self;
        _tableView.dataSource = self;
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

- (void)viewDidLoad {
    [super viewDidLoad];
    [self tableView];
    
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

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [[self.tableView visibleCells] firstObject];
    NSLog(@"---%zd", cell.textLabel.numberOfLines);
}

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
   
}



@end









