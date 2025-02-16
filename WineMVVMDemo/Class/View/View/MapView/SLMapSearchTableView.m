//
//  SLMapSearchTableView.m
//  WineMVVMDemo
//
//  Created by songlin on 1/11/2017.
//  Copyright © 2017 songlin. All rights reserved.
//

#import "SLMapSearchTableView.h"
#import <BaiduMapAPI_Search/BMKPoiSearch.h>
#import "SLMapViewModel.h"

@interface SLMapSearchTableView ()<UITableViewDelegate,UITableViewDataSource>

@end

@implementation SLMapSearchTableView

- (instancetype)initWithFrame:(CGRect)frame style:(UITableViewStyle)style
{
    self = [super initWithFrame:frame style:style];
    if (self)
    {
        [self configView];
    }
    return self;
}
- (void)configView
{
    self.dataSource         = self;
    self.delegate           = self;
}

#pragma mark - tableViewDelegate
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.05 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        [tableView deselectRowAtIndexPath:indexPath animated:YES];
    });
    [self.viewModel.cellClick execute:self.searchArray[indexPath.row]];
}

#pragma mark - tableViewDataSource
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cell"];
    if (!cell)
    {
        cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:@"cell"];
        cell.textLabel.font = [UIFont sl_NormalFont:14];
        cell.textLabel.textColor = SLCOLOR(80, 80, 80, 1);
        cell.detailTextLabel.textColor = SLCOLOR(120, 120, 120, 1);
    }
    BMKPoiInfo *poitInfo = self.searchArray[indexPath.row];
    cell.textLabel.text = poitInfo.name;
    cell.detailTextLabel.text = poitInfo.address;
    
    return cell;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.searchArray.count;
}

- (NSArray *)searchArray
{
    if (!_searchArray)
    {
        _searchArray = @[];
    }
    return _searchArray;
}


@end
