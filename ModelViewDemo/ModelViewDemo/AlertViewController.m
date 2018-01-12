//
//  TestModelViewController.m
//  QHPocket
//
//  Created by wangdacheng on 2017/12/29.
//  Copyright © 2017年 qihoo. All rights reserved.
//

#import "AlertViewController.h"

@interface AlertViewController ()

@end

@implementation AlertViewController

- (instancetype)initWithHostViewController:(UIViewController *)hostViewController completion:(void (^)(id, BOOL, BOOL))animationCompletion
{
    self = [super initWithHostViewController:hostViewController completion:animationCompletion];
    if (self) {
        self.maskViewAlpha = 0.6;
        self.maskViewColor = [UIColor blackColor];
        self.maskViewTapEnabled = YES;
        
        self.direction = DirectionType_BottomUp;
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    
}

@end
