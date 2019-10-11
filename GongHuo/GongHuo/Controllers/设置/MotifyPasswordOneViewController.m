//
//  MotifyPasswordOneViewController.m
//  GongHuo
//
//  Created by TongLi on 2017/7/9.
//  Copyright © 2017年 TongLi. All rights reserved.
//

#import "MotifyPasswordOneViewController.h"
#import "Manager.h"
@interface MotifyPasswordOneViewController ()
@property (weak, nonatomic) IBOutlet UILabel *nameLabel;
@property (weak, nonatomic) IBOutlet UILabel *mobileLabel;
@property (weak, nonatomic) IBOutlet UIButton *getCodeButton;
@property (weak, nonatomic) IBOutlet UITextField *codeTextField;

//定时器
@property (nonatomic,strong)NSTimer *tempTimer;
@property (nonatomic,assign)NSInteger countDownTime;//倒计时秒数

@end

@implementation MotifyPasswordOneViewController
- (IBAction)leftBarButtonAction:(UIBarButtonItem *)sender {
    [self.navigationController popViewControllerAnimated:YES];
}
- (IBAction)rightBarButtonAction:(UIBarButtonItem *)sender {
#warning 消息
    
}
- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    //设置倒计时初始值
    self.countDownTime = 60;
    
    Manager *manager = [Manager shareInstance];
    self.nameLabel.text = manager.memberInfoModel.u_truename;
    self.mobileLabel.text = manager.memberInfoModel.u_mobile;
    
}
- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear: animated];
    [SVProgressHUD dismiss];
    //定制器取消
    [self endTimeDown];
}


#pragma mark - 短信验证阿 和 倒计时 -
//开始倒计时
- (void)startTimeDown {
    //开始60秒倒计时
    self.tempTimer = [NSTimer scheduledTimerWithTimeInterval:1 target:self selector:@selector(timerAction:) userInfo:nil repeats:YES];
    
    //按钮不可点击
    self.getCodeButton.enabled = NO;
    [self.getCodeButton setTitle:[NSString stringWithFormat:@"倒计时 %ld",self.countDownTime] forState:UIControlStateNormal];
    //背景变灰色
    self.getCodeButton.backgroundColor = kColor(153, 153, 153, 1);
}
//倒计时结束
- (void)endTimeDown {
    //倒计时回归
    self.countDownTime = 60;
    //停止倒计时
    [self.tempTimer invalidate];
    //按钮可以点击
    self.getCodeButton.enabled = YES;
    [self.getCodeButton setTitle:@"获取验证码" forState:UIControlStateNormal];
    //背景色变红
    self.getCodeButton.backgroundColor = kMainColor;
    
}
- (void)timerAction:(NSTimer *)timer {
    NSLog(@"aaaaaaaa");
    self.countDownTime--;
    //    NSLog(@"倒计时 %ld",self.countDownTime);
    self.getCodeButton.titleLabel.text = [NSString stringWithFormat:@"倒计时(%ld)",self.countDownTime];
    [self.getCodeButton setTitle:[NSString stringWithFormat:@"倒计时(%ld)",self.countDownTime] forState:UIControlStateNormal];
    if (self.countDownTime == 0) {
        //倒计时结束
        [self endTimeDown];
        
    }
}

//获取验证码
- (IBAction)getCodeButtonAction:(UIButton *)sender {
    Manager *manager = [Manager shareInstance];
    AlertManager *alertM = [AlertManager shareIntance];
    
    [manager httpSendMsgCodeWithMobile:manager.memberInfoModel.u_mobile withSendMsgSuccess:^(id successResult) {
        [alertM showAlertViewWithTitle:@"发送成功，请注意查收" withMessage:nil actionTitleArr:@[@"确定"] withViewController:self withReturnCodeBlock:^(NSInteger actionBlockNumber) {
            //发送成功后，开始倒计时
            [self startTimeDown];
        }];
        
    } withSendMsgFail:^(NSString *failResultStr) {
        [alertM showAlertViewWithTitle:@"发送短信验证码失败" withMessage:failResultStr actionTitleArr:@[@"确定"] withViewController:self withReturnCodeBlock:nil];
    }];

        
    
}

//下一步
- (IBAction)nextButtonAction:(UIButton *)sender {
    
    AlertManager *alertM = [AlertManager shareIntance];
    Manager *manager = [Manager shareInstance];
    
    NSString *errorMsg = nil;
    if (self.codeTextField.text == nil || [self.codeTextField.text isEqualToString:@""]) {
        errorMsg = @"请填写手机验证码";
    }
    
    if (errorMsg == nil) {
        
        //停止短信倒计时
        [self endTimeDown];
        //验证短信验证码
        [manager httpCheckMsgCodeWithMobile:manager.memberInfoModel.u_mobile withMobileCode:self.codeTextField.text withCheckCodeSuccess:^(id successResult) {
            //如果验证成功，可以进去下一步
            [self performSegueWithIdentifier:@"toMotifyPasswordTwoVC" sender:nil];
            
        } withCheckCodeFail:^(NSString *failResultStr) {
            //如果验证不成功，提示
            [alertM showAlertViewWithTitle:@"短信验证码验证失败" withMessage:failResultStr actionTitleArr:@[@"确定"] withViewController:self withReturnCodeBlock:nil];
        }];
        
        
    }else {
        //信息没有填写完整
        [alertM showAlertViewWithTitle:errorMsg withMessage:nil actionTitleArr:@[@"确定"] withViewController:self withReturnCodeBlock:nil];
    }
    
    
    
}

- (IBAction)tapBackViewAction:(UITapGestureRecognizer *)sender {
    [self.codeTextField resignFirstResponder];
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
