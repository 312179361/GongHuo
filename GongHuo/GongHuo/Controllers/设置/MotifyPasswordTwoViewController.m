//
//  MotifyPasswordTwoViewController.m
//  GongHuo
//
//  Created by TongLi on 2017/7/9.
//  Copyright © 2017年 TongLi. All rights reserved.
//

#import "MotifyPasswordTwoViewController.h"
#import "Manager.h"
@interface MotifyPasswordTwoViewController ()
@property (weak, nonatomic) IBOutlet UILabel *nameLabel;

@property (weak, nonatomic) IBOutlet UITextField *passwordTextField;
@property (weak, nonatomic) IBOutlet UITextField *passwordTwoTextField;

@end

@implementation MotifyPasswordTwoViewController
- (IBAction)leftBarButtonAction:(UIBarButtonItem *)sender {
    //返回到设置界面
    [self.navigationController popToViewController:[self.navigationController.viewControllers objectAtIndex:1] animated:YES];
}

- (IBAction)rightBaButtonAction:(UIBarButtonItem *)sender {
#warning 消息
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    Manager *manager = [Manager shareInstance];
    self.nameLabel.text = manager.memberInfoModel.u_truename;
    
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    [SVProgressHUD dismiss];
    
}

//确认修改
- (IBAction)enterMotifyAction:(UIButton *)sender {
    Manager *manager = [Manager shareInstance];
    AlertManager *alertM = [AlertManager shareIntance];
    
    NSString *errorStr = nil;
    
    if (self.passwordTextField.text == nil || self.passwordTextField.text.length == 0) {
        errorStr = @"请输入新密码";
    }
    if (self.passwordTwoTextField.text == nil || self.passwordTwoTextField.text.length == 0) {
        errorStr = @"请再次输入新密码";
    }
    if (![self.passwordTextField.text isEqualToString: self.passwordTwoTextField.text]) {
        errorStr = @"请输入相同的密码";
    }
    
    if (errorStr == nil) {
        //可以提交
        [manager httpMotifyPasswordWithUserId:manager.memberInfoModel.userid withPassword:self.passwordTextField.text withMotifySuccess:^(id successResult) {
            [alertM  showAlertViewWithTitle:@"恭喜您，修改成功" withMessage:nil actionTitleArr:@[@"确定"] withViewController:self withReturnCodeBlock:^(NSInteger actionBlockNumber) {
                //保存到本地
                manager.memberInfoModel.password = self.passwordTextField.text;
                
                [manager saveMemberInfoModelToLocationWithMemberInfo:manager.memberInfoModel];
                
                
                //返回到设置界面
                [self.navigationController popToViewController:[self.navigationController.viewControllers objectAtIndex:1] animated:YES];
            }];
        } withMotifyFail:^(NSString *failResultStr) {
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
