//
//  ViewController.m
//  CommonCategory
//
//  Created by  on 2018/4/28.
//  Copyright © 2018年 zcz. All rights reserved.
//

#import "ViewController.h"
#import "UIGestureRecognizer+Block.h"
@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    
    UIView *view = [[UIView alloc]initWithFrame:CGRectMake(0, 0, 100, 100)];
    view.backgroundColor = [UIColor redColor];
    view.center = self.view.center;
    [self.view addSubview:view];
    [view addGestureRecognizer:[UITapGestureRecognizer recognizeWithAction:^(id gestrueRecognize) {
        NSLog(@"点击了 view...");
    }]];
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
