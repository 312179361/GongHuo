//
//  ForgetPasswordTwoViewController.m
//  GongHuo
//
//  Created by TongLi on 2017/10/12.
//  Copyright © 2017年 TongLi. All rights reserved.
//

#import "ForgetPasswordTwoViewController.h"
#import "Manager.h"
#import "AlertManager.h"
@interface ForgetPasswordTwoViewController ()
@property (weak, nonatomic) IBOutlet UITextField *passwordOneTextField;
@property (weak, nonatomic) IBOutlet UITextField *passwordTwoTextField;

@end

@implementation ForgetPasswordTwoViewController
- (IBAction)leftBarButtonAction:(UIBarButtonItem *)sender {
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear: animated];
    [SVProgressHUD dismiss];
}

- (IBAction)enterButtonAction:(UIButton *)sender {
    Manager *manager = [Manager shareInstance];
    AlertManager *alertM = [AlertManager shareIntance];
    
    NSString *errorStr = nil;
    
    if (self.passwordOneTextField.text == nil || self.passwordOneTextField.text.length == 0) {
        errorStr = @"请输入新密码";
    }
    if (self.passwordTwoTextField.text == nil || self.passwordTwoTextField.text.length == 0) {
        errorStr = @"请再次输入新密码";
    }
    if (![self.passwordOneTextField.text isEqualToString: self.passwordTwoTextField.text]) {
        errorStr = @"请输入相同的密码";
    }
    
    if (errorStr == nil) {
        //可以提交
        [manager httpForgetPasswordWithMobile:self.tempMobileStr withPassword:self.passwordOneTextField.text withForgetSuccess:^(id successResult) {
            
            [alertM  showAlertViewWithTitle:@"恭喜您，修改成功" withMessage:nil actionTitleArr:@[@"确定"] withViewController:self withReturnCodeBlock:^(NSInteger actionBlockNumber) {
                //返回到登录界面
                [self.navigationController popToRootViewControllerAnimated:YES];
            }];

        } withForgetFail:^(NSString *failResultStr) {
            [alertM  showAlertViewWithTitle:@"修改失败" withMessage:failResultStr actionTitleArr:@[@"确定"] withViewController:self withReturnCodeBlock:nil];

        }];
    }else {
        [alertM  showAlertViewWithTitle:errorStr withMessage:nil actionTitleArr:@[@"确定"] withViewController:self withReturnCodeBlock:nil];
    }
    
    
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
