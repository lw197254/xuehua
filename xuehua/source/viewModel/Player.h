//
//  Player.h
//  xuehua
//
//  Created by 刘伟 on 2017/11/22.
//  Copyright © 2017年 test. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <AVFoundation/AVFoundation.h>
typedef void(^PlayEndBlock)(AVAudioPlayer*player);
typedef NS_ENUM(NSInteger,PlayType){
    ///只播放当前音乐，完成后结束
    PlayTypeOnce = 0,
    ///单曲循环
    PlayTypeSingleRecycle = 1,
    ///循环
    PlayTypeRecycle = 2,
    ///播放整个列表
    PlayTypeAll = 3,
};
@interface Player : NSObject
+(instancetype)shareInstance;
-(void)playerWithSourceName:(NSString*)name type:(NSString*)type numberOfLoops:(NSInteger)numberOfLoops playEndBlock:(PlayEndBlock)playEndBlock;
-(void)addPlayWithSourceName:(NSString*)name type:(NSString*)type inumberOfLoops:(NSInteger)numberOfLoops;
@end
