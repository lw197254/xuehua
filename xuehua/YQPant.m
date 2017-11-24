//
//  YQPant.m
//  xuehua
//
//  Created by yq on 16/5/13.
//  Copyright © 2016年 test. All rights reserved.
//

#import "YQPant.h"
#import "NSString+bezierPath.h"
@interface YQPant ()

@property (nonatomic, strong) NSMutableArray<UIBezierPath *> *pathArr;
@property (nonatomic, strong) NSMutableArray<NSMutableArray *> *totalArr;

@end

@implementation YQPant

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    if (!_totalArr) {
        _totalArr = [NSMutableArray array];
    }
    if (!_pathArr) {
        _pathArr = [NSMutableArray array];
        
    }
    
    UIBezierPath* aPath = [UIBezierPath bezierPath];
    
    aPath.lineWidth = 5.0;
    aPath.lineCapStyle = kCGLineCapRound; //线条拐角
    aPath.lineJoinStyle = kCGLineCapRound; //终点处理
    [_pathArr addObject:aPath];

    
    NSMutableArray *pointsArr = [NSMutableArray array];
    
    [_totalArr addObject:pointsArr];
    
    CGPoint point = [touches.anyObject locationInView:self];
    [pointsArr addObject:[NSValue valueWithCGPoint:point]];
    
    [_pathArr.lastObject moveToPoint:point];
}

- (void)touchesMoved:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    CGPoint point = [touches.anyObject locationInView:self];
    [_totalArr.lastObject addObject:[NSValue valueWithCGPoint:point]];
    [self setNeedsDisplay];
    
    [_pathArr.lastObject addLineToPoint:point];
}

- (void)back {
    [_totalArr removeLastObject];
    [_pathArr removeLastObject];
    [self setNeedsDisplay];
}
-(void)clear{
    [_totalArr removeAllObjects];
    [_pathArr removeAllObjects];
    [self setNeedsDisplay];
}
- (void)save {
//    UIBezierPath*path = [@"喜欢" bezierPathWithfontSize:206];
//
//
//
//    CAShapeLayer *layer = [CAShapeLayer layer];
//    layer.bounds = CGPathGetBoundingBox(path.CGPath);
//    layer.position = CGPointMake(self.bounds.size.width/2, 50);
//    layer.geometryFlipped = YES;
//    layer.path = path.CGPath;
//    layer.fillColor = [UIColor clearColor].CGColor;
//    layer.lineWidth = 1;
//    layer.strokeColor = [UIColor blackColor].CGColor;
//    CABasicAnimation *animation = [CABasicAnimation animationWithKeyPath:@"strokeEnd"];
//    animation.fromValue = @(0);
//    animation.toValue = @(1);
//    animation.duration = layer.bounds.size.width/20;
//    [layer addAnimation:animation forKey:nil];
//    [self.layer addSublayer:layer];
    
    NSMutableArray *tmp = [NSMutableArray arrayWithCapacity:256];
    for (NSMutableArray *arr in _totalArr) {
        for (NSValue *pv in arr) {
             NSString *str = [NSString stringWithFormat:@"%f,%f", [pv CGPointValue].x, pv.CGPointValue.y];
            [tmp addObject:str];
        }
    }
//
//    NSString *sandBox = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES).lastObject;
//
//    NSString *plistPath = [sandBox stringByAppendingString:@"test.plist"];
//    NSMutableArray *tmp1 = [NSMutableArray arrayWithCapacity:256];
//    NSArray*tmp = [@"喜欢" positionArrayWithfontSize:206];
//    for (NSValue *pv in tmp) {
//        NSString *str = [NSString stringWithFormat:@"%f,%f", [pv CGPointValue].x, pv.CGPointValue.y];
//        [tmp1 addObject:str];
//    }
    NSString *plistPath = @"/Users/liuwei/Desktop/position";
//   NSString *plistPath =   [NSHomeDirectory() stringByAppendingFormat:@"/Library/Caches/test.plist"];
    [tmp writeToFile:plistPath atomically:YES];
    
    
}

- (NSMutableArray *)readData {
//    NSString *sandBox = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES).lastObject;
//    [NSHomeDirectory() stringByAppendingFormat:@"/Library/Caches/headImage.png"];
//    NSString *plistPath = [sandBox stringByAppendingString:@"test.plist"];
//    NSString *plistPath =   [NSHomeDirectory() stringByAppendingFormat:@"/Library/Caches/test.plist"];
     NSString *plistPath = [[NSBundle mainBundle]pathForResource:@"test1" ofType:@"plist"];
    NSMutableArray *arr = [NSMutableArray arrayWithContentsOfFile:plistPath];
   
    NSMutableArray *rs = [NSMutableArray arrayWithCapacity:256];
    for (NSString *str in arr) {
        NSArray *sa = [str componentsSeparatedByString:@","];
        if (sa.count == 2) {
            [rs addObject:[NSValue valueWithCGPoint:CGPointMake((int)[sa[0] floatValue], (int)[sa[1] floatValue])]];
        }
    }
    return rs;
}

- (void)drawRect:(CGRect)rect {
    for (UIBezierPath *path in _pathArr) {
        [path stroke];
    }

}

@end
