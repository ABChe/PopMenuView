//
//  PopMenuView.h
//  PopMenuView
//
//  Created by 车 on 17/3/22.
//  Copyright © 2017年 abche. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol PopMenuViewDelegate <NSObject>

- (void)popMenuViewSelectedIndex:(NSInteger)index;

@end

@interface PopMenuView : UIView

@property (nonatomic, weak) id<PopMenuViewDelegate> delegate;

- (instancetype)initWithDataArray:(NSArray *)dataArray showPoint:(CGPoint)showPoint;

- (void)showView;

@end
