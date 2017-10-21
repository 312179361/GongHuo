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

@end

@implementation NewsDetailViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    //请求消息详情
    Manager *manager = [Manager shareInstance];
    [manager httpNewsDetailWithICode:self.tempNewsModel.i_code withNewsDetailSuccess:^(id successResult) {
        
    } withNewsDetailFail:^(NSString *failResultStr) {
        
    }];
    
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
