//
//  RegisterThreeViewController.m
//  GongHuo
//
//  Created by TongLi on 2017/10/16.
//  Copyright © 2017年 TongLi. All rights reserved.
//

#import "RegisterThreeViewController.h"
#import "RegisterHeaderView.h"
#import "Manager.h"
#import "AlertManager.h"
@interface RegisterThreeViewController ()
@property (weak, nonatomic) IBOutlet UIView *headView;
@property (weak, nonatomic) IBOutlet UITextField *passwordTextField;
@property (weak, nonatomic) IBOutlet UITextField *passwordTwoTextField;

//点击用户协议
@property (weak, nonatomic) IBOutlet UIButton *selectUserProtocolButton;
//是否选择用户协议
@property (nonatomic,assign)BOOL isSelectUserProtocol;

@end

@implementation RegisterThreeViewController
- (IBAction)leftBarButtonAction:(UIBarButtonItem *)sender {
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    //加载注册头部view
    RegisterHeaderView *registerHeadView = [[[NSBundle mainBundle] loadNibNamed:@"RegisterHeaderView" owner:self options:nil] firstObject];
    [registerHeadView updateWithStep:3];
    [self.headView addSubview:registerHeadView];
    
    //默认是选择了用户协议
    self.isSelectUserProtocol = YES;
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear: animated];
    [SVProgressHUD dismiss];
}

#pragma mark - 注册 -
- (IBAction)registerButtonAction:(UIButton *)sender {
    
    Manager *manager = [Manager shareInstance];
    AlertManager *alertM = [AlertManager shareIntance];
    
    if (self.passwordTextField.text.length >= 6 && self.passwordTextField.text.length <=12 && self.passwordTwoTextField.text.length >= 6 && self.passwordTwoTextField.text.length <=12) {
        
        if ([self.passwordTextField.text isEqualToString:self.passwordTwoTextField.text]) {
            //注册
            [manager httpRegisterSupplyLeaderWithFuserId:self.tempFuserId withPassword:self.passwordTwoTextField.text withTruename:self.tempTruename withMobile:self.tempMobile withAreaid:self.tempAreaId withIsadmin:self.tempPosition withRegisterSuccess:^(id successResult) {
                
                [alertM showAlertViewWithTitle:@"恭喜您注册成功" withMessage:nil actionTitleArr:@[@"确定"] withViewController:self withReturnCodeBlock:^(NSInteger actionBlockNumber) {
                    //直接登录，
                    [manager httpLoginWithMobile:self.tempMobile withPassword:self.passwordTextField.text withLoginSuccess:^(id successResult) {
                        [self dismissViewControllerAnimated:YES completion:nil];
                        
                    } withLoginFail:^(NSString *failResultStr) {
                        //登录失败，
                        [self.navigationController popToRootViewControllerAnimated:YES];
                    }];
                    
                    
                }];
                
                
                
            } withRegisterFail:^(NSString *failResultStr) {
                [alertM showAlertViewWithTitle:@"注册失败" withMessage:failResultStr actionTitleArr:@[@"确定"] withViewController:self withReturnCodeBlock:nil];
            }];
            
        }else {
            [alertM showAlertViewWithTitle:@"两个密码不一致" withMessage:nil actionTitleArr:@[@"确定"] withViewController:self withReturnCodeBlock:nil];
        }
        
    }else {
        [alertM showAlertViewWithTitle:@"请输入密码或注意密码长度" withMessage:nil actionTitleArr:@[@"确定"] withViewController:self withReturnCodeBlock:nil];
    }
    
}

#pragma mark - 用户协议 -
- (IBAction)agreeUserProtocol:(UIButton *)sender {
    self.isSelectUserProtocol = !self.isSelectUserProtocol;
    if (self.isSelectUserProtocol == YES) {
        [self.selectUserProtocolButton setImage:[UIImage imageNamed:@"userProtocol_select.png"] forState:UIControlStateNormal];
//        self.selectUserProtocolButton.backgroundColor = kMainColor;
    }else {
        [self.selectUserProtocolButton setImage:[UIImage imageNamed:@"userProtocol_normal.png"] forState:UIControlStateNormal];

//        self.selectUserProtocolButton.backgroundColor = k999999Color;
    }
}

#pragma mark - 键盘消失 -

- (IBAction)tapBackViewAction:(UITapGestureRecognizer *)sender {
    [self keyboardDismissAction];
}
- (void)keyboardDismissAction {
    [self.passwordTextField resignFirstResponder];
    [self.passwordTwoTextField resignFirstResponder];
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
