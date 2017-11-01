//
//  RegisterTwoViewController.m
//  GongHuo
//
//  Created by TongLi on 2017/10/15.
//  Copyright © 2017年 TongLi. All rights reserved.
//

#import "RegisterTwoViewController.h"
#import "RegisterHeaderView.h"
#import "Manager.h"
#import "AlertManager.h"
#import "RegisterThreeViewController.h"
@interface RegisterTwoViewController ()
@property (weak, nonatomic) IBOutlet UIView *headView;
@property (weak, nonatomic) IBOutlet UIButton *positionButton;
@property (weak, nonatomic) IBOutlet UITextField *nameTextField;//姓名输入框
@property (weak, nonatomic) IBOutlet UITextField *phoneTextField;//电话输入框
@property (weak, nonatomic) IBOutlet UITextField *codeTextField;//验证码输入框
@property (weak, nonatomic) IBOutlet UIButton *sendCodeButton;//验证码按钮


@property(nonatomic,strong)NSArray *positionArr;
@property(nonatomic,assign)NSInteger selectPostionInt;//1老板/经理 2业务经理 3仓管 4发货负责人5财务

//定时器
@property (nonatomic,strong)NSTimer *tempTimer;
@property (nonatomic,assign)NSInteger countDownTime;//倒计时秒数

@end

@implementation RegisterTwoViewController
- (IBAction)leftBarButtonAction:(UIBarButtonItem *)sender {
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    //加载注册头部view
    RegisterHeaderView *registerHeadView = [[[NSBundle mainBundle] loadNibNamed:@"RegisterHeaderView" owner:self options:nil] firstObject];
    [registerHeadView updateWithStep:2];
    [self.headView addSubview:registerHeadView];
    
    //设置倒计时初始值
    self.countDownTime = 60;
    
    //初始化人员类型数组
    self.positionArr = @[@"老板/经理",@"业务经理",@"仓管",@"发货负责人",@"财务"];
    
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    [SVProgressHUD dismiss];
    //定制器取消
    [self endTimeDown];
}



#pragma mark - 请选择职位 -
- (IBAction)positionButtonAction:(UIButton *)sender {
    AlertManager *alertM = [AlertManager shareIntance];
    
    [alertM showActionSheetViewWithTitle:@"请选择职位" withMessage:nil actionTitleArr:self.positionArr withViewController:self withReturnCodeBlock:^(NSInteger actionBlockNumber) {
        //给标题赋值
        [sender setTitle:self.positionArr[actionBlockNumber] forState:UIControlStateNormal];
        [sender setTitleColor:k333333Color forState:UIControlStateNormal];
        //记录一下选择的职位
        if (self.selectPostionInt != actionBlockNumber+1) {
            self.selectPostionInt = actionBlockNumber+1;//因为actionBlockNumber是从0开始的

        }
        
    }];

}

#pragma mark - 短信验证阿 和 倒计时 -
//开始倒计时
- (void)startTimeDown {
    //开始60秒倒计时
    self.tempTimer = [NSTimer scheduledTimerWithTimeInterval:1 target:self selector:@selector(timerAction:) userInfo:nil repeats:YES];
    
    //按钮不可点击
    self.sendCodeButton.enabled = NO;
    [self.sendCodeButton setTitle:[NSString stringWithFormat:@"倒计时 %ld",self.countDownTime] forState:UIControlStateNormal];
    //背景变灰色
    self.sendCodeButton.backgroundColor = kColor(153, 153, 153, 1);
}
//倒计时结束
- (void)endTimeDown {
    //倒计时回归
    self.countDownTime = 60;
    //停止倒计时
    [self.tempTimer invalidate];
    //按钮可以点击
    self.sendCodeButton.enabled = YES;
    [self.sendCodeButton setTitle:@"获取验证码" forState:UIControlStateNormal];
    //背景色变红
    self.sendCodeButton.backgroundColor = kCodeBtnColor;
    
}
- (void)timerAction:(NSTimer *)timer {
    NSLog(@"aaaaaaaa");
    self.countDownTime--;
    //    NSLog(@"倒计时 %ld",self.countDownTime);
    self.sendCodeButton.titleLabel.text = [NSString stringWithFormat:@"倒计时(%ld)",self.countDownTime];
    [self.sendCodeButton setTitle:[NSString stringWithFormat:@"倒计时(%ld)",self.countDownTime] forState:UIControlStateNormal];
    if (self.countDownTime == 0) {
        //倒计时结束
        [self endTimeDown];
        
    }
}

- (IBAction)sendCodeButtonAction:(UIButton *)sender {
    Manager *manager = [Manager shareInstance];
    AlertManager *alertM = [AlertManager shareIntance];
    
    if (self.phoneTextField.text != nil && self.phoneTextField.text.length == 11) {
        
        [manager httpSendMsgCodeWithMobile:self.phoneTextField.text withSendMsgSuccess:^(id successResult) {
            [alertM showAlertViewWithTitle:@"发送成功，请注意查收" withMessage:nil actionTitleArr:@[@"确定"] withViewController:self withReturnCodeBlock:^(NSInteger actionBlockNumber) {
                //发送成功后，开始倒计时
                [self startTimeDown];
            }];
            
        } withSendMsgFail:^(NSString *failResultStr) {
            [alertM showAlertViewWithTitle:@"发送短信验证码失败" withMessage:failResultStr actionTitleArr:@[@"确定"] withViewController:self withReturnCodeBlock:nil];
        }];
        
    }else {
        //手机号码填写不正确
        [alertM showAlertViewWithTitle:@"请填写正确的手机号" withMessage:nil actionTitleArr:@[@"确定"] withViewController:self withReturnCodeBlock:nil];
        
    }
}
#pragma mark - 下一步 -
//下一步
- (IBAction)nextButtonAction:(UIButton *)sender {
//    [self performSegueWithIdentifier:@"registerTwoToThreeVC" sender:nil];

    
    AlertManager *alertM = [AlertManager shareIntance];
    Manager *manager = [Manager shareInstance];
    
    NSString *errorMsg = nil;
    if (self.codeTextField.text == nil || self.codeTextField.text.length == 0) {
        errorMsg = @"请填写手机验证码";
    }
    
    if (self.phoneTextField.text == nil || self.phoneTextField.text.length != 11) {
        errorMsg = @"请填写正确的电话号码";
    }
    
    if (self.nameTextField.text == nil || self.nameTextField.text.length == 0) {
        errorMsg = @"请填写姓名";
    }
    
    if (self.selectPostionInt == 0) {
        errorMsg = @"请选择职位";
    }
    
    if (errorMsg == nil) {
        //停止短信倒计时
        [self endTimeDown];
        
        //先验证这个手机号是否被注册
        [manager httpRegisterCheckPhoneWithMobile:self.phoneTextField.text withCheckPhoneSuccess:^(id successResult) {
            //没有注册过 下一步验证短信验证码
            [manager httpCheckMsgCodeWithMobile:self.phoneTextField.text withMobileCode:self.codeTextField.text withCheckCodeSuccess:^(id successResult) {
                //验证成功，就可以下一步
                NSDictionary *senderDic = @{@"mobile":self.phoneTextField.text,@"trueName":self.nameTextField.text,@"position":[NSString stringWithFormat:@"%ld",self.selectPostionInt ]};
                [self performSegueWithIdentifier:@"registerTwoToThreeVC" sender:senderDic];
                
            } withCheckCodeFail:^(NSString *failResultStr) {
                //如果验证不成功，提示
                [alertM showAlertViewWithTitle:@"短信验证码验证失败" withMessage:failResultStr actionTitleArr:@[@"确定"] withViewController:self withReturnCodeBlock:nil];
            }];
            
            
        } withCheckPhoneFail:^(NSString *failResultStr) {
            [alertM showAlertViewWithTitle:@"暂时不能注册" withMessage:failResultStr actionTitleArr:@[@"确定"] withViewController:self withReturnCodeBlock:nil];
        }];
        
    }else {
        //信息没有填写完整
        [alertM showAlertViewWithTitle:errorMsg withMessage:nil actionTitleArr:@[@"确定"] withViewController:self withReturnCodeBlock:nil];
    }

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
    if ([segue.identifier isEqualToString:@"registerTwoToThreeVC"]) {
        RegisterThreeViewController *registerThreeVC = [segue destinationViewController];
        registerThreeVC.tempTruename = [sender objectForKey:@"trueName"];
        registerThreeVC.tempMobile = [sender objectForKey:@"mobile"];
        registerThreeVC.tempPosition = [sender objectForKey:@"position"];
        registerThreeVC.tempAreaId = self.tempAreaId;
        registerThreeVC.tempFuserId = self.tempFuserId;
    }
}


@end
