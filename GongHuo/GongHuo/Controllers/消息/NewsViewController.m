//
//  NewsViewController.m
//  GongHuo
//
//  Created by TongLi on 2017/10/13.
//  Copyright © 2017年 TongLi. All rights reserved.
//

#import "NewsViewController.h"
#import "Manager.h"
#import "MessageListTableViewCell.h"
#import "NewsDetailViewController.h"
@interface NewsViewController ()<UITableViewDataSource,UITableViewDelegate>
@property (weak, nonatomic) IBOutlet UITableView *newsTableView;
@property(nonatomic,strong)NSMutableArray *dataSourceArr;
@property(nonatomic,assign)NSInteger totalPages;
@end

@implementation NewsViewController
//返回
- (IBAction)leftBarButtonAction:(UIBarButtonItem *)sender {
    [self.navigationController popViewControllerAnimated:YES];
    
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    Manager *manager = [Manager shareInstance];
    AlertManager *alertM = [AlertManager shareIntance];
    
    [manager httpMyNewsListWithPageIndex:1 withNewsSuccess:^(id successResult) {
        
        self.totalPages = [[successResult objectForKey:@"pages"] integerValue];
        self.dataSourceArr = [successResult objectForKey:@"list"];
        [self.newsTableView reloadData];
        
    } withNewsFail:^(NSString *failResultStr) {
        //
        [alertM showAlertViewWithTitle:@"消息列表请求失败" withMessage:failResultStr actionTitleArr:@[@"确定"] withViewController:self withReturnCodeBlock:nil];
    }];
    
}

//
- (NSMutableArray *)dataSourceArr {
    if (_dataSourceArr == nil) {
        self.dataSourceArr = [NSMutableArray array];
    }
    return _dataSourceArr;
}



#pragma mark - tableView Delegate -
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.dataSourceArr.count;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    NewsModel *tempModel = self.dataSourceArr[indexPath.row];
    
    MessageListTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"newsCell" forIndexPath:indexPath];
    
    [cell updateMessageListWithModel:tempModel];
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    NewsModel *tempModel = self.dataSourceArr[indexPath.row];
    
    [self performSegueWithIdentifier:@"newsListToDetailVC" sender:tempModel];
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
    if ([segue.identifier isEqualToString:@"newsListToDetailVC"]) {
        NewsDetailViewController *newsDetailVC = [segue destinationViewController];
        newsDetailVC.tempNewsModel = sender;
    }
    
}


@end
