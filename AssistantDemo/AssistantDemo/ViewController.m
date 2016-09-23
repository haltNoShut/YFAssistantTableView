//
//  ViewController.m
//  AssistantDemo
//
//  Created by 杨帆 on 2016/9/20.
//  Copyright © 2016年 杨帆. All rights reserved.
//

#import "ViewController.h"
#import "YFAssistantTableView.h"

@interface ViewController ()<UITableViewDelegate,UITableViewDataSource,YFAssistantDelegate>

@property(nonatomic,strong)YFAssistantTableView *tableView;

@end

@implementation ViewController

- (void)loadView{
    [super loadView];
    self.tableView = [[YFAssistantTableView alloc]initWithFrame:self.view.bounds style:UITableViewStyleGrouped];
    [self.view addSubview:self.tableView];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    [self.tableView registerClass:[UITableViewCell class] forCellReuseIdentifier:@"cell"];
    [self.tableView registerClass:[UITableViewCell class] forCellReuseIdentifier:@"assistant"];
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    self.tableView.assistantDelegate = self;
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

#pragma mark datasource
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 2;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return 5;
}

#pragma mark deletage

- (UITableViewCell *)tableView:(YFAssistantTableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cell" forIndexPath:indexPath];
    cell.textLabel.text = [NSString stringWithFormat:@"cell-%ld-%ld",indexPath.section,indexPath.row];
    cell.backgroundColor = [UIColor grayColor];
    return cell;
}


- (void)tableView:(YFAssistantTableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    [tableView spreadAssistant:indexPath];
}
#pragma mark assistant delegate

- (UITableViewCell *)YFAssistantTableView:(YFAssistantTableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"assistant" forIndexPath:indexPath];
    cell.textLabel.text = [NSString stringWithFormat:@"assistant-%ld-%ld",indexPath.section,indexPath.row];
    cell.backgroundColor = [UIColor darkGrayColor];
    return cell;
}

- (BOOL)YFAssistantTableView:(YFAssistantTableView *)tableView shouldSpreadAssistantAtIndexPath:(NSIndexPath *)indexPath{
    return YES;
}

@end
