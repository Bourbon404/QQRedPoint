//
//  RedView.h
//  QQRedPoint
//
//  Created by ZhengWei on 16/8/2.
//  Copyright © 2016年 Bourbon. All rights reserved.
//

#import <UIKit/UIKit.h>
@interface RedView : UIView


-(instancetype)initWithFrame:(CGRect)frame fromView:(UIView *)view;

-(void)move:(UIGestureRecognizer *)gesture;

@end
