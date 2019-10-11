//
//  AlertCustomizeViewController.m
//  GongHuo
//
//  Created by TongLi on 2017/9/19.
//  Copyright © 2017年 TongLi. All rights reserved.
//

#import "AlertCustomizeViewController.h"
#import "AlertManager.h"
@interface AlertCustomizeViewController ()
//第一个AlertView
@property(nonatomic,assign)NSInteger selectShelfInt;//选择下架原因 0不代理 1无货 2其他
@property (weak, nonatomic) IBOutlet UIImageView *backImgView;

//定时器
@property (nonatomic,strong)NSTimer *tempTimer;

@end

@implementation AlertCustomizeViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.backImgView.image = self.backImg;
    
    self.alertOneView.hidden = YES;
    self.alertTwoView.hidden = YES;
    self.alertThreeView.hidden = YES;

    
    switch (self.alertTypeInt) {
        case alertOne:
            [self showAlertViewOne];
            break;
            
        case alertTwo:
            self.alertTwoView.hidden = NO;
            [self showAlertViewTwo];
            break;
        
        case alertThree:
            self.alertThreeView.hidden = NO;
            [self showAlertViewThree];
            break;
        default:
            break;
    }
    
}

#pragma mark - 第一个alertView显示 -
- (void)showAlertViewOne {
    self.alertOneView.hidden = NO;
    //默认选择 不代理
    self.selectShelfInt = 0;
    
}

//不代理按钮
- (IBAction)noDelegateBtnAction:(UIButton *)sender {
    [self keyboardDismissAction];
    
    if (self.selectShelfInt != 0) {
        self.selectShelfInt = 0;
        //更改UI
        [self.noDelegateBtn setImage:[UIImage imageNamed:@"btn_select"] forState:UIControlStateNormal];
        [self.stockBtn setImage:[UIImage imageNamed:@"btn_normal"] forState:UIControlStateNormal];
        [self.otherBtn setImage:[UIImage imageNamed:@"btn_normal"] forState:UIControlStateNormal];
    }
}
- (IBAction)stockBtnAction:(UIButton *)sender {
    [self keyboardDismissAction];
    
    if (self.selectShelfInt != 1) {
        self.selectShelfInt = 1;
        //更改UI
        [self.noDelegateBtn setImage:[UIImage imageNamed:@"btn_normal"] forState:UIControlStateNormal];
        [self.stockBtn setImage:[UIImage imageNamed:@"btn_select"] forState:UIControlStateNormal];
        [self.otherBtn setImage:[UIImage imageNamed:@"btn_normal"] forState:UIControlStateNormal];
    }
}
- (IBAction)otherBtnAction:(UIButton *)sender {
    [self keyboardDismissAction];
    
    if (self.selectShelfInt != 2) {
        self.selectShelfInt = 2;
        //更改UI
        [self.noDelegateBtn setImage:[UIImage imageNamed:@"btn_normal"] forState:UIControlStateNormal];
        [self.stockBtn setImage:[UIImage imageNamed:@"btn_normal"] forState:UIControlStateNormal];
        [self.otherBtn setImage:[UIImage imageNamed:@"btn_select"] forState:UIControlStateNormal];
    }
}
//确定按钮
- (IBAction)alertOneEnterBtnAction:(UIButton *)sender {
    [self keyboardDismissAction];
    
    NSDictionary *enterBlockDic = @{@"reasonInt":[NSString stringWithFormat:@"%ld",self.selectShelfInt],
      @"reasonStr":self.reasonTextView.text};
    
    self.enterBlock(enterBlockDic);
    [self dismissViewControllerAnimated:NO completion:nil];

}
- (IBAction)alertOneCloseBtnAction:(UIButton *)sender {
    [self keyboardDismissAction];
    [self dismissViewControllerAnimated:NO completion:nil];
}



#pragma mark - 第二个alertView显示 -
- (void)showAlertViewTwo {
    self.alertTwoView.hidden = NO;
    self.alertTwoTitleLabel.text = self.alertTwoTitleStr;
    //老数据赋值
    self.numberTextField.text = self.oldNumberStr;
    

}
//减少
- (IBAction)lessBtnAction:(UIButton *)sender {
    [self keyboardDismissAction];
    
    NSInteger numberTextInt = [self.numberTextField.text integerValue];
    numberTextInt--;
    self.numberTextField.text = [NSString stringWithFormat:@"%ld", numberTextInt];
}
//增加
- (IBAction)addBtnAction:(UIButton *)sender {
    [self keyboardDismissAction];
    
    NSInteger numberTextInt = [self.numberTextField.text integerValue];
    numberTextInt++;
    self.numberTextField.text = [NSString stringWithFormat:@"%ld", numberTextInt];

}

- (IBAction)alertTwoEnterBtnAction:(UIButton *)sender {
    [self keyboardDismissAction];
    
    AlertManager *alertM = [AlertManager shareIntance];
    
    if ( self.numberTextField.text != self.oldNumberStr) {
        self.enterBlock(self.numberTextField.text);
        [self dismissViewControllerAnimated:NO completion:nil];
    }else {
        //
        [alertM showAlertViewWithTitle:@"您没有做任何修改" withMessage:nil actionTitleArr:@[@"确定"] withViewController:self withReturnCodeBlock:nil];
    }
}

- (IBAction)alertTwoCloseBtnAction:(UIButton *)sender {
    [self keyboardDismissAction];
    [self dismissViewControllerAnimated:NO completion:nil];
}

#pragma mark - 第三个alertView显示 -
- (void)showAlertViewThree {
    self.alertThreeView.hidden = NO;
    self.timeLabel.text = @"00:00:00";
    Manager *manager = [Manager shareInstance];
    self.timeLabel.text = [manager getHHMMSSFromSS:self.timeCount];
    //创建定时器。
    self.tempTimer = [NSTimer scheduledTimerWithTimeInterval:1 target:self selector:@selector(timerAction:) userInfo:nil repeats:YES];
    
}

- (void)timerAction:(NSTimer *)timer {
    Manager *manager = [Manager shareInstance];

    self.timeCount--;
    if (self.timeCount >= 0) {
        self.timeLabel.text = [manager getHHMMSSFromSS:self.timeCount];
    }else {
        //停止定时器
        [self.tempTimer invalidate];
    }
    
}

- (IBAction)alertThreeEnterBtnAction:(UIButton *)sender {
    self.enterBlock(@"跳转到订单列表");
    //停止定时器
    [self.tempTimer invalidate];
    [self dismissViewControllerAnimated:NO completion:nil];
}

- (IBAction)alertThreeCloseBtnAction:(UIButton *)sender {
    //停止定时器
    [self.tempTimer invalidate];
    [self dismissViewControllerAnimated:NO completion:nil];
}

#pragma mark - 键盘消失 -
- (IBAction)tapBackViewAction:(UITapGestureRecognizer *)sender {
    [self keyboardDismissAction];
}

- (void)keyboardDismissAction {
    [self.reasonTextView resignFirstResponder];
    [self.numberTextField resignFirstResponder];
    
    
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
