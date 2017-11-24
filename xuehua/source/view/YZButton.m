//
//  YZButton.m
//  Day12-幸运转盘
//
//  Created by Yin jianxun on 16/6/22.
//  Copyright © 2016年 Yin jianxun. All rights reserved.
//

#import "YZButton.h"

@implementation YZButton

//由于裁剪完的图片不是和系统button一般大小的，因此会产生图片被拉伸的问题，因此需要自定义button的ImageView大小
-(CGRect)imageRectForContentRect:(CGRect)contentRect{
    
    CGFloat W = 40;
    CGFloat H = 46;
    CGFloat X = (contentRect.size.width - W) * 0.5;
    CGFloat Y = 20;
    
    
    return CGRectMake(X, Y , W , H );
    
}




/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
