//
//  UserModel.h
//  Day12-幸运转盘
//
//  Created by 刘伟 on 16/8/8.
//  Copyright © 2016年 Yin jianxun. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface UserModel : NSObject
@property(nonatomic,strong)NSArray*canSelectedArray;
@property(nonatomic,assign)NSUInteger level;
+(instancetype)shareInstance;
@end
