//
//  ViewController.m
//  ModelViewDemo
//
//  Created by wangdacheng on 2018/1/12.
//  Copyright © 2018年 qihoo. All rights reserved.
//

#import "ViewController.h"
#import "AlertViewController.h"


@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    
    UIButton *btn02 = [UIButton buttonWithType:UIButtonTypeSystem];
    btn02.frame = CGRectMake(15, 270, self.view.frame.size.width-30, 50);
    [btn02 setBackgroundColor:[UIColor lightGrayColor]];
    [btn02 setTitle:@"btn02" forState:UIControlStateNormal];
    [btn02 addTarget:self action:@selector(btn02Clicked:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:btn02];
}


- (void)btn02Clicked:(id)sender
{
    AlertViewController *testModelController = [[AlertViewController alloc] initWithHostViewController:self.navigationController completion:^(id presentedViewController, BOOL presented, BOOL backgroundTapped) {
        
    }];
    [testModelController toggle];
}


@end
