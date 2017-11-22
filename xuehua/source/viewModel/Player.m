//
//  Player.m
//  xuehua
//
//  Created by 刘伟 on 2017/11/22.
//  Copyright © 2017年 test. All rights reserved.
//

#import "Player.h"

#import <EasyIOS.h>

@interface Player()<AVAudioPlayerDelegate>
@property(nonatomic,strong)NSMutableArray*playerNameArray;
@property(nonatomic,strong)NSMutableDictionary*playerDict;
@property(nonatomic,strong)NSMutableDictionary*playEndBlockDict;
@property(nonatomic,assign)NSInteger currenIndex;
@property(nonatomic,assign)PlayType playType;


@end
@implementation Player
+(instancetype)shareInstance{
    static Player*instance;
    static dispatch_once_t predicate;
    dispatch_once(&predicate, ^{
        instance = [[Player alloc]init];
    });
    return instance;
}
-(void)playerWithSourceName:(NSString*)name type:(NSString*)type numberOfLoops:(NSInteger)numberOfLoops playEndBlock:(PlayEndBlock)playEndBlock{
   
    NSString*key = [self keyFromSourceName:name type:type];
    if (playEndBlock) {
        [self.playEndBlockDict setObject:playEndBlock forKey:key];
    }
    __block BOOL isFind = NO;
    [self.playerNameArray enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        if ([obj isEqualToString:key]) {
            isFind  =YES;
            self.currenIndex = idx;
            AVAudioPlayer*playler = [self.playerDict objectForKey:key];
            [playler play];
            *stop = YES;
            
        }
    }];
    
    if (isFind==NO) {
        AVAudioPlayer*playler = [self playerWithSource:name type:type];
        if (!playler) {
            return;
        }
        
        playler.numberOfLoops = numberOfLoops;
        
        
        [self.playerNameArray addObject:key];
        self.currenIndex = self.playerNameArray.count-1;
        [self.playerDict setObject:playler forKey:key];
        [playler play];
    }
    
}

-(void)playerWithSourceName:(NSString*)name type:(NSString*)type numberOfLoops:(NSInteger)numberOfLoops{
    
    [self playerWithSourceName:name type:type numberOfLoops:numberOfLoops playEndBlock:nil];
    
    
}
-(NSString*)keyFromSourceName:(NSString*)sourceName type:(NSString*)type{
    NSString*key = [NSString stringWithFormat:@"%@.%@",sourceName,type].MD5;
    return key;
}
-(void)addPlayWithSourceName:(NSString*)name type:(NSString*)type inumberOfLoops:(NSInteger)numberOfLoops{
    
     NSString*key = [self keyFromSourceName:name type:type];
    __block BOOL isFind = NO;
    [self.playerNameArray enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        if ([obj isEqualToString:key]) {
            isFind  =YES;
//            id last = self.playerNameArray.lastObject;
//            [self.playerNameArray replaceObjectAtIndex:idx withObject:last];
//            [self.playerNameArray replaceObjectAtIndex:self.playerNameArray.count-1 withObject:obj];
            *stop = YES;
            
        }
    }];
   
    if (isFind==NO) {
        [self.playerNameArray addObject:key];
        AVAudioPlayer*playler = [self playerWithSource:name type:type];
        
        
            playler.numberOfLoops = numberOfLoops;
       
         [self.playerDict setObject:playler forKey:name];
    }
   
    
    
   
}

-(AVAudioPlayer*)playerWithSource:(NSString*)sourceName type:(NSString*)type{
    
    NSString *path = [[NSBundle mainBundle] pathForResource:sourceName ofType:type];
    
    
    NSString*fireworkPath = [[NSBundle mainBundle] pathForResource:sourceName ofType:type];
    
    NSError*error;
    if (fireworkPath==nil) {
        return nil;
    }

    AVAudioPlayer *player =[[AVAudioPlayer alloc] initWithData:[NSData dataWithContentsOfFile:path] error:nil];
    if (player==nil) {
        NSURL *url = [NSURL fileURLWithPath:fireworkPath];
         player =  [[AVAudioPlayer alloc]initWithContentsOfURL:url error:&error];
    }
    
    if (error) {
        NSLog(@"%@",error.description);
    }
    // self.player.numberOfLoops = 1;
    player.delegate = self;
    
    
    
    player.volume = 1;
    return player;
    
}
-(void)audioPlayerDidFinishPlaying:(AVAudioPlayer *)player successfully:(BOOL)flag{
    
    if (flag == YES) {
        NSString*key = self.playerNameArray[self.currenIndex];
       
        PlayEndBlock block = [self.playEndBlockDict objectForKey:key];
        if (block) {
            block(player);
        }
        switch (self.playType) {
            case PlayTypeOnce:
                
                break;
            case PlayTypeSingleRecycle:
                [player play];
                break;
            case PlayTypeRecycle:{
                if (self.currenIndex!=self.playerNameArray.count-1) {
                    self.currenIndex++;
                   
                }else{
                    self.currenIndex = 0;
                }
                NSString*key = self.playerNameArray[self.currenIndex];
                AVAudioPlayer*playler = [self.playerDict objectForKey:key];
                [playler play];
            }
                break;
            case PlayTypeAll:{
                if (self.currenIndex!=self.playerNameArray.count-1) {
                    self.currenIndex++;
                    NSString*key = self.playerNameArray[self.currenIndex];
                    AVAudioPlayer*playler = [self.playerDict objectForKey:key];
                    [playler play];
                }
               
            }
                
                break;
                
            default:
                break;
        }
      
    }
    
//    [self tap:nil];
//    if (player!=_playerDict[@"papapa"]) {
//        AVAudioPlayer*playler1 = [self playerWithSourceName:@"papapa" type:@"mp3"];
//        [_playerDict setObject:playler1 forKey:@"papapa"];
//        [playler1 play];
//    }
    
    
    
    
}
-(NSMutableArray*)playerNameArray{
    if (!_playerNameArray) {
        _playerNameArray = [NSMutableArray array];
    }
    return _playerNameArray;
}
-(NSMutableDictionary*)playerDict{
    if (!_playerDict) {
        _playerDict = [NSMutableDictionary  dictionary];
    }
    return _playerDict;
}
-(NSMutableDictionary*)playEndBlockDict{
    if (!_playEndBlockDict) {
        _playEndBlockDict = [NSMutableDictionary  dictionary];
    }
    return _playEndBlockDict;
}
@end
