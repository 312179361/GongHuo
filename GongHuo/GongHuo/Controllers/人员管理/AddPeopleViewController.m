//
//  AddPeopleViewController.m
//  GongHuo
//
//  Created by TongLi on 2017/7/5.
//  Copyright © 2017年 TongLi. All rights reserved.
//

#import "AddPeopleViewController.h"
#import "AlertManager.h"
#import "Manager.h"
@interface AddPeopleViewController ()
@property(nonatomic,strong)NSArray *positionArr;
@property(nonatomic,assign)NSInteger postionInt;//1老板/经理 2业务经理 3仓管 4发货负责人5财务
@property (weak, nonatomic) IBOutlet UIButton *positionButton;

@property (weak, nonatomic) IBOutlet UITextField *nameTextField;
@property (weak, nonatomic) IBOutlet UITextField *phoneTextField;
//@property (weak, nonatomic) IBOutlet UILabel *phoneLabel;
@property (weak, nonatomic) IBOutlet UITextField *codeTextField;
@property (weak, nonatomic) IBOutlet UIButton *sendCodeButton;

@property (weak, nonatomic) IBOutlet UIView *backCardView;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *backCardViewHeightLayout;
@property (weak, nonatomic) IBOutlet UITextField *cardPeopleTextField;//收款人
@property (weak, nonatomic) IBOutlet UITextField *cardNoTextField;//卡号
//确定添加按钮
@property (weak, nonatomic) IBOutlet UIButton *enterButton;

//定时器
@property (nonatomic,strong)NSTimer *tempTimer;
@property (nonatomic,assign)NSInteger countDownTime;//倒计时秒数

@end

@implementation AddPeopleViewController
- (IBAction)leftBarButtonAction:(UIBarButtonItem *)sender {
    [self.navigationController popViewControllerAnimated:YES];
}
- (IBAction)rightBarButtonAction:(UIBarButtonItem *)sender {
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    //设置倒计时初始值
    self.countDownTime = 60;
    //初始化数组
    self.positionArr = @[@"老板/经理",@"业务经理",@"仓管",@"发货负责人",@"财务"];

    //是编辑 还是添加
    if (self.tempUserModel != nil) {
        //编辑
        self.title = @"人员编辑";
        //给postionInt赋值
        self.postionInt = [self.tempUserModel.l_is_admin integerValue];
        [self updateBankView];
        [self updateAllViewInfo];
        
        self.phoneTextField.userInteractionEnabled = NO;
//        self.phoneTextField.hidden = YES;
//        self.phoneLabel.hidden = NO;
        
        
        [self.enterButton setTitle:@"提交编辑" forState:UIControlStateNormal];
        
    }else {
        //添加
        self.title = @"添加人员";
        self.phoneTextField.userInteractionEnabled = YES;
//        self.phoneTextField.hidden = NO;
//        self.phoneLabel.hidden = YES;
        [self.enterButton setTitle:@"立即添加" forState:UIControlStateNormal];

    }
    
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    [SVProgressHUD dismiss];
    //定制器取消
    [self endTimeDown];
}


#pragma mark - 刷新View -
//刷新页面信息
- (void)updateAllViewInfo {
    [self.positionButton setTitleColor:k333333Color forState:UIControlStateNormal];
    [self.positionButton setTitle:self.positionArr[self.postionInt-1] forState:UIControlStateNormal];
    
    self.nameTextField.text = self.tempUserModel.l_name;
    self.phoneTextField.text = self.tempUserModel.l_mobile;
//    self.phoneLabel.text = self.tempUserModel.l_mobile;
    self.cardPeopleTextField.text = self.tempUserModel.l_bank_name;
    self.cardNoTextField.text = self.tempUserModel.l_card_num;
    
}
//通过职位选择是否有银行信息
- (void)updateBankView {
    if (self.postionInt == 1 || self.postionInt == 5) {
        self.backCardViewHeightLayout.constant = 150;
        self.backCardView.hidden = NO;
    }else {
        self.backCardViewHeightLayout.constant = 0;
        self.backCardView.hidden = YES;
    }
}

//清空下面的的输入框
- (void)clearTextField {
//    self.nameTextField.text = nil;
//    self.phoneTextField.text = nil;
//    self.codeTextField.text = nil;
    self.cardPeopleTextField.text = nil;
    self.cardNoTextField.text = nil;
}

#pragma mark - 选择职位 -
//选择职位
- (IBAction)positionButtonAction:(UIButton *)sender {
    
    AlertManager *alertM = [AlertManager shareIntance];
    
    [alertM showActionSheetViewWithTitle:@"请选择职位" withMessage:nil actionTitleArr:self.positionArr withViewController:self withReturnCodeBlock:^(NSInteger actionBlockNumber) {
        //给标题赋值
        [sender setTitle:self.positionArr[actionBlockNumber] forState:UIControlStateNormal];
        [sender setTitleColor:k333333Color forState:UIControlStateNormal];
        //记录一下选择的职位
        if (self.postionInt != actionBlockNumber+1) {
            self.postionInt = actionBlockNumber+1;//因为actionBlockNumber是从0开始的
            //老板和财务需要添加银行卡
            [self updateBankView];
            [self clearTextField];
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



//发送短信验证码
- (IBAction)sendMsgButtonAction:(UIButton *)sender {
    Manager *manager = [Manager shareInstance];
    AlertManager *alertM = [AlertManager shareIntance];
    NSString *mobileStr = @"" ;
    if (self.tempUserModel != nil) {
        mobileStr = self.tempUserModel.l_mobile;
    }else{
        mobileStr = self.phoneTextField.text;
    }
    
    if (mobileStr.length == 11) {
        [manager httpSendMsgCodeWithMobile:mobileStr withSendMsgSuccess:^(id successResult) {
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


//立即添加
- (IBAction)addButtonAction:(UIButton *)sender {
    AlertManager *alertM = [AlertManager shareIntance];
    Manager *manager = [Manager shareInstance];
    
    NSString *errorMsg = @"";
    if (self.postionInt == 1 || self.postionInt == 5) {
        if (self.cardNoTextField.text == nil || [self.cardNoTextField.text isEqualToString:@""]) {
            errorMsg = @"请填写收款账号";
        }
        if (self.cardPeopleTextField.text == nil || [self.cardPeopleTextField.text isEqualToString:@""]) {
            errorMsg = @"请填写收款人";
        }
    }
   
//    if (self.codeTextField.text == nil || [self.codeTextField.text isEqualToString:@""]) {
//        errorMsg = @"请填写手机验证码";
//    }
    NSString *mobileStr = @"";
    if (self.tempUserModel == nil) {
        //只有添加才会有电话
        if (self.phoneTextField.text != nil || self.phoneTextField.text.length == 11) {
            mobileStr = self.phoneTextField.text;
        }else {
            errorMsg = @"请填写正确的电话号码";
        }
    }else {
        mobileStr = self.tempUserModel.l_mobile;
    }
    
    if (self.nameTextField.text == nil || [self.nameTextField.text isEqualToString:@""]) {
        errorMsg = @"请填写姓名";
    }
    if (self.postionInt == 0) {
        errorMsg = @"请选择职位";
    }
    
    if ([errorMsg isEqualToString:@""]) {
        
        //停止短信倒计时
//        [self endTimeDown];
        //验证短信验证码
//        [manager httpCheckMsgCodeWithMobile:mobileStr withMobileCode:self.codeTextField.text withCheckCodeSuccess:^(id successResult) {
        
        //如果是添加的老板，或者是编辑成老板，就要去验证一下
        if (self.postionInt == 1) {
            [manager httpIsAddBossWithLsid:manager.memberInfoModel.l_s_id withIsAddSuccess:^(id successResult) {
                [self httpAddPeopleAction];

            } withIdAddFail:^(NSString *failResultStr) {
                [alertM showAlertViewWithTitle:@"暂不能添加" withMessage:failResultStr actionTitleArr:@[@"确定"] withViewController:self withReturnCodeBlock:nil];
            }];
            
        }else {
            //不是老板，就可以直接添加
            [self httpAddPeopleAction];
        }
        
      
//        } withCheckCodeFail:^(NSString *failResultStr) {
            //如果验证不成功，提示
//            [alertM showAlertViewWithTitle:@"短信验证码验证失败" withMessage:failResultStr actionTitleArr:@[@"确定"] withViewController:self withReturnCodeBlock:nil];
//        }];
        
        
    }else {
        //信息没有填写完整
        [alertM showAlertViewWithTitle:errorMsg withMessage:nil actionTitleArr:@[@"确定"] withViewController:self withReturnCodeBlock:nil];
    }
    
}


//网络请求，添加 或者编辑
- (void)httpAddPeopleAction {
    Manager *manager = [Manager shareInstance];
    AlertManager *alertM = [AlertManager shareIntance];
    
    //如果验证成功，就可以编辑人员或者添加人员
    if (self.tempUserModel!= nil) {
        //编辑人员
        [manager httpEditUserWithMemberInfo:self.tempUserModel withToken:manager.memberInfoModel.token withPostionType:self.postionInt withTureName:self.nameTextField.text withMobile:self.tempUserModel.l_mobile withCardPeople:self.cardPeopleTextField.text withCard:self.cardNoTextField.text withEditUserSuccess:^(id successResult) {
            //编辑成功后
            [alertM showAlertViewWithTitle:@"恭喜您，编辑成功" withMessage:nil actionTitleArr:@[@"确定"] withViewController:self withReturnCodeBlock:^(NSInteger actionBlockNumber) {
                //刷新列表
                [[NSNotificationCenter defaultCenter] postNotificationName:@"refreshPeopleListNoti" object:self userInfo:nil];
                
                [self.navigationController popViewControllerAnimated:YES];
            }];
        } withEditUserFail:^(NSString *failResultStr) {
            //编辑失败
            [alertM showAlertViewWithTitle:@"编辑失败" withMessage:failResultStr actionTitleArr:@[@"确定"] withViewController:self withReturnCodeBlock:nil];
        }];
        
    }else {
        //添加人员
        [manager httpAddUserWithMemberInfo:manager.memberInfoModel withPostionType:self.postionInt withTureName:self.nameTextField.text withMobile:self.phoneTextField.text withCardPeople:self.cardPeopleTextField.text withCard:self.cardNoTextField.text withAddUserSuccess:^(id successResult) {
            
            //添加成功
            [alertM showAlertViewWithTitle:@"恭喜您，添加成功" withMessage:nil actionTitleArr:@[@"确定"] withViewController:self withReturnCodeBlock:^(NSInteger actionBlockNumber) {
                //刷新列表
                [[NSNotificationCenter defaultCenter] postNotificationName:@"refreshPeopleListNoti" object:self userInfo:nil];
                [self.navigationController popViewControllerAnimated:YES];
            }];
            
            
        } withAddUserFail:^(NSString *failResultStr) {
            //添加失败
            [alertM showAlertViewWithTitle:@"添加失败" withMessage:failResultStr actionTitleArr:@[@"确定"] withViewController:self withReturnCodeBlock:nil];
        }];
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
