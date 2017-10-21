//
//  SendSuccessViewController.m
//  GongHuo
//
//  Created by TongLi on 2017/9/25.
//  Copyright © 2017年 TongLi. All rights reserved.
//

#import "SendSuccessViewController.h"

@interface SendSuccessViewController ()

@end

@implementation SendSuccessViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    //发送通知刷新待发货和已完成
    [[NSNotificationCenter defaultCenter] postNotificationName:@"refreshOrderList" object:self userInfo:@{@"1":@"YES",@"3":@"YES"}];

}
//继续发货
- (IBAction)continueSendButtonAction:(UIButton *)sender {
    [self.navigationController popToViewController:[self.navigationController.viewControllers objectAtIndex:1] animated:YES];
}
//返回首页
- (IBAction)backHomeButtonAction:(UIButton *)sender {
    [self.navigationController popToRootViewControllerAnimated:YES];
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
