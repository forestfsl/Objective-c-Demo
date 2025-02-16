//
//  SLFeedBackViewModel.m
//  WineMVVMDemo
//
//  Created by songlin on 31/10/2017.
//  Copyright © 2017 songlin. All rights reserved.
//

#import "SLFeedBackViewModel.h"

@implementation SLFeedBackViewModel

- (instancetype)initWithService:(id<SLViewModelServices>)service params:(NSDictionary *)params
{
    self = [super initWithService:service params:params];
    if (self)
    {
        [self initViewModel];
    }
    return self;
}

- (void)initViewModel
{
    self.submitConmand      = [[RACCommand alloc]initWithSignalBlock:^RACSignal *(id input) {
        NSDictionary *dic   = input;
        NSString *ideaString    = dic[@"idea"];
        return [RACSignal createSignal:^RACDisposable *(id<RACSubscriber> subscriber) {
            if (ideaString.length <= 0)
            {
                [subscriber sendNext:@{@"code":@-400}];
                [subscriber sendCompleted];
                SHOW_ERROE(@"请留下您的意见")
                DISMISS_SVP(1.3);
            }
            else
            {
                
                SHOW_SVP(@"提交中");
                DISMISS_SVP(0.8);
                dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1.1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                    [subscriber sendNext:@{@"code":@100}];
                    [subscriber sendCompleted];
                    SHOW_SUCCESS(@"提交成功");
                    DISMISS_SVP(1.2);
                });
            }
            
            return [RACDisposable disposableWithBlock:^{
                
            }];
        }];
    }];
}

@end
