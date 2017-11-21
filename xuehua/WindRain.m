//
//  WindRain.m
//  xuehua
//
//  Created by yq on 16/5/13.
//  Copyright © 2016年 test. All rights reserved.
//

#import "WindRain.h"

static const int TAG_STOP = 1024;

typedef void (^clicked)(UIButton *btn, WindRain *windRain);

@interface WindRain () {
    int repeatTime;
    int maxTime;
}



@property (nonatomic, strong) NSMutableArray<WindRainModel *> *models;

@property (nonatomic, copy) clicked clicked;
@property (nonatomic, copy) clicked moved;

@end

@implementation WindRain

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        repeatTime = 0;
        
        maxTime = 10;
        
        _models = [NSMutableArray array];
        
//        _timer = [NSTimer timerWithTimeInterval:0.02 target:self selector:@selector(timerAction:) userInfo:nil repeats:YES];
//        [[NSRunLoop mainRunLoop] addTimer:_timer forMode:NSDefaultRunLoopMode];
    }
    return self;
}

- (void)stopMove:(UIButton *)btn {
    btn.tag = TAG_STOP;
}

- (void)cleanTimer {
    [_timer invalidate];
    _timer = nil;
}

- (void)setupTimer {
    _timer = [NSTimer timerWithTimeInterval:0.02 target:self selector:@selector(timerAction:) userInfo:nil repeats:YES];
    [[NSRunLoop mainRunLoop] addTimer:_timer forMode:NSDefaultRunLoopMode];
}

- (void)timerAction:(NSTimer *)sender {
    __block int i = 0;
    __block NSInteger count = _models.count;
    while (i < count) {
        __block UIButton *btn = _models[i].rainBtn;
        
        if (btn.tag == TAG_STOP) {
            [_models removeObjectAtIndex:i];
            return;
        }
        
        if (btn && btn.center.y > [UIScreen mainScreen].bounds.size.height + 50) {
            [_models removeObjectAtIndex:i];
            [btn removeFromSuperview];
            btn = nil;
            count--;
        } else {
            //移动
            WindRainModel *model = _models[i];
            CGPoint p = model.center;
            p.y += _models[i].speed;
            model.center = p;
            if ((repeatTime & 7) == 0 && _moved) {//优化，减少cou使用率
                _moved(btn, self);
            }
            ++i;
        }
    }
    
    //随机时间
    repeatTime++;
    
    if (repeatTime > maxTime) {
        repeatTime = 0;
        int num = arc4random() % (_rainMaxCount > 0 ? _rainMaxCount : 4) + (_rainMinCount > 0 ? _rainMinCount : 3);
        [self createRain:num];
        maxTime = arc4random() % (_rainMaxTime > 0 ? _rainMaxTime : 60) + (_rainMinTime > 0 ? _rainMinTime : 30);
    }
}

- (void)dealloc {
    
}

- (void)createRain:(int)num {
    int w = 30;
    
    int tmpx = 0;
    int fangxiang = arc4random() & 1;
    if (fangxiang == 1) {
        tmpx = self.frame.size.width;
    }
    
    
    for (int i = 0; i < num; ++i) {
        WindRainModel *model = [WindRainModel new];
        if (_imgs) {
            model.backImg = _imgs[arc4random() % _imgs.count];
        }
        
        UIButton *btn = model.rainBtn;
        
        [btn addTarget:self action:@selector(action_click:) forControlEvents:UIControlEventTouchUpInside];
        
        w = btn.frame.size.width;
        int x = arc4random() % w / 2 ;
        
        if (fangxiang == 1) {
            tmpx -= x + w * (arc4random() % 2 + 1);
            if (tmpx < 0) {
                tmpx += arc4random() % w * 2 + w * 2;
            }
        } else {
            tmpx += x + w * (arc4random() % 2 + 1);
            if (tmpx > self.frame.size.width) {
                tmpx -= arc4random() % w * 2 + w * 2;
            }
        }
        
        int y = -1 * (40 + arc4random() % 100);
        model.center = CGPointMake(tmpx, y);
        
        [_models addObject:model];
        [self addSubview:btn];
    }
}

- (void)whenClicked:(void (^)(UIButton *btn, WindRain *windRain))clicked {
    if (clicked) {
        _clicked = clicked;
    }
}

- (void)whenMoved:(void (^)(UIButton *btn, WindRain *windRain))moved {
    _moved = moved;
}

- (void)action_click:(UIButton *)sender {
    if (_clicked) {
        _clicked(sender, self);
    }
}

@end



@interface WindRainModel () {
    int countFlag;
    int xCountForChange;
    int xDir;
    
    int angleDir;
    float angleEachChange;
}

@property (nonatomic, assign) float xEachChange;

@end

@implementation WindRainModel

- (CGFloat)speed {
    if (!_speed) {
        _speed = arc4random() % 200 / 100.0 + 0.6;
    }
    return _speed;
}

- (CGFloat)angle {
    if (!_angle) {
        _angle = arc4random() % 80 / 100.0 * ((arc4random() & 1) == 0 ? 1.0 : -1.0);
    }
    return _angle;
}

- (float)xEachChange {
    //让x轴的速度变化更加平稳
    if (countFlag < xCountForChange / 2) {
        _xEachChange += 0.015;
    } else {
        _xEachChange -= 0.015;
    }
    return _xEachChange;
}

- (UIButton *)rainBtn {
    if (!_rainBtn) {
        CGFloat scale = (arc4random() % 70 + 30) / 100.0;
        _rainBtn = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, self.backImg.size.width * scale, self.backImg.size.height * scale)];
        [_rainBtn setBackgroundImage:self.backImg forState:UIControlStateNormal];
        CGFloat angle1 = self.angle;
        _rainBtn.transform = CGAffineTransformMakeRotation(angle1);
        
        [self randNum];
    }
    return _rainBtn;
}

- (void)randNum {
    xCountForChange = arc4random() % 100 + 140;
    countFlag = 0;
    xDir = arc4random() & 1;
    angleDir = arc4random() & 1;
//    xEachChange = arc4random() % 100 / 100.0;
    angleEachChange = (arc4random() % 150 + 80) / 10000.0;
}

- (void)setCenter:(CGPoint)center {
    countFlag++;
    if (xDir) {
        center.x += self.xEachChange;
    } else {
        center.x -= self.xEachChange;
    }
    if (countFlag % xCountForChange == 0) {
        countFlag = 0;
        [self randNum];
        _xEachChange = 0;
    }
    _center = center;
    self.rainBtn.center = center;
    
    if (angleDir) {
        _rainBtn.transform = CGAffineTransformMakeRotation(_angle += angleEachChange);
    } else {
        _rainBtn.transform = CGAffineTransformMakeRotation(_angle -= angleEachChange);
    }
}

@end

















