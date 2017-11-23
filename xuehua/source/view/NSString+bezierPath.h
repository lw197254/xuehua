//
//  NSString+bezierPath.h
//  xuehua
//
//  Created by 刘伟 on 2017/11/22.
//  Copyright © 2017年 test. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
#import <CoreGraphics/CoreGraphics.h>
@interface NSString (bezierPath)
- (UIBezierPath *)bezierPathWithfontSize:(float)fontSize;
@end
