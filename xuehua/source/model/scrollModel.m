//
//  scrollModel.m
//  Day12-幸运转盘
//
//  Created by 刘伟 on 16/8/2.
//  Copyright © 2016年 Yin jianxun. All rights reserved.
//

#import "scrollModel.h"

@implementation scrollModel
-(instancetype)init{
    if ( self= [super init]) {
        _power = arc4random()%30 +100;
        _speed = 0;
    }
    return self;
}
-(void)resetPower{
    self.power = arc4random()%30 +100;
}
@end
