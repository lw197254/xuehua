//
//  ViewController.m
//  xuehua
//
//  Created by yq on 16/5/13.
//  Copyright © 2016年 test. All rights reserved.
//

#import "ViewController.h"
#import "YQPant.h"
#import "RainViewController.h"

@interface ViewController ()

@property (weak, nonatomic) IBOutlet YQPant *pantView;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];



}
//五，开始会话

 -(IBAction)action_cancle:(UIButton *)sender {
    [_pantView back];
   
}

- (IBAction)action_save:(UIButton *)sender {
    [_pantView save];
    
}

- (IBAction)action_next:(UIButton *)sender {
    RainViewController *rvc = [[RainViewController alloc] init];
    rvc.points = [_pantView readData];
    [self presentViewController:rvc animated:YES completion:^{
        
    }];
}
- (IBAction)clearPanClicked:(UIButton *)sender {
    [_pantView clear];
}

@end
