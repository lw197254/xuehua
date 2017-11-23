//
//  YZLuckyWheel.h
//  Day12-幸运转盘
//
//  Created by Yin jianxun on 16/6/22.
//  Copyright © 2016年 Yin jianxun. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "GiftModel.h"
@interface YZLuckyWheel : UIView

@property(nonatomic,strong)NSArray<GiftModel*>*giftArray;

//提供给外界的借口：用于加载XIB文件，
+ (instancetype)loadWheelXib;

//转动
- (void)start;
@end
