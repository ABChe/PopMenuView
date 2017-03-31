//
//  PopMenuView.m
//  PopMenuView
//
//  Created by 车 on 17/3/22.
//  Copyright © 2017年 abche. All rights reserved.
//

#import "PopMenuView.h"

#define kCellHeight      44
#define kTriangleHeight  8  //三角形的高度 6 8 10的直角三角形
#define kAnimationTime   0.3f

#define kScreenWidth     CGRectGetWidth([[UIScreen mainScreen] bounds])
#define kScreenHeight    CGRectGetHeight([[UIScreen mainScreen] bounds])


@interface ArrowView : UIView

@property (nonatomic, assign) CGPoint showPoint;
@end

@implementation ArrowView

- (instancetype) initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        self.backgroundColor = [UIColor clearColor];
    }
    return self;
}

- (void)drawRect:(CGRect)rect{
    // 设置背景色
    [[UIColor whiteColor] set];
    // 拿到当前视图准备好的画板
    CGContextRef  context = UIGraphicsGetCurrentContext();
    // 利用path进行绘制三角形
    CGContextBeginPath(context);
    CGPoint locationPoint = CGPointMake(self.showPoint.x, self.showPoint.y);
    CGPoint leftPoint     = CGPointMake(self.showPoint.x - 6, self.showPoint.y + 8);
    CGPoint rightPoint    = CGPointMake(self.showPoint.x + 6, self.showPoint.y + 8);
    // 设置起点
    CGContextMoveToPoint(context,locationPoint.x, locationPoint.y);
    CGContextAddLineToPoint(context,leftPoint.x , leftPoint.y);
    CGContextAddLineToPoint(context,rightPoint.x, rightPoint.y);
    // 路径结束标志，不写默认封闭
    CGContextClosePath(context);
    // 设置颜色
    UIColor * clor = [UIColor whiteColor];
    [clor setFill];
    [clor setStroke];
    // 绘制路径path
    CGContextDrawPath(context,kCGPathFillStroke);
}
@end


static NSString *PopCellMain = @"PopCellMain";

@interface PopMenuView ()<UITableViewDelegate, UITableViewDataSource>

@property (nonatomic, strong) UITableView *tabelView;
@property (nonatomic, strong) UIView      *maskView;
@property (nonatomic, strong) ArrowView   *arrowView;

@property (nonatomic, strong) NSArray *dataArray;
@property (nonatomic, assign) CGPoint  showPoint;

@end

@implementation PopMenuView


#pragma mark - Init

- (instancetype)initWithDataArray:(NSArray *)dataArray showPoint:(CGPoint)showPoint {
    self = [super init];
    if (self) {
        self.showPoint = showPoint;
        self.dataArray = dataArray;
        self.backgroundColor = [UIColor clearColor];
        
        [self addSubview:self.maskView];
        [self addSubview:self.arrowView];
        [self addSubview:self.tabelView];
        
        UITapGestureRecognizer * tap = [[UITapGestureRecognizer alloc] initWithTarget:self
                                                                               action:@selector(tapBackView)];
        [self.maskView addGestureRecognizer:tap];
        [self.arrowView addGestureRecognizer:tap];
    }
    
    return self;
}

- (void)layoutSubviews{
    [super layoutSubviews];
    self.frame          = CGRectMake(0, 0, kScreenWidth, kScreenHeight);
    self.maskView.frame = CGRectMake(0, 0, kScreenWidth, kScreenHeight);
}


#pragma mark - UItableViewDelegate

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return [self.dataArray count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:PopCellMain];
    if (!cell) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:PopCellMain];
    }
    cell.textLabel.text = self.dataArray[indexPath.row];
    cell.textLabel.adjustsFontSizeToFitWidth = YES;
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    if ([self.delegate respondsToSelector:@selector(popMenuViewSelectedIndex:)]) {
        [self.delegate popMenuViewSelectedIndex:indexPath.row];
    }
    [self tapBackView];
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return kCellHeight;
}


#pragma mark - Method

- (void)tapBackView {
    [CATransaction begin];
    
    [UIView animateWithDuration:kAnimationTime animations:^{
        self.tabelView.frame = CGRectMake(kScreenWidth - 100 - 10, 64 , 100, 0);
        
    } completion:^(BOOL finished) {
        [self removeFromSuperview];
        
    }];
    
    [CATransaction commit];
}

- (void)showView{
    UIWindow *window =[[[UIApplication sharedApplication] windows] lastObject];
    [window addSubview:self];
    self.tabelView.frame = CGRectMake(kScreenWidth - 100 - 10, 64 , 100, 0);

    [CATransaction begin];
    
    [UIView animateWithDuration:kAnimationTime animations:^{
        self.tabelView.frame = CGRectMake(kScreenWidth - 100 - 10, 64 , 100, (self.dataArray.count) * kCellHeight);
        
    } completion:^(BOOL finished) {
        
    }];
    
    [CATransaction commit];
}


#pragma mark - lazyLoading

- (UIView *)maskView {
    if (_maskView == nil) {
        _maskView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, kScreenHeight)];
        _maskView.userInteractionEnabled = YES;
        _maskView.backgroundColor = [UIColor colorWithWhite:0 alpha:0.1];
    }
    return _maskView;
}

- (ArrowView *)arrowView {
    if (_arrowView == nil) {
        _arrowView = [ArrowView new];
        _arrowView.showPoint = self.showPoint;
        _arrowView.frame = CGRectMake(0, 0, kScreenWidth, kScreenHeight);;
    }
    return _arrowView;
}

- (UITableView *)tabelView {
    if (_tabelView == nil) {
        _tabelView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, 0, 0) style:UITableViewStylePlain];
        _tabelView.delegate        = self;
        _tabelView.dataSource      = self;
        _tabelView.scrollEnabled   = NO;
        _tabelView.separatorStyle  = UITableViewCellSeparatorStyleNone;
    }
    return _tabelView;
}

@end
