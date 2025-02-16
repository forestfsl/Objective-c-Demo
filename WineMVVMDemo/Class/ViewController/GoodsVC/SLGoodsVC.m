//
//  SLGoodsVC.m
//  WineMVVMDemo
//
//  Created by songlin on 31/10/2017.
//  Copyright © 2017 songlin. All rights reserved.
//

#import "SLGoodsVC.h"
#import "SLGoodsViewModel.h"
#import "SLCommentTableView.h"
#import <WebKit/WebKit.h>
#import "SLCommentBtn.h"

@interface SLGoodsVC ()<UIScrollViewDelegate,WKUIDelegate>
@property(nonatomic,strong,readwrite)SLGoodsViewModel  *viewModel;

@property(nonatomic,strong)WKWebView                    *webView;

@property(nonatomic,strong)UIButton                     *bageLabel;
///shoppingCar
@property(nonatomic,strong)UIButton                     *shoppingCarBtn;
///add
@property(nonatomic,strong)UIButton                     *addBtn;

@property(nonatomic,strong)UIImageView                  *goodImg;

@property(nonatomic,strong)UIButton                     *shareBtn;

///bg
@property(nonatomic,strong)UIScrollView                 *scrollView;

@property(nonatomic,strong)UISegmentedControl           *titleView;
///评论
@property(nonatomic,strong)SLCommentTableView          *tableView;
///评论head
@property(nonatomic,strong)UIView                       *headView;

@property(nonatomic,strong)NSMutableArray               *headBtnArray;

///上次选择
@property(nonatomic,assign)NSInteger                    lastSelect;

///评论标题
@property(nonatomic,strong)NSDictionary                 *titleDic;

@end

@implementation SLGoodsVC
@dynamic viewModel;

#pragma mark - lifeCycle
- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    self.navigationController.navigationBar.titleTextAttributes = @{NSForegroundColorAttributeName:SLCOLOR(80, 80, 80, 1)};
    
}
- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    self.navigationController.navigationBar.shadowImage = nil;
}
- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self bindViewModel];
}

- (void)bindViewModel {
    [super bindViewModel];
    @weakify(self);
    [[self.addBtn rac_signalForControlEvents:UIControlEventTouchUpInside] subscribeNext:^(id x) {
        @strongify(self);
        self.goodImg.center = self.addBtn.center;
        [self.viewModel.addCommand execute:self.goodImg];
        //       角标动画
        [self bageValueAnimation];
    }];
    
    RAC(self.shoppingCarBtn,rac_command)    = RACObserve(self.viewModel, clickShopCommand);
    RAC(self.bageLabel,rac_command)         = RACObserve(self.viewModel, clickShopCommand);
    RAC(self.shareBtn,rac_command)          = RACObserve(self.viewModel, shareCommand);
    RAC(self.tableView,dataArray)           = RACObserve(self.viewModel, commentArray);
    RAC(self,titleDic)                      = RACObserve(self.viewModel, titleDic);
    [[self.titleView rac_signalForControlEvents:UIControlEventValueChanged] subscribeNext:^(id x) {
        @strongify(self);
        NSInteger page = self.titleView.selectedSegmentIndex;
        [self.scrollView setContentOffset:CGPointMake(kWidth * page, -64) animated:YES];
    }];
    
    self.tableView.mj_header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
        @strongify(self);
        [self.viewModel.refreshCommand execute:self.tableView];
    }];
    [self.tableView.mj_header beginRefreshing];
}

-(void)configSelf {
    self.navigationController.navigationBar.shadowImage = nil;
    self.scrollView.delegate = self;
    [self.view addSubview:self.scrollView];
    
    [self.scrollView addSubview:self.webView];
    NSString *urlStr = [NSString stringWithFormat:@"%@/userinfos/%@/products/%@/desc",IMG_URL,[SLUser currentUser].bid,self.viewModel.goods.id];
    [self.webView loadRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:urlStr]]];
    
    [self.scrollView addSubview:self.shoppingCarBtn];
    
    [self.scrollView addSubview:self.addBtn];
    
    self.goodImg                            = [[UIImageView alloc]init];
    [self.goodImg sd_setImageWithURL:[NSURL URLWithString:self.viewModel.goods.avatar_url] placeholderImage:[UIImage imageNamed:@"placehoder2"]];
    self.goodImg.center                     = self.addBtn.center;
    self.goodImg.bounds                     = CGRectMake(0, 0, 100, 100);
    
    
#pragma mark - 右侧
    [self.scrollView addSubview:self.headView];
    [self.scrollView addSubview:self.tableView];
    
    [self resetNavi];
}

///导航栏
- (void)resetNavi
{
    self.navigationItem.rightBarButtonItem  = [[UIBarButtonItem alloc]initWithCustomView:self.shareBtn];
    self.navigationItem.titleView           = self.titleView;
}

/**角标动画*/
- (void)bageValueAnimation
{
    if ([SLUser currentUser].bageValue >= 0)
    {
        self.bageLabel.hidden               = NO;
    }
    [self.bageLabel setTitle:[NSString stringWithFormat:@"%ld",[SLUser currentUser].bageValue] forState:UIControlStateNormal];
    @weakify(self);
    [UIView animateWithDuration:0.2 animations:^{
        @strongify(self);
        self.bageLabel.frame                = CGRectMake(_shoppingCarBtn.frame.size.width / 2.0 + 10, 2, 30, 30);
        
        self.bageLabel.titleLabel.font      = [UIFont sl_NormalFont:17];
        
    } completion:^(BOOL finished) {
        @strongify(self);
        [UIView animateWithDuration:0.2 animations:^{
            self.bageLabel.frame                = CGRectMake(_shoppingCarBtn.frame.size.width / 2.0 + 10, 2, 25, 25);
            self.bageLabel.titleLabel.font      = [UIFont sl_NormalFont:14];
            
        }];
    }];
}

///刷新评论标题
- (void)setTitleDic:(NSDictionary *)titleDic
{
    _titleDic = titleDic;
    NSArray *titleNum = @[titleDic[@"whole"],titleDic[@"good"],titleDic[@"middle"],titleDic[@"bad"],titleDic[@"picture"]];
    NSArray *title = @[@"全部评价",@"好评",@"中评",@"差评",@"晒图"];
    [self.headBtnArray enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        SLCommentBtn *btn = obj;
        [btn setTitle:title[idx] subTitle:titleNum[idx]];
    }];
    
}

#pragma mark - headBtnClick
- (void)headBtnClick:(UIButton *)btn
{
    if (btn.tag == self.lastSelect)
    {
        return;
    }
    [self.viewModel.menuCommand execute:@(btn.tag)];
    SLCommentBtn *lastBtn = self.headBtnArray[self.lastSelect];
    lastBtn.titleColor = SLCOLOR(80, 80, 80, 1);
    SLCommentBtn *newBtn = (SLCommentBtn *)btn;
    newBtn.titleColor = THEME_COLOR;
    self.lastSelect = btn.tag;
}



#pragma mark - scrollViewDelegate
- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView
{
    NSInteger page = scrollView.contentOffset.x / scrollView.frame.size.width;
    self.titleView.selectedSegmentIndex = page;
}

#pragma mark - lazyLoad
- (UIButton *)addBtn
{
    if (!_addBtn)
    {
        _addBtn                             = [UIButton buttonWithType:UIButtonTypeCustom];
        _addBtn.frame                       = CGRectMake(kWidth * 3 / 5, kHeight - 50 - 64, kWidth * 2 / 5, 50);
        _addBtn.backgroundColor             = THEME_COLOR;
        [_addBtn setTitle:@"加入购物车" forState:UIControlStateNormal];
    }
    return _addBtn;
}

- (UIButton *)shoppingCarBtn
{
    if (!_shoppingCarBtn)
    {
        _shoppingCarBtn                     = [UIButton buttonWithType:UIButtonTypeCustom];
        _shoppingCarBtn.frame               = CGRectMake(0, kHeight - 50 - 64, kWidth * 3 / 5, 50);
        _shoppingCarBtn.backgroundColor     = SLCOLOR(30, 30, 30, 0.8);
        
        UIImageView *imgView                = [[UIImageView alloc]initWithFrame:CGRectMake(_shoppingCarBtn.frame.size.width / 2.0 - 25, 0, 50, 50)];
        imgView.image                       = [UIImage imageNamed:@"gouwuche"];
        [self.shoppingCarBtn addSubview:imgView];
        self.bageLabel                      = [UIButton buttonWithType:UIButtonTypeCustom];
        self.bageLabel.frame                = CGRectMake(_shoppingCarBtn.frame.size.width / 2.0 + 10, 2, 25, 25);
        self.bageLabel.titleLabel.font      = [UIFont sl_NormalFont:14];
        [self.bageLabel setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        [self.bageLabel setTitle:[NSString stringWithFormat:@"%ld",[SLUser currentUser].bageValue] forState:UIControlStateNormal];
        [self.bageLabel setBackgroundImage:[UIImage imageNamed:@"main_badge"] forState:UIControlStateNormal];
        self.bageLabel.titleLabel.textAlignment        = NSTextAlignmentCenter;
        if ([SLUser currentUser].bageValue == 0)
        {
            self.bageLabel.hidden           = YES;
        }
        
        [_shoppingCarBtn addSubview:self.bageLabel];
    }
    return _shoppingCarBtn;
}

- (WKWebView *)webView
{
    if (!_webView)
    {
        _webView = [[WKWebView alloc]initWithFrame:CGRectMake(0, 0, kWidth, kHeight - 50 )];
       
        _webView.UIDelegate             = self;
    }
    return _webView;
}
- (UIButton *)shareBtn
{
    if (!_shareBtn)
    {
        _shareBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        [_shareBtn setBackgroundImage:[UIImage imageNamed:@"w_share"] forState:UIControlStateNormal];
        _shareBtn.frame = CGRectMake(0, 0, 20, 20);
    }
    return _shareBtn;
}
- (UISegmentedControl *)titleView
{
    if (!_titleView)
    {
        _titleView        = [[UISegmentedControl alloc]initWithItems:@[@"详情",@"评价"]];
        _titleView.frame  = CGRectMake(0, 0, 100, 30);
        NSDictionary *selectDic = @{NSForegroundColorAttributeName :SLCOLOR(70, 70, 70, 1),NSFontAttributeName:[UIFont sl_NormalFont:14]};
        NSDictionary *normalDic = @{NSForegroundColorAttributeName :SLCOLOR(140, 140, 140, 1),NSFontAttributeName:[UIFont sl_NormalFont:14]};
        [_titleView setTitleTextAttributes:selectDic forState:UIControlStateSelected];
        [_titleView setTitleTextAttributes:normalDic forState:UIControlStateNormal];
        _titleView.selectedSegmentIndex = 0;
        _titleView.tintColor  = THEME_COLOR;
    }
    return _titleView;
}
- (UIScrollView *)scrollView
{
    if (!_scrollView)
    {
        _scrollView = [[UIScrollView alloc]initWithFrame:self.view.frame];
        _scrollView.contentSize = CGSizeMake(kWidth * 2, _scrollView.frame.size.height - 64);
        _scrollView.pagingEnabled = YES;
    }
    return _scrollView;
}
- (UIView *)headView
{
    if (!_headView)
    {
        _headView = [[UIView alloc]initWithFrame:CGRectMake(kWidth, 0, kWidth, 50)];
        NSArray *title = @[@"全部评价",@"好评",@"中评",@"差评",@"晒图"];
        CGFloat width = kWidth  / 5.0;
        for (int i = 0; i < 5; i++)
        {
            SLCommentBtn *btn  = [SLCommentBtn buttonWithTitle:title[i] subTitle:@"0"];
            btn.frame           = CGRectMake(width * i, 0, width, 50);
            btn.tag             = i;
            btn.titleColor    = i == 0 ? THEME_COLOR : SLCOLOR(80, 80, 80, 1);
            [btn addTarget:self action:@selector(headBtnClick:) forControlEvents:UIControlEventTouchUpInside];
            [_headView addSubview:btn];
            [self.headBtnArray addObject:btn];
        }
    }
    return _headView;
}
- (SLCommentTableView *)tableView
{
    if (!_tableView)
    {
        _tableView = [[SLCommentTableView alloc] initWithFrame:CGRectMake(kWidth, 50, kWidth, kHeight - 50 - 64) style:UITableViewStylePlain];
    }
    return _tableView;
}
- (NSMutableArray *)headBtnArray
{
    if (!_headBtnArray)
    {
        _headBtnArray = @[].mutableCopy;
    }
    return _headBtnArray;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
