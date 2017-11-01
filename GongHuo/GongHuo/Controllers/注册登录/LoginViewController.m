//
//  LoginViewController.m
//  GongHuo
//
//  Created by TongLi on 2017/9/14.
//  Copyright © 2017年 TongLi. All rights reserved.
//

#import "LoginViewController.h"
#import "Manager.h"
#import "AlertManager.h"
@interface LoginViewController ()<UIScrollViewDelegate>
@property (weak, nonatomic) IBOutlet UIScrollView *backScrollView;

@property (weak, nonatomic) IBOutlet UITextField *mobileTextField;
@property (weak, nonatomic) IBOutlet UITextField *passwordTextField;

@end

@implementation LoginViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear: animated];
    //隐藏navigation
    [self scrollViewDidScroll:self.backScrollView];
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    [SVProgressHUD dismiss];
    
    //显示Navigate
    Manager *manager = [Manager shareInstance];
    [self.navigationController.navigationBar setBackgroundImage:[manager getImageWithAlpha:1] forBarMetrics:UIBarMetricsDefault];
    //显示navigation 那条线
    [manager isClearNavigationBarLine:NO withNavigationController:self.navigationController];
    
}

#pragma mark - 隐藏头部 -
//--------------------------------------
- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    Manager *manager = [Manager shareInstance];
    
    CGFloat yOffset  = scrollView.contentOffset.y;
    NSLog(@"++%f",yOffset);
    
    [self.navigationController setNavigationBarHidden:NO animated:NO];
    CGFloat alpha=yOffset/80.0f>1.0f?1:yOffset/80.0f;
    NSLog(@"%f",alpha);
    //改变navigation的背景色
    [self.navigationController.navigationBar setBackgroundImage:[manager getImageWithAlpha:alpha] forBarMetrics:UIBarMetricsDefault];
    //改变通知按钮的颜色
    if (alpha>0.6) {
        self.navigationItem.rightBarButtonItem.tintColor = kColor(57, 209, 103, 1);
        [manager isClearNavigationBarLine:NO withNavigationController:self.navigationController];
        
    }else{
        self.navigationItem.rightBarButtonItem.tintColor = [UIColor whiteColor];
        [manager isClearNavigationBarLine:YES withNavigationController:self.navigationController];
    }
}

#pragma mark - 登录 -

//登录按钮
- (IBAction)loginButtonAction:(UIButton *)sender {
    Manager *manager = [Manager shareInstance];
    AlertManager *alertM = [AlertManager shareIntance];

    NSString *errorStr = nil;
    if (self.passwordTextField.text == nil || self.passwordTextField.text.length == 0) {
        errorStr = @"密码不能为空";
    }
    
    if (self.mobileTextField.text == nil || self.mobileTextField.text.length != 11) {
        errorStr = @"请输入正确的手机号";
    }
    
    if (errorStr == nil) {
        [manager httpLoginWithMobile:self.mobileTextField.text withPassword:self.passwordTextField.text withLoginSuccess:^(id successResult) {
            [self dismissViewControllerAnimated:YES completion:nil];
            
        } withLoginFail:^(NSString *failResultStr) {
            //登录失败，
            [alertM showAlertViewWithTitle:@"登录失败" withMessage:failResultStr actionTitleArr:@[@"确定"] withViewController:self withReturnCodeBlock:nil];
        }];
    }else {
        [alertM showAlertViewWithTitle:errorStr withMessage:nil actionTitleArr:@[@"确定"] withViewController:self withReturnCodeBlock:nil];
        
    }

}

//忘记密码
- (IBAction)forgetPasswordButtonAction:(UIButton *)sender {
    [self performSegueWithIdentifier:@"loginToForgetPasswordVC" sender:nil];
}

//跳转到注册界面
- (IBAction)registerButtonAction:(UIButton *)sender {
    [self performSegueWithIdentifier:@"loginToRegisterOneVC" sender:nil];
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
