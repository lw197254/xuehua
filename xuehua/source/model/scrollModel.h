//
//  scrollModel.h
//  Day12-幸运转盘
//
//  Created by 刘伟 on 16/8/2.
//  Copyright © 2016年 Yin jianxun. All rights reserved.
//

#import <Foundation/Foundation.h>

#define speedUpTime 1
#define speedDownTime 10
@interface scrollModel : NSObject
@property(nonatomic,assign) float speed;
@property(nonatomic,assign) float power;
@property(nonatomic,strong) NSDate *startDate;
-(void)resetPower;
@end
