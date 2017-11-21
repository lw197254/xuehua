//
//  SetViewController.h
//  xuehua
//
//  Created by 刘伟 on 16/7/27.
//  Copyright © 2016年 test. All rights reserved.
//

#import <UIKit/UIKit.h>
typedef void (^SetFinishedBlock) (NSString*name,NSString*text);
@interface SetViewController : UIViewController

@property (weak, nonatomic) IBOutlet UITextField *textField;
@property (weak, nonatomic) IBOutlet UITextField *nameField;
-(void)finishedSet:(SetFinishedBlock)block;
@end
