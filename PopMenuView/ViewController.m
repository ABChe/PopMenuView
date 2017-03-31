//
//  ViewController.m
//  PopMenuView
//
//  Created by 车 on 17/3/22.
//  Copyright © 2017年 abche. All rights reserved.
//

#import "ViewController.h"
#import "PopMenuView.h"

@interface ViewController ()<PopMenuViewDelegate>

@property (nonatomic, strong) PopMenuView *popMenuView;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"test" style:UIBarButtonItemStylePlain target:self action:@selector(clickButton)];
}

- (void)popMenuViewSelectedIndex:(NSInteger)index {
    NSLog(@"popMenuViewSelectedIndex --- %ld",index);
}

- (void)clickButton {
    [self.popMenuView showView];
}

- (PopMenuView *)popMenuView {
    if (_popMenuView == nil) {
        NSArray *dataArray = @[@"测试标题1", @"测试标题2", @"测试标题3"];
        UIView *targetView = (UIView *)[self.navigationItem.rightBarButtonItem valueForKey:@"view"];
        CGPoint showPoint;
        if (targetView) {
            showPoint = CGPointMake(CGRectGetMaxX(targetView.frame) - CGRectGetWidth(targetView.frame) / 2, CGRectGetMaxY(targetView.frame) + 1 + 20);
        }
        _popMenuView = [[PopMenuView alloc] initWithDataArray:dataArray showPoint:showPoint];
    }
    return _popMenuView;
}



@end
