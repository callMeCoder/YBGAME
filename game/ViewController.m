//
//  ViewController.m
//  game
//
//  Created by pepinot on 16/3/20.
//  Copyright © 2016年 CMC. All rights reserved.
//

#import "ViewController.h"
#import "UIView+Ex.h"

#define SCREEN_WIDTH     [UIScreen mainScreen].bounds.size.width
#define SCREEN_HEIGHT    [UIScreen mainScreen].bounds.size.height
@interface ViewController ()<UIAlertViewDelegate>
@property (nonatomic, weak)UIView *subView1; // 初始化的view1
@property (nonatomic, weak)UIView *subView2;// 初始化的view2
@property (nonatomic, weak) UIView *backgroundView;
@property (nonatomic, strong) UIView *personView;
@property (nonatomic, strong) CADisplayLink *link;
@property (nonatomic, assign,getter=isUp) BOOL up;
@property (nonatomic, weak) UIImageView *image;
@property (nonatomic, assign) int count;
@property (weak, nonatomic) IBOutlet UILabel *label;

@property (strong, nonatomic) IBOutletCollection(UILabel) NSArray *labelArray;

@end
@implementation ViewController



- (void)viewDidLoad {

    [self setUpUI];
}
- (void)setUpUI
{
    self.up = YES;
    self.count = 1;
    self.label.layer.cornerRadius = 10;
    self.label.layer.masksToBounds = YES;
    self.label.text = [NSString stringWithFormat:@"%zd",self.count];
    self.view.backgroundColor = [UIColor colorWithRed:(236 / 255.0) green:(200/ 255.0) blue:(154 / 255.0) alpha:1.0];
    UIView *backgroundView = [[UIView alloc] init];
    self.backgroundView = backgroundView;
    backgroundView.x = 0;
    backgroundView.y = SCREEN_HEIGHT * 0.5f;
    backgroundView.width = SCREEN_WIDTH;
    backgroundView.height = SCREEN_HEIGHT * 0.5f;
    [self.view addSubview:backgroundView];
    
    
    UIView *subView1 = [[UIView alloc] init];
    self.subView1 = subView1;
    subView1.x = 0;
    subView1.width = 50;
    subView1.height = backgroundView.height - subView1.y;
    [backgroundView addSubview:subView1];
    subView1.backgroundColor = [UIColor blackColor];
    
    
    UIImageView *image = [[UIImageView alloc] init];
    self.image = image;
    image.image = [UIImage imageNamed:@"deliveryStaff0"];
    [image sizeToFit];
    self.image.x = 50 - self.image.width + 15;
    image.y = 0;
    [backgroundView addSubview:image];
    subView1.y = image.height;
    
    
    UIView *subView2 = [[UIView alloc] init];
    self.subView2 = subView2;
    subView2.height = backgroundView.height - subView1.y;
    subView2.y = subView1.y;
    CGFloat x = 0;
    CGFloat marginRandom = 0;
    CGFloat wid = 0;
    do {
        wid = arc4random_uniform(50) + 20;
        marginRandom = CGRectGetMaxX(subView1.frame) + 20;
        x = arc4random_uniform(SCREEN_WIDTH  - wid - 20) + marginRandom;
    } while (wid + x > (SCREEN_WIDTH - 20));
    
    subView2.x = x;
    subView2.width = wid;
    [backgroundView addSubview:subView2];
    subView2.backgroundColor = [UIColor blackColor];
    
}
- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event
{
    UIView *personView = [[UIView alloc] init];
    self.personView = personView;
    personView.x = 50;
    personView.y = self.subView1.y;
    personView.width = 5;
    personView.height = 0;
    personView.backgroundColor = [UIColor blackColor];
    [self.backgroundView addSubview:personView];
    CADisplayLink *link = [CADisplayLink displayLinkWithTarget:self selector:@selector(longPressAction)];
    self.link = link;
    [link addToRunLoop:[NSRunLoop currentRunLoop] forMode:NSDefaultRunLoopMode];
}
- (void)touchesEnded:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event
{
    [self.link removeFromRunLoop:[NSRunLoop currentRunLoop] forMode:NSDefaultRunLoopMode];
    self.personView.y *= 0.5;
    self.personView.y += (3 *self.personView.width + 27);
    self.personView.layer.anchorPoint = CGPointMake(1, 1);
    self.personView.x -= 3;
    [UIView animateWithDuration:0.5f animations:^{
            self.personView.transform = CGAffineTransformMakeRotation(M_PI_2);
    }completion:^(BOOL finished) {
        [UIView animateWithDuration:1.0f animations:^{
            self.image.x = CGRectGetMaxX(self.personView.frame);
            [self personFrameAnimation];
        }completion:^(BOOL finished) {
            if (self.subView2.x < CGRectGetMaxX(self.personView.frame) && CGRectGetMaxX(self.subView2.frame) > CGRectGetMaxX(self.personView.frame)) {
                self.label.text = [NSString stringWithFormat:@"%zd",++self.count];
                [self.labelArray makeObjectsPerformSelector:@selector(setHidden:) withObject:@YES];
                [self.personView removeFromSuperview];
                [self movesubView2Action];
            }else{
                [UIView animateWithDuration:.5f animations:^{
                    self.personView.transform = CGAffineTransformMakeRotation(M_PI);
                    self.image.y = self.backgroundView.height;
                }completion:^(BOOL finished) {
                    [self.personView removeFromSuperview];
                    self.count = 0;
                    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"游戏结束" message:@"你挂啦~!" delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"重新开始", nil];
                    [alert show];
                }];
            }
        }];
    }];
}
- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (buttonIndex == 1) {
        [self.backgroundView removeFromSuperview];
        for (UILabel *label in self.labelArray) {
            label.hidden = NO;
        }
        [self setUpUI];
    }
}
- (void)personFrameAnimation
{
    //  动画正在播放时不进行任何操作
    if ([self.image isAnimating])return;
    NSMutableArray *images = [NSMutableArray array];
    // for循环拿到图片并且存入数组中
    for (int i  = 0; i < 4; i++) {
        NSString *image = [NSString stringWithFormat:@"deliveryStaff%zd.png",i];
        // 保证缓存释放,用bould
        NSBundle *bundle = [NSBundle mainBundle];
        // 拿到绝对路径
        NSString *path = [bundle pathForResource:image ofType:nil];
        [images addObject:[UIImage imageWithContentsOfFile:path]];
    }
    self.image.animationImages = images;
    // 只播放一次动画
    self.image.animationRepeatCount = CGFLOAT_MAX;
    // 持续时间延长
    double detla = 0.05;
    self.image.animationDuration = images.count * detla;
    [self.image startAnimating];
    double deply = self.image.animationDuration + 1;
    [self.image performSelector:@selector(setAnimationImages:) withObject:nil afterDelay:deply];
}
- (void)movesubView2Action
{
        [UIView animateWithDuration:0.5f animations:^{
            self.subView2.x = 50 - self.subView2.width;
            self.subView1.x = 0 - self.subView1.width;
            self.image.x = 50 - self.image.width + 15;
        }completion:^(BOOL finished) {
            [self.subView1 removeFromSuperview];
            self.subView1 = self.subView2;
            UIView *subView2 = [[UIView alloc] init];
            self.subView2 = subView2;
            subView2.height = SCREEN_HEIGHT * 0.5 - self.subView1.y;
            subView2.x = SCREEN_WIDTH;
            subView2.y = self.subView1.y;
            CGFloat x = 0;
            CGFloat marginRandom = 0;
            CGFloat wid = 0;
            do {
                wid = arc4random_uniform(50) + 20;
                marginRandom = CGRectGetMaxX(self.subView1.frame) + 20;
                x = arc4random_uniform(SCREEN_WIDTH  - wid - 20) + marginRandom;
            } while (wid + x > (SCREEN_WIDTH - 20));
    
            [UIView animateWithDuration:0.5f animations:^{
                subView2.x = x;
            }];
            subView2.width = wid;
            [self.backgroundView addSubview:subView2];
            subView2.backgroundColor = [UIColor blackColor];
        }];
}
- (void)longPressAction
{
    if (self.isUp) {
        self.personView.height += 2.f;
        self.personView.y -= 2.f;
        if (self.personView.height == SCREEN_HEIGHT * 0.5) {
            self.up = NO;
        }
    }else{
        self.personView.height -= 2.f;
        self.personView.y += 2.f;
        if (self.personView.height == 0.0) {
            self.up = YES;
        }
    }
}
@end
