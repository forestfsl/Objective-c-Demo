//
//  SLMeBtn.m
//  WineMVVMDemo
//
//  Created by songlin on 2/11/2017.
//  Copyright © 2017 songlin. All rights reserved.
//

#import "SLMeBtn.h"

@interface SLMeBtn ()

@property(nonatomic,strong)UILabel *bageLabel;

@end

@implementation SLMeBtn

+ (instancetype)buttonWithTitle:(NSString *)title imageName:(NSString *)imageName
{
    SLMeBtn *btn = [self buttonWithType:UIButtonTypeCustom];
    [btn configViewWithTitle:title image:imageName];
    return btn;
}

- (void)configViewWithTitle:(NSString *)title image:(NSString *)imageName
{
    UIImageView *imageView      = [[UIImageView alloc] initWithImage:[UIImage imageNamed:imageName]];
    imageView.tag               = 111;
    [self addSubview:imageView];
    @weakify(self);
    [imageView mas_makeConstraints:^(MASConstraintMaker *make) {
        @strongify(self);
        make.centerX.equalTo(self);
        make.top.equalTo(self).offset(15);
        make.width.mas_equalTo(30);
        make.height.mas_equalTo(25);
    }];
    
    UILabel *label              = [[UILabel alloc]init];
    label.textAlignment         = NSTextAlignmentCenter;
    label.textColor             = SLCOLOR(70, 70, 70, 1);
    label.font                  = [UIFont sl_NormalFont:15];
    label.text                  = title;
    [self addSubview:label];
    [label mas_makeConstraints:^(MASConstraintMaker *make) {
        @strongify(self);
        make.top.equalTo(imageView.mas_bottom).offset(5);
        make.left.equalTo(self);
        make.right.equalTo(self);
        make.height.equalTo(@20);
    }];
    
}
- (void)setBageValue:(NSInteger)bageValue
{
    _bageValue = bageValue >= 99 ? 99 : bageValue;
    if (bageValue == 0)
    {
        [self.bageLabel removeFromSuperview];
        self.bageLabel.tag = 0;
    }
    else
    {
        if (self.bageLabel.tag == 0)
        {
            [self addSubview:self.bageLabel];
            [self bringSubviewToFront:self.bageLabel];
            self.bageLabel.tag = 1;
            UIView *view = [self viewWithTag:111];
            [self.bageLabel mas_makeConstraints:^(MASConstraintMaker *make) {
                make.top.equalTo(view).offset(-8);
                make.right.equalTo(view).offset(8);
                make.width.mas_equalTo(16);
                make.height.mas_equalTo(16);
            }];
        }
        self.bageLabel.text = [NSString stringWithFormat:@"%ld",bageValue];
    }
}

- (UILabel *)bageLabel
{
    if (!_bageLabel)
    {
        _bageLabel              = [[UILabel alloc]init];
        _bageLabel.textAlignment= NSTextAlignmentCenter;
        _bageLabel.textColor    = [UIColor whiteColor];
        _bageLabel.font         = [UIFont sl_NormalFont:10];
        _bageLabel.backgroundColor      = [UIColor redColor];
        _bageLabel.layer.cornerRadius   = 8;
        _bageLabel.layer.masksToBounds  = YES;
    }
    return _bageLabel;
}


@end
