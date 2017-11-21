//
//  SetViewController.m
//  xuehua
//
//  Created by 刘伟 on 16/7/27.
//  Copyright © 2016年 test. All rights reserved.
//

#import "SetViewController.h"
#import "EasyKit.h"
@interface SetViewController ()
@property(nonatomic,copy)SetFinishedBlock block;
@end

@implementation SetViewController
- (void)viewDidLoad {
    [super viewDidLoad];
    @weakify(self);
    [[self.textField.rac_textSignal filter:^BOOL(NSString* text) {
        @strongify(self);
        if (text.length >6) {
            self.textField.userInteractionEnabled = NO;
        }
        return YES;
    }]
     subscribeNext:^(id x) {
        @strongify(self);
    }];
    
    // Do any additional setup after loading the view.
}
- (IBAction)confirm:(UIButton *)sender {
    if (_nameField.text.length >3) {
        
    }
    
    
    
    if (_block) {
        NSString*name =@"";
        if (_nameField.text) {
            name = _nameField.text;
        }
        NSString*title = @"";
        if (_textField.text) {
            title = _textField.text;
        }
        _block(name,title);
         [self dismissViewControllerAnimated:YES completion:nil];
    }
}
-(void)finishedSet:(SetFinishedBlock)block{
    if (_block!=block) {
        _block  = block;
    }
   
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
