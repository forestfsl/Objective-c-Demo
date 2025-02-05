//
//  SLOrderMenuView.m
//  WineMVVMDemo
//
//  Created by songlin on 31/10/2017.
//  Copyright © 2017 songlin. All rights reserved.
//

#import "SLOrderMenuView.h"

#define IMG_TAG     10086

@interface SLOrderMenuView ()

@property(nonatomic,strong)NSArray *array;

@property(nonatomic,strong)NSMutableArray *btnArray;

@end

@implementation SLOrderMenuView

- (instancetype)initWithFrame:(CGRect)frame withData:(NSArray *)array {
    if (self = [super initWithFrame:frame]) {
        self.array = array;
        [self configInterface];
        
    }
    return self;
}



- (void)configSelf {
   
}

- (void)configSubView {
    //  默认高度40
    CGFloat height = 40;
    UIImageView *bgImgView          = [[UIImageView alloc]initWithFrame:CGRectMake(self.frame.size.width - 160, 0, 150, height * self.array.count + 20)];
    bgImgView.tag                   = IMG_TAG;
    bgImgView.image                 = [UIImage imageNamed:@"orderBlack"];
    [self addSubview:bgImgView];
    
    
    [self.array enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        UIButton *btn               = [UIButton buttonWithType:UIButtonTypeCustom];
        //        btn.frame                   = CGRectMake(self.frame.size.width - 140 - 10, idx * height + 15, 130, height - 0.3);
        btn.frame                   = CGRectMake(self.frame.size.width - 140 - 10 + 150, idx * height + 15, 130, height - 0.3);
        btn.titleLabel.font         = [UIFont sl_NormalFont:16];
        btn.tag                     = idx + 100;
        btn.contentHorizontalAlignment = UIControlContentHorizontalAlignmentLeft;
        btn.titleEdgeInsets         = UIEdgeInsetsMake(0, 10, 0, 0);
        
        [btn setTitle:obj forState:UIControlStateNormal];
        [btn setTitleColor:SLCOLOR(252, 252, 252, 1) forState:UIControlStateNormal];
        [btn addTarget:self action:@selector(btnClick:) forControlEvents:UIControlEventTouchUpInside];
        [self addSubview:btn];
        
        UIView *line                = [[UIView alloc]initWithFrame:CGRectMake(self.frame.size.width - 150 + 150, idx * height + 39.7 + 15, 130, 0.3)];
        line.tag                    = idx + 200;
        line.backgroundColor        = SLCOLOR(220, 220, 220, 0.8);
        [self addSubview:line];
        
    }];
}

- (void)btnClick:(UIButton *)btn
{
    [self.clickSignal sendNext:@(btn.tag - 100)];
    [self removeFromSuperview];
}

- (void)beginAnimation
{
    [self.array enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        UIButton *btn       = [self viewWithTag:idx + 100];
        UIView *line        = [self viewWithTag:idx + 200];
        btn.frame           = CGRectMake(self.frame.size.width - 140 - 10 + 150, idx * 40 + 15, 130, 40 - 0.3);
        line.frame          = CGRectMake(self.frame.size.width - 150, idx * 40 + 39.7 + 15, 130, 0.3);
        [UIView animateWithDuration:0.3 + 0.05 * idx
                              delay:0.1
             usingSpringWithDamping:0.9
              initialSpringVelocity:1
                            options:UIViewAnimationOptionCurveEaseIn
                         animations:^{
                             btn.frame      = CGRectMake(self.frame.size.width - 140 - 10, idx * 40 + 15, 130, 40 - 0.3);
                             line.frame     = CGRectMake(self.frame.size.width - 150, idx * 40 + 39.7 + 15, 130, 0.3);
                         }
                         completion:^(BOOL finished) {
                             
                         }];
    }];
    UIImageView *imageView  = [self viewWithTag:IMG_TAG];
    imageView.frame         = CGRectMake(self.frame.size.width - 160 , 0, 150, 20);
    [UIView animateWithDuration:0.3
                          delay:0
         usingSpringWithDamping:0.9
          initialSpringVelocity:1
                        options:UIViewAnimationOptionCurveEaseIn
                     animations:^{
                         imageView.frame = CGRectMake(self.frame.size.width - 160 , 0, 150, 40 * self.array.count + 20);
                     }
                     completion:^(BOOL finished) {
                         
                     }];
}

- (void)dismiss
{
    [self.array enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        UIButton *btn       = [self viewWithTag:idx + 100];
        UIView *line        = [self viewWithTag:idx + 200];
        [UIView animateWithDuration:0.3 - 0.02 * idx
                              delay:0
             usingSpringWithDamping:0.9
              initialSpringVelocity:1
                            options:UIViewAnimationOptionCurveEaseIn
                         animations:^{
                             btn.frame      = CGRectMake(self.frame.size.width - 140 - 10 + 150, idx * 40 + 15, 130, 40 - 0.3);
                             line.frame     = CGRectMake(self.frame.size.width - 150 + 150, idx * 40 + 39.7 + 15, 130, 0.3);
                         }
                         completion:^(BOOL finished) {
                             
                         }];
    }];
    UIImageView *imageView  = [self viewWithTag:IMG_TAG];
    [UIView animateWithDuration:0.2
                          delay:0.2
         usingSpringWithDamping:1
          initialSpringVelocity:0.5
                        options:UIViewAnimationOptionCurveEaseIn
                     animations:^{
                         imageView.frame = CGRectMake(self.frame.size.width - 160 , 0, 150, 2);
                         imageView.alpha = 0.1;
                     }
                     completion:^(BOOL finished) {
                         imageView.alpha = 1;
                         [self removeFromSuperview];
                     }];
    
}
- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event
{
    [self dismiss];
}




@end
