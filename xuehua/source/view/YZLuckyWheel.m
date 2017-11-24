//
//  YZLuckyWheel.m
//  Day12-幸运转盘
//
//  Created by Yin jianxun on 16/6/22.
//  Copyright © 2016年 Yin jianxun. All rights reserved.
//

#import "YZLuckyWheel.h"
#import "YZButton.h"
#import "scrollModel.h"
#import "UserModel.h"
//#define kBtnNum 12

@interface YZLuckyWheel ()<UIAlertViewDelegate>

//转轮上的wheel
@property (weak, nonatomic) IBOutlet UIImageView *luckyWheel;

//按钮的集合
@property (nonatomic,strong) NSMutableArray *btnsArray;
@property(nonatomic,copy)NSDate*lastDate;
//记录选中状态的 按钮
@property (nonatomic,weak) YZButton *selectedBtn;
@property (nonatomic,assign) double aaa;
@property (nonatomic,assign) double R;
@property(nonatomic,assign)NSUInteger selectedIndex;
//link
@property (strong, nonatomic)  CADisplayLink *link;
@property (strong,nonatomic)scrollModel*model;
@property(assign,nonatomic)CGPoint selectedPoint;
@end


@implementation YZLuckyWheel

//#pragma mark - 动画停止时，弹出提示框
//-(void)animationDidStop:(CAAnimation *)anim finished:(BOOL)flag{
//    
//    UIAlertView *alert = [[UIAlertView alloc]initWithTitle:@"幸运号码" message:@"1,6,8" delegate:self cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
//    [alert show];
//    
//}
//
//- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
//{
//    
//    //删除核心动画
//    [self.luckyWheel.layer removeAnimationForKey:@"luck"];
//    
//    
//    //1.让转盘转到 真实的位置
//    CGFloat angle = 2 * M_PI /12  * self.selectedBtn.tag;
//    
//    angle = 10 * M_PI - angle;
//    
//    self.luckyWheel.transform = CGAffineTransformMakeRotation(angle);
//    
//    
//    //2.恢复旋转
////    self.link.paused = NO;
//    
//    
//    
//}


#pragma mark - 开始选号，监听按钮的响应事件
- (IBAction)startSelectAction:(UIButton *)sender {
     self.selectedBtn.selected = NO;
    [self start];
    //为了避免 多次点击选号按钮时重复出现提示框
    //需要进行当前的核心动画是否存在
//    if ([self.luckyWheel.layer animationForKey:@"luck"]) {
//        return;
//    }
    
//    self.link.paused = YES;
    
//    [self basicAnimation];
    
}


////核心动画
//- (void)basicAnimation{
//    
//    CABasicAnimation *basic = [CABasicAnimation animationWithKeyPath:@"transform.rotation"];
//    
////    basic.toValue = @(10 * M_PI);
////    basic.duration = 40;
////    basic.repeatCount = CGFLOAT_MAX;
////    
////    [self.luckyWheel.layer addAnimation:basic forKey:@"luck"];
//    
//    //每次转动完毕就让选中的按钮停止到12 点钟方向
//    CGFloat angle = 2 * M_PI /12  * self.selectedBtn.tag;
//    angle = 10 * M_PI - angle;
//    
//    //2.设置属性
//    basic.toValue = @(angle);
//    basic.duration = 2;
////    basic.speed = _model.power*speedUpTime;
//    //时间函数 速度函数
//    basic.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut];
//    
//    //让动画 停止不返回
//    basic.removedOnCompletion = NO;
//    basic.fillMode = kCAFillModeForwards;
//    
//    
//    //设置代理
//    basic.delegate = self;
//    
//    //3.添加动画
//    [self.luckyWheel.layer addAnimation:basic forKey:@"luck"];
//    
//    
//}

#pragma mark - 一开始转动
- (void)start{
    self.aaa = 0;
//    self.R = self.luckyWheel.bounds.size.height/2;
    self.R = 1;
    //创建link
    if (!_model) {
        _model = [[scrollModel alloc]init];
        
    }else{
        
        
        [_model resetPower];
        _model.speed = 0;
    }
   
    NSMutableArray*canSeletedModelArray = [[NSMutableArray alloc]init];
    [self.giftArray enumerateObjectsUsingBlock:^(GiftModel * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        if([UserModel shareInstance].level>=obj.canSelectedLevel){
            [canSeletedModelArray addObject:obj];
        }
    }];
    NSInteger i = arc4random()%canSeletedModelArray.count;
    GiftModel*giftModel= canSeletedModelArray[i];
    NSUInteger index = giftModel.index;
    if (index<=self.selectedIndex) {
        index=index+self.btnsArray.count;
    }
    NSInteger circle =self.btnsArray.count- (index-self.selectedIndex) +self.btnsArray.count*5;
//    NSInteger circle = self.btnsArray.count*5;
    double allAngle = circle*1.0/self.btnsArray.count*(M_PI*2*self.R);
  
    _model.power = allAngle*2/(speedDownTime*speedUpTime+speedUpTime*speedUpTime);
     
    
    
    if (!self.link) {
        self.link = [CADisplayLink displayLinkWithTarget:self selector:@selector(move)];
        
        [self.link addToRunLoop:[NSRunLoop mainRunLoop] forMode:NSDefaultRunLoopMode];
       
    }else{
         self.link.paused = NO;
    }
    _model.startDate = [NSDate new];
    self.lastDate = _model.startDate;
//    NSLog(@"f___f____%f",atan2(0, 0));
    
}

//转动速率
- (void)move{
    NSDate*date = [NSDate new];
    float during= [date timeIntervalSinceDate:_model.startDate];
    
    
    if (during <speedUpTime) {
        _model.speed = _model.power*during;
    }else{
        _model.speed = _model.power*speedUpTime-(during-speedUpTime)*_model.power*speedUpTime/speedDownTime;
    }
   
   
    
//    double ddd = atan2(self.luckyWheel.transform.b/self.luckyWheel.transform.a, self.luckyWheel.transform.a/self.luckyWheel.transform.b);
    double angle = acosf(self.luckyWheel.transform.a);
    if (self.luckyWheel.transform.b < 0) {
        angle = 2*M_PI-angle;
    }
     double PI = M_PI;
    angle = angle + (PI/_btnsArray.count);
    if (angle >=2*PI) {
        angle = angle-2*PI;
    }else if (angle <0){
        angle = 2*PI + angle;
    }
//    angle = M_PI*2-angle*2;
//  angle = angle -M_PI;
//    if (angle <0) {
//        angle =2*M_PI +angle*2;
//    }else{
//        angle = angle*2;
//    }
//    static double lastAngle = 0;
//    if (lastAngle -angle) {
//        <#statements#>
//    }
   
    NSInteger tag=  (angle*_btnsArray.count)/(2*PI);
    
   tag =  (_btnsArray.count- tag%(_btnsArray.count) )%_btnsArray.count;
//    if (tag < 0) {
//        tag = _btnsArray.count - (NSInteger)(fabs(tag));
//    }
//    tag = (_btnsArray.count - tag)%_btnsArray.count;
//    static NSInteger lastTag=0 ;
//    if (tag!=lastTag) {
//       NSLog(@"ddd = %f, angle=%f,tag= %ld,a=%f,b=%f,c=%f,d=%f,tx=%f,ty=%f",ddd,angle,tag,self.luckyWheel.transform.a,self.luckyWheel.transform.b,self.luckyWheel.transform.c,self.luckyWheel.transform.d,self.luckyWheel.transform.tx,self.luckyWheel.transform.ty);
//        lastTag = tag;
//    }
    
    if (_model.speed <= 0) {
        self.link.paused = YES;
       
        
//      NSInteger tag=  (angle+(M_PI*2/(2*_btnsArray.count)-M_PI_2) )/(M_PI*2/_btnsArray.count);
//        if (tag < 0) {
//            tag = _btnsArray.count - (NSInteger)(fabs(tag));
//        }
//        tag = tag%_btnsArray.count;
        YZButton*button = _btnsArray[tag];
        self.selectedBtn.selected = NO;
        
        //将按钮的状态变成 选中状态
        button.selected = YES;
        
        //将现在选中的按钮赋值给 选中标识
        self.selectedBtn = button;
        self.selectedIndex = button.tag;
        
    }
    double pinlv = [date timeIntervalSinceDate:self.lastDate];
    self.aaa+=pinlv;
    NSLog(@"%f",self.aaa);
    self.luckyWheel.transform = CGAffineTransformRotate(self.luckyWheel.transform, _model.speed/60);
    self.lastDate = date;
    
}



//添加的按钮的监听事件
- (void)clickBtn:(YZButton *)sender{
    return;
//    UIWindow * window=[[[UIApplication sharedApplication] delegate] window];
//    CGRect rect=[self.luckyWheel convertRect: self.luckyWheel.bounds toView:window];
////    CGPoint point =CGPointMake(rect.origin.x+rect.size.width/2, rect.origin.y+1);
// CGPoint point =    CGPointMake(self.luckyWheel.center.x, self.luckyWheel.center.y-2*self.R/2+1);
    CGRect senderRect = CGRectMake(sender.center.x-sender.bounds.size.width/2, sender.center.y-sender.bounds.size.height/2, sender.bounds.size.width, sender.bounds.size.height);
    if(senderRect.origin.x < self.selectedPoint.x&& self.selectedPoint.x <= senderRect.origin.x+senderRect.size.width&&self.selectedPoint.y <=senderRect.origin.y+senderRect.size.width&&senderRect.origin.y < self.selectedPoint.y){
        NSLog(@"ssssss");
    }
    //将之前的选中按钮的状态改变
    self.selectedBtn.selected = NO;
    
    //将按钮的状态变成 选中状态
    sender.selected = YES;
    
    //将现在选中的按钮赋值给 选中标识
    self.selectedBtn = sender;
    
}

#pragma mark - 懒加载 创建按钮

-(NSMutableArray *)btnsArray{
    
    if (!_btnsArray) {
        
        //开辟空间!!!!!!!
        _btnsArray = [NSMutableArray array];
        
        //创建12个按钮
        for (NSInteger i = 0 ; i < self.giftArray.count ; i++) {
            
            YZButton *btn = [[YZButton alloc]init];
//            btn.backgroundColor = [UIColor colorWithRed:arc4random_uniform(256) / 255.0 green:arc4random_uniform(256) / 255.0 blue:arc4random_uniform(256) / 255.0 alpha:1.0];
            
            //设置tag 为了计算当前选中按钮的角度
            btn.tag = i;
           
            //设置选中状态的背景图片
//            [btn setBackgroundImage:[UIImage imageNamed:@"LuckyRototeSelected"] forState:UIControlStateSelected];
            
#pragma mark - 裁剪图片
            //设置normal状态图片
            UIImage *normalImage = [self clipImage:@"LuckyAstrology" withIndex:i];
            GiftModel*giftModel = self.giftArray[i];
            btn.titleLabel.numberOfLines = 0;
            [btn setTitleColor:[UIColor grayColor] forState:UIControlStateNormal];
//            [btn setImage:normalImage forState:UIControlStateNormal];
            [btn setTitle:giftModel.giftName forState:UIControlStateNormal];
             [btn setTitleColor:[UIColor redColor] forState:UIControlStateSelected];
            [btn setTitleColor:[UIColor redColor] forState:UIControlStateHighlighted];
            //设置选中状态下的按钮图片
//            UIImage *selectedImage = [self clipImage:@"LuckyAstrologyPressed" withIndex:i];
//            [btn setImage:selectedImage forState:UIControlStateSelected];
            
            //监听按钮的点击事件
            [btn addTarget:self action:@selector(clickBtn:) forControlEvents:UIControlEventTouchUpInside];
            
            //改变按钮的锚点
            btn.layer.anchorPoint = CGPointMake(0.5, 1.0);
            
            
//            btn.center = self.luckyWheel.center;
//            btn.bounds = CGRectMake(0, 0, 100, 100);---->layoutSubViews中设置
            
            [self.luckyWheel addSubview:btn];
            
            [_btnsArray addObject:btn];
            
        }
    }
    
    
    return _btnsArray;
}

#pragma mark - 裁剪图片的方法 <---抽成方法

- (UIImage *)clipImage:(NSString *)imageName withIndex:(NSInteger)index{
    
    UIImage *image = [UIImage imageNamed:imageName];
    
    //裁剪位置的计算
    CGFloat scale = [UIScreen mainScreen].scale;
    
    CGFloat imageW = image.size.width / 12 * scale;
    CGFloat imageH = image.size.height * scale;
    CGFloat imageX = imageW * index;
    CGFloat imageY = 0;
    
    CGImageRef cgImage = CGImageCreateWithImageInRect(image.CGImage, CGRectMake(imageX, imageY, imageW, imageH));
    
    //裁剪后图片转化
    UIImage *clipImage = [UIImage imageWithCGImage:cgImage];
    
    CGImageRelease(cgImage);
    
    return clipImage;
}


-(void)layoutSubviews{
    
    [super layoutSubviews];
//    UIWindow * window=[[[UIApplication sharedApplication] delegate] window];
//    CGRect rect=[self.luckyWheel convertRect: self.luckyWheel.bounds toView:window];
    self.selectedPoint=CGPointMake(self.luckyWheel.center.x, 2*self.R/2+1);
    /**
     wheel图片 高286 宽286 -->像素
     每个按钮的图片 宽132 高286  -->像素
     添加的按钮 宽：132/2 = 66  -->点位
               高:286/2 = 143  -->点位
     */
    
    CGFloat btnW = 66;
    CGFloat btnH = 143;
    
    [self.btnsArray enumerateObjectsUsingBlock:^(YZButton *btn, NSUInteger idx, BOOL * _Nonnull stop) {
        
//        btn.frame = CGRectMake(self.luckyWheel.center.x * 0.5, self.luckyWheel.center.y * 0.5, btnW, btnH);
        
        btn.center = CGPointMake(self.bounds.size.width * 0.5, self.bounds.size.height * 0.5);
        
        btn.bounds = CGRectMake(0, 0, btnW, btnH);
        
        //修改角度
        //一个园别分成12分 对应于相应的按钮
        CGFloat angle = (2 * M_PI) / _btnsArray.count * idx;
        btn.transform = CGAffineTransformMakeRotation(angle);
//        btn.transform = CGAffineTransformRotate(btn.transform, angle);
        
    }];
    
}


#pragma mark - 加载XIB
//加载XIB文件 通过XIB文件名进行加载

+ (instancetype)loadWheelXib{
    
    return [[[NSBundle mainBundle]loadNibNamed:@"YZLuckyWheel" owner:nil options:nil]lastObject];
    
}


/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
