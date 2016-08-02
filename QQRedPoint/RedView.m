//
//  RedView.m
//  QQRedPoint
//
//  Created by ZhengWei on 16/8/2.
//  Copyright © 2016年 Bourbon. All rights reserved.
//

#import "RedView.h"
#include "math.h"
@interface RedView ()
{
    //开始和结束的圆心
    CGPoint _beginPoint;
    CGPoint _endPoint;
    //旋转角度
    CGFloat _angle;
    //上下两个圆的半径
    CGFloat _beginRadius;
    CGFloat _endRadius;
    //开始圆心的上下两个点
    CGPoint _beginPointUP;
    CGPoint _beginPointDown;
    //结束圆心的上下两个点
    CGPoint _endPointUP;
    CGPoint _endPointDown;
    //两个圆心的距离
    CGFloat _distance;
    //上方和下方的贝塞尔曲线控制单
    CGPoint _upControlPoint;
    CGPoint _downControlPoint;
    //屏幕刷新
    CADisplayLink *_displayLink;
    
    BOOL _isStart;
    
    UIView *_containView;
    CAShapeLayer *_pathLayer;
    CALayer *layer;
    CGRect firstRect;
}

@end
@implementation RedView


// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
    if (!_isStart) {
        return;
    }
    
    UIBezierPath *path = [UIBezierPath bezierPath];
    [path moveToPoint:_beginPointUP];
    [path addLineToPoint:_beginPointDown];
    [path addQuadCurveToPoint:_endPointDown controlPoint:_downControlPoint];
//    [path addLineToPoint:_endPointDown];
    [path addLineToPoint:_endPointUP];
    [path addQuadCurveToPoint:_beginPointUP controlPoint:_upControlPoint];
//    [path addLineToPoint:_beginPointUP];
    
    _pathLayer.path = path.CGPath;
    
}
-(instancetype)initWithFrame:(CGRect)frame fromView:(UIView *)view{
    if (self = [super initWithFrame:frame]) {
        _displayLink = [CADisplayLink displayLinkWithTarget:self selector:@selector(refreshScreen:)];
        [_displayLink addToRunLoop:[NSRunLoop mainRunLoop] forMode:NSDefaultRunLoopMode];
        _beginPoint = CGPointMake(7+frame.origin.x, 7+frame.origin.y);
        firstRect = frame;
        _beginRadius = 7;
        _endRadius = 21;
        
        _containView = view;
        [_containView addSubview:self];
        self.backgroundColor = [UIColor redColor];
        self.layer.masksToBounds = YES;
        self.layer.cornerRadius = 21;
        

    }
    return self;
}
-(void)refreshScreen:(CADisplayLink *)link{
}
-(void)move:(UIGestureRecognizer *)gesture{

    _isStart = YES;
    _endPoint = [gesture locationInView:_containView];
    self.center = _endPoint;
    
    if (gesture.state == UIGestureRecognizerStateBegan) {
        layer = [CALayer layer];
        layer.backgroundColor = [UIColor redColor].CGColor;
        layer.cornerRadius = _beginRadius;
        layer.masksToBounds = YES;
        layer.frame = CGRectMake(90, 90, 14, 14);
        [_containView.layer addSublayer:layer];
        
        _pathLayer = [CAShapeLayer layer];
        _pathLayer.fillColor = [UIColor redColor].CGColor;
        [_containView.layer addSublayer:_pathLayer];
        
    }else if (gesture.state == UIGestureRecognizerStateChanged){
        CGFloat x = fabs(_beginPoint.x - _endPoint.x);
        CGFloat y = fabs(_beginPoint.y - _endPoint.y);
        
        _distance = sqrtf(x*x + y*y);
        
        _angle =acosf(y/_distance);

        _beginPointUP = CGPointMake(_beginPoint.x-cosf(_angle)*_beginRadius, _beginPoint.y+sinf(_angle)*_beginRadius);
        _beginPointDown = CGPointMake(_beginPoint.x+cosf(_angle)*_beginRadius, _beginPoint.y-sinf(_angle)*_beginRadius);
        
        _endPointUP = CGPointMake(_endPoint.x-cosf(_angle)*_endRadius, _endPoint.y+sinf(_angle)*_endRadius);
        _endPointDown = CGPointMake(_endPoint.x+cosf(_angle)*_endRadius, _endPoint.y-sinf(_angle)*_endRadius);

        
        _downControlPoint = CGPointMake(_beginPointDown.x+(_distance/2)*sinf(_angle), _beginPointDown.y+(_distance/2)*cosf(_angle));
        _upControlPoint = CGPointMake(_beginPointUP.x + (_distance/2)*sinf(_angle), _beginPointUP.y + (_distance/2)*cosf(_angle));
        [self setNeedsDisplay];

    }else if (gesture.state == UIGestureRecognizerStateEnded ||
              gesture.state == UIGestureRecognizerStateFailed){
        [_pathLayer removeFromSuperlayer];
        [layer removeFromSuperlayer];
        [self setFrame:firstRect];
    }
    
}
@end
