//
//  SLAboutMeVC.m
//  WineMVVMDemo
//
//  Created by songlin on 2/11/2017.
//  Copyright © 2017 songlin. All rights reserved.
//

#import "SLAboutMeVC.h"
#import "SLAboutMeViewModel.h"
#import "SLAboutMeTableViewCell.h"

@interface SLAboutMeVC ()<UITableViewDelegate,UITableViewDataSource,UIImagePickerControllerDelegate,UINavigationControllerDelegate>
@property(nonatomic,strong)SLAboutMeViewModel  *viewModel;



@property(nonatomic,strong)NSArray              *titleArray;
@end

@implementation SLAboutMeVC
@dynamic viewModel;

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self bindViewModel];
    [self initView];
}
- (void)bindViewModel
{
    [super bindViewModel];
    self.viewModel.vc               = self;
}
- (void)initView
{
    self.navigationController.navigationBar.titleTextAttributes = @{NSForegroundColorAttributeName:SLCOLOR(70, 70, 70, 1)};
    [self.view addSubview:self.tableView];
    self.tableView.delegate         = self;
    self.tableView.dataSource       = self;
    self.tableView.backgroundColor  = [UIColor clearColor];
    self.tableView.separatorStyle   = UITableViewCellSeparatorStyleNone;
    [self.tableView registerNib:[UINib nibWithNibName:@"SLAboutMeTableViewCell" bundle:[NSBundle mainBundle]] forCellReuseIdentifier:@"cell"];
}

- (void)updateHeader:(UIImagePickerControllerSourceType)sourcyType
{
    if (![UIImagePickerController isSourceTypeAvailable:sourcyType])
    {
        return;
    }
    UIImagePickerController *picker = [[UIImagePickerController alloc]init];
    picker.delegate = self;
    picker.allowsEditing = YES;
    picker.sourceType = sourcyType;
    [self presentViewController:picker animated:YES completion:nil];
}

#pragma mark - tableViewDelegate
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [self.viewModel.cellClickCommand execute:indexPath];
}

#pragma mark - tableViewDataSource
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    SLAboutMeTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cell" forIndexPath:indexPath];
    if (indexPath.section == 0)
    {
        
        if (indexPath.row == 0)
        {
            cell.w_imageView.hidden =  NO;
            if (CURRENT_USER.headImage)
            {
                cell.w_imageView.image = CURRENT_USER.headImage;
            }
        }
        NSArray *array = @[@"",CURRENT_USER.nickName,CURRENT_USER.sex ? @"男" :@"女",CURRENT_USER.birthDay];
        NSLog(@"%d",CURRENT_USER.sex);
        [cell configCellTitle:self.titleArray[indexPath.row] subTitle:array[indexPath.row]];
        cell.w_subLabel.textColor = indexPath.row == 3 ? THEME_COLOR : SLCOLOR(120, 120, 120, 1);
        if (![cell viewWithTag:111])
        {
            UIView *line = [[UIView alloc]initWithFrame:CGRectMake(0, cell.frame.size.height - 0.5, kWidth, 0.5)];
            line.backgroundColor = SLCOLOR(215, 215, 215, 1);
            line.tag = 111;
            [cell addSubview:line];
        }
    }
    else
    {
        [cell configCellTitle:@"地址管理" subTitle:@""];
    }
    return cell;
}
- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    return [[UIView alloc]initWithFrame:CGRectMake(0, 0, kWidth, 10)];
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return section == 0 ? 4 : 1;
}
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 2;
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section == 0 && indexPath.row == 0)
    {
        return 85;
    }
    return 50;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 10;
}



#pragma mark - lazyLoad


- (UITableView *)tableView
{
    if (!_tableView)
    {
        _tableView = [[UITableView alloc]initWithFrame:self.view.frame style:UITableViewStylePlain];
    }
    return _tableView;
}
- (NSArray *)titleArray
{
    if (!_titleArray)
    {
        _titleArray = @[@"头像",@"昵称",@"性别",@"生日"];
    }
    return _titleArray;
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
