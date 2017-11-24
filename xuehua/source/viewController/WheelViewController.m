//
//  ViewController.m
//  Day12-幸运转盘
//
//  Created by Yin jianxun on 16/6/22.
//  Copyright © 2016年 Yin jianxun. All rights reserved.
//

#import "WheelViewController.h"
#import "YZLuckyWheel.h"
#import "Masonry.h"
#import "Player.h"
@interface WheelViewController ()
@property(nonatomic,strong)YZLuckyWheel*wheelView;

@end

@implementation WheelViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor =[UIColor whiteColor];
//    //设置背景
//    self.view.layer.contents = (__bridge id _Nullable)([UIImage imageNamed:@"LuckyBackground"].CGImage);
    
    //在storyBoard中设置 三个按钮
    //参照board
    
    //设置转盘 从XIB文件中加载
    self.wheelView = [YZLuckyWheel loadWheelXib];
//    wheelView.center = self.view.center;
    [self.view addSubview: self.wheelView];
    [ self.wheelView sizeToFit];
   
//    UIButton*button = [UIButton buttonWithType:UIButtonTypeSystem];
//    [button setTitle:@"打开" forState:UIControlStateNormal];
//    [button addTarget:self action:@selector(next:) forControlEvents:UIControlEventTouchUpInside];
//    [button setBackgroundColor:[UIColor blackColor]];
//    [button setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
//    [self.view addSubview:button];
    [ self.wheelView setTranslatesAutoresizingMaskIntoConstraints:NO];
//    [button setTranslatesAutoresizingMaskIntoConstraints:NO];
    UILabel*label = [[UILabel alloc]init];
    label.text = @"请选择一位带回家";
    label.textAlignment = NSTextAlignmentCenter;
    [self.view addSubview:label];
    [label mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self.view);
        make.bottom.equalTo( self.wheelView.mas_top).offset(-60);
    }];
    [ self.wheelView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.centerY.equalTo(self.view);
    }];
    
    UIButton*back = [UIButton buttonWithType:UIButtonTypeSystem];
    [back setTitle:@"点我返回到最初界面" forState:UIControlStateNormal];
    [self.view addSubview:back];
    [back addTarget:self action:@selector(backToHome) forControlEvents:UIControlEventTouchUpInside];
    [back mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo( self.wheelView.mas_bottom).offset(40);
        make.centerX.equalTo(self.view);
    }];
    
//    UIButton*daluan = [UIButton buttonWithType:UIButtonTypeSystem];
//    [daluan setTitle:@"打乱" forState:UIControlStateNormal];
//    [self.view addSubview:daluan];
//    [daluan addTarget:self action:@selector(daluan) forControlEvents:UIControlEventTouchUpInside];
//    [daluan mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.top.equalTo( label.mas_bottom).offset(5);
//        make.centerX.equalTo(self.view);
//    }];
//    [self.view addConstraint:[NSLayoutConstraint constraintWithItem:wheelView attribute:NSLayoutAttributeCenterX relatedBy:NSLayoutRelationEqual toItem:self.view attribute:NSLayoutAttributeCenterX multiplier:1.0 constant:0]];
    
//    [self.view addConstraint:[NSLayoutConstraint constraintWithItem:wheelView attribute:NSLayoutAttributeTop relatedBy:NSLayoutRelationEqual toItem:self.luckWheelImageView attribute:NSLayoutAttributeBottom multiplier:1.0 constant:10]];
    
//     [self.view addConstraint:[NSLayoutConstraint constraintWithItem:button attribute:NSLayoutAttributeTop relatedBy:NSLayoutRelationEqual toItem:wheelView attribute:NSLayoutAttributeBottom multiplier:1.0 constant:20]];
//    [self.view addConstraint:[NSLayoutConstraint constraintWithItem:button attribute:NSLayoutAttributeCenterX relatedBy:NSLayoutRelationEqual toItem:self.view attribute:NSLayoutAttributeCenterX multiplier:1.0 constant:0]];
//    [button addConstraint:[NSLayoutConstraint constraintWithItem:button attribute:NSLayoutAttributeWidth relatedBy:NSLayoutRelationEqual toItem:nil attribute:NSLayoutAttributeNotAnAttribute multiplier:1.0 constant:60]];
//    [button addConstraint:[NSLayoutConstraint constraintWithItem:button attribute:NSLayoutAttributeHeight relatedBy:NSLayoutRelationEqual toItem:nil attribute:NSLayoutAttributeNotAnAttribute multiplier:1.0 constant:44]];
    //转动
//    [wheelView start];
    NSString*liuwei = @"刘\n伟\n";
    NSMutableArray*array  = [[NSMutableArray alloc]init];
    NSArray*nameArray = @[@"李\n易\n峰\n",@"吴\n亦\n凡\n",@"鹿\n晗\n",
                          @"杨\n洋\n",@"井\n柏\n然\n",@"马\n天\n宇\n",
                          @"张\n艺\n兴\n",@"李\n治\n廷\n",@"陈\n伟\n霆\n",
                          liuwei,@"单\n身\n",@"刘\n昊\n然\n"];
    for (NSInteger i = 0; i < 12; i++) {
        GiftModel*model = [[GiftModel alloc]init];
        model.index = i;
        
        model.giftName = nameArray[i];
        if ([model.giftName isEqualToString:liuwei]) {
            model.canSelectedLevel = 0;
        }else{
            model.canSelectedLevel = 10;
        }
        [array addObject:model];
    }
     self.wheelView.giftArray =array ;
    
}
-(void)daluan{
    NSMutableArray*array =[NSMutableArray arrayWithArray:self.wheelView.giftArray];
    NSMutableArray*newArray = [NSMutableArray array];
    for (NSInteger i = 0; i < self.wheelView.giftArray.count; i++) {
        NSInteger index = arc4random()%array.count;
        [newArray addObject:array[index]];
        [array removeObjectAtIndex:index];
        
    }
    
    [self.wheelView reSetGifArray:newArray];
}
-(void)backToHome{
    if (self.presentingViewController) {
//        [self dismissViewControllerAnimated:YES completion:^{
//            if(self.presentedViewController.presentedViewController){
                [self.presentingViewController.presentingViewController dismissViewControllerAnimated:YES completion:nil];
//            }
        
//        }];
    }
    [[Player shareInstance]playerWithSourceName:@"Lorelei" type:@"mp3" numberOfLoops:-1 playEndBlock:^(AVAudioPlayer *player) {
        
    }];
}
-(void)next:(UIButton*)sender{
    
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
