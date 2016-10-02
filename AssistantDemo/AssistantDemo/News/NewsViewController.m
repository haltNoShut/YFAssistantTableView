//
//  NewsViewController.m
//  AssistantDemo
//
//  Created by 杨帆 on 2016/10/1.
//  Copyright © 2016年 杨帆. All rights reserved.
//

#import "NewsViewController.h"
#import "YFAssistantTableView.h"
#import "NewsModel.h"
#import "DetailNewsModel.h"
#import "SynopsisCell.h"
#import "DetailsCell.h"

@interface NewsViewController ()<UITableViewDelegate,UITableViewDataSource,YFAssistantDelegate>

@property (strong, nonatomic) YFAssistantTableView *tableView;

@property (strong, nonatomic) NSArray<NewsModel *> *models;

@end

@implementation NewsViewController

- (void)viewDidLoad {
    
    [super viewDidLoad];

    [self setupTableView];
    
    [NewsModel requestNewsModels:^(NSArray *models) {
        
        self.models = models;
        [self.tableView reloadData];
        
    }];
    
}

- (void)setupTableView {
    self.tableView = [[YFAssistantTableView alloc]initWithFrame:self.view.bounds style:UITableViewStyleGrouped];
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    self.tableView.assistantDelegate = self;
    [self.tableView registerNib:[UINib nibWithNibName:@"SynopsisCell" bundle:nil] forCellReuseIdentifier:@"synopsis"];
    [self.tableView registerNib:[UINib nibWithNibName:@"DetailsCell" bundle:nil] forCellReuseIdentifier:@"details"];
    self.tableView.retractWhenSpread = YES;
    [self.view addSubview:self.tableView];
}

#pragma mark tableView delegate

- (void)tableView:(YFAssistantTableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    [tableView spreadAssistant:indexPath];
    
}

#pragma mark tableView dataSource

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    
    return 1;
    
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    
    return self.models.count;
    
}

- (UITableViewCell *)tableView:(YFAssistantTableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    SynopsisCell *cell = [tableView dequeueReusableCellWithIdentifier:@"synopsis" forIndexPath:[tableView logicIndexPath2Actual:indexPath]];
    NewsModel *model = self.models[indexPath.row];
    [cell setModel:model];
    return cell;
}

- (CGFloat )tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    return 60;
}

#pragma mark YFAssistantTableView delegate

- (BOOL)YFAssistantTableView:(YFAssistantTableView *)tableView shouldSpreadAssistantAtIndexPath:(NSIndexPath *)indexPath{
    
    return YES;
    
}

- (UITableViewCell *)YFAssistantTableView:(YFAssistantTableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    DetailsCell *cell = [tableView dequeueReusableCellWithIdentifier:@"details" forIndexPath:[tableView logicIndexPath2Actual:indexPath]];
    
    NewsModel *model = self.models[indexPath.row];
    [DetailNewsModel requestDetailNews:model.postid completion:^(DetailNewsModel *model) {
        
        [cell setModel:model];
    }];
    
    return cell;
    
}
- (CGFloat )YFAssistantTableView:(YFAssistantTableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 300;
}

- (UITableViewRowAnimation )YFAssistantTableViewRetractAnimation:(YFAssistantTableView *)tableView{
    
    return UITableViewRowAnimationMiddle;
}

@end
