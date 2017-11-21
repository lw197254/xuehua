//
//  WindRain.h
//  xuehua
//
//  Created by yq on 16/5/13.
//  Copyright © 2016年 test. All rights reserved.
//
#import <UIKit/UIKit.h>

@interface WindRain : UIView

@property (nonatomic, strong) NSTimer *timer;

/** 每次最大产生数量， default：7 设为<=0，无效 */
@property (nonatomic, assign) int rainMaxCount;
/** 每次最小产生数量， default：3设为<=0，无效 */
@property (nonatomic, assign) int rainMinCount;
/** 最大多少毫秒产生一次， default：90  设为<=0，无效 */
@property (nonatomic, assign) int rainMaxTime;
/** 最大多少毫秒产生一次， default：30  设为<=0，无效 */
@property (nonatomic, assign) int rainMinTime;

@property (nonatomic, strong) NSArray<UIImage *> *imgs;


- (void)stopMove:(UIButton *)btn;

- (void)whenClicked:(void (^)(UIButton *btn, WindRain *windRain))clicked;

- (void)whenMoved:(void (^)(UIButton *btn, WindRain *windRain))moved;

- (void)cleanTimer;

- (void)setupTimer;

@end

@interface WindRainModel : NSObject

/** 垂直降落速度 */
@property (nonatomic, assign) CGFloat speed;
@property (nonatomic, strong) UIImage *backImg;
@property (nonatomic, assign) CGFloat angle;

@property (nonatomic, strong) UIButton *rainBtn;

@property (nonatomic, assign) CGPoint center;

@end
