//
//  ViewController.m
//  LKQRtest
//
//  Created by 888 on 16/8/5.
//  Copyright © 2016年 lk. All rights reserved.
//

#import "ViewController.h"

#import "LKQrCodeVC.h"

@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
- (IBAction)or:(id)sender {
    
    LKQrCodeVC *vc = [[LKQrCodeVC alloc] init];
    
    [self presentViewController:vc animated:YES completion:nil];
}

@end
