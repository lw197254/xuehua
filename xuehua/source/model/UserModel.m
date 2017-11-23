//
//  UserModel.m
//  Day12-幸运转盘
//
//  Created by 刘伟 on 16/8/8.
//  Copyright © 2016年 Yin jianxun. All rights reserved.
//

#import "UserModel.h"

@implementation UserModel
+(instancetype)shareInstance{
    static id  instcance;
   static dispatch_once_t predicate;
    dispatch_once(&predicate, ^{
        instcance = [[[self class] alloc]init];
    });
    return instcance;
}
@end
