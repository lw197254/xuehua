//
//  GiftModel.h
//  Day12-幸运转盘
//
//  Created by 刘伟 on 16/8/8.
//  Copyright © 2016年 Yin jianxun. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface GiftModel : NSObject
@property(nonatomic,copy)NSString*giftName;
@property(nonatomic,assign)NSUInteger canSelectedLevel;
@property(nonatomic,assign)NSUInteger index;
@end
