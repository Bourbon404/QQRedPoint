//
//  ViewController.m
//  QQRedPoint
//
//  Created by ZhengWei on 16/8/2.
//  Copyright © 2016年 Bourbon. All rights reserved.
//

#import "ViewController.h"
#import "RedView.h"
@interface ViewController ()
{
    RedView *_redView;
}
@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    
    UIView *backView = [[UIView alloc] init];
    backView.frame = CGRectMake(100, 100, 100, 100);
    backView.backgroundColor = [UIColor yellowColor];
    [self.view addSubview:backView];
    
    _redView = [[RedView alloc] initWithFrame:CGRectMake(90, 90, 42, 42) fromView:self.view];
    _redView.userInteractionEnabled = YES;
    [_redView addGestureRecognizer:[[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(moveRedView:)]];
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
-(void)moveRedView:(UIPanGestureRecognizer *)pan{
    [_redView move:pan];
}
@end
