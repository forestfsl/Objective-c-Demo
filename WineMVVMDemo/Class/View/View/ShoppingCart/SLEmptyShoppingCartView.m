//
//  SLEmptyShoppingCartView.m
//  WineMVVMDemo
//
//  Created by songlin on 1/11/2017.
//  Copyright © 2017 songlin. All rights reserved.
//

#import "SLEmptyShoppingCartView.h"


@implementation SLEmptyShoppingCartView


- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self)
    {
        [self configInterface];
    }
    return self;
}

- (void)configSubView
{
    UIImageView *backGroudImage = [[UIImageView alloc] initWithFrame:self.frame];
    backGroudImage.image = [UIImage imageNamed:@"shopingcartvoid"];
    [self addSubview:backGroudImage];
    
    UILabel* tipsLabel = [[UILabel alloc]initWithFrame:CGRectMake(20, kHeight/2-45, kWidth - 40, 21)];
    tipsLabel.textColor = [UIColor lightGrayColor];
    tipsLabel.textAlignment = NSTextAlignmentCenter;
    NSString *sex = [[NSUserDefaults standardUserDefaults] objectForKey:@"sex"];
    if (sex.length == 0 || [sex isEqualToString:@"man"]) {
        tipsLabel.text = @"皇上,您的购物车是空的~~";
    }
    if ([sex isEqualToString:@"woman"]) {
        tipsLabel.text = @"皇后,您的购物车是空的~~";
    }
    [self addSubview:tipsLabel];
    
    //设置一个和去逛逛 相等大小的button
    self.goShopBtn  = [UIButton buttonWithType:UIButtonTypeCustom];
    _goShopBtn.frame = CGRectMake(kWidth/2-60,kHeight/2 -10,120,40);
    [self addSubview:_goShopBtn];
}
/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
