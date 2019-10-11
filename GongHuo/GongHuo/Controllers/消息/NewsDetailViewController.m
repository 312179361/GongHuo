//
//  NewsDetailViewController.m
//  GongHuo
//
//  Created by TongLi on 2017/10/18.
//  Copyright © 2017年 TongLi. All rights reserved.
//

#import "NewsDetailViewController.h"
#import "Manager.h"
@interface NewsDetailViewController ()
@property (weak, nonatomic) IBOutlet UILabel *newsTitleLabel;
@property (weak, nonatomic) IBOutlet UIWebView *newsWebView;
@property (weak, nonatomic) IBOutlet UILabel *newsTimeLabel;

@end

@implementation NewsDetailViewController
- (IBAction)leftBarButtonAction:(UIBarButtonItem *)sender {
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    //请求消息详情
    Manager *manager = [Manager shareInstance];
    [manager httpNewsDetailWithICode:self.tempNewsModel.i_code withNewsDetailSuccess:^(id successResult) {
        
        [self updateViewUIWithDateDic:[[successResult objectForKey:@"data"] objectAtIndex:0]];
        
    } withNewsDetailFail:^(NSString *failResultStr) {
        
    }];
    
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    [SVProgressHUD dismiss];
}

- (void)updateViewUIWithDateDic:(NSDictionary *)dateDic {
    self.newsTitleLabel.text = [dateDic objectForKey:@"i_title"];
    self.newsTimeLabel.text = [dateDic objectForKey:@"i_time_create"];
    
    [self.newsWebView loadHTMLString:[dateDic objectForKey:@"content"] baseURL:nil];

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
