//
//  RegisterOneViewController.m
//  GongHuo
//
//  Created by TongLi on 2017/10/14.
//  Copyright © 2017年 TongLi. All rights reserved.
//

#import "RegisterOneViewController.h"
#import "SelectAddressView.h"
#import "RegisterAddRetailViewController.h"
#import "Manager.h"
#import "RegisterHeaderView.h"
#import "RegisterTwoViewController.h"
@interface RegisterOneViewController ()
@property (weak, nonatomic) IBOutlet UIView *headView;

//所在地区选择
@property (weak, nonatomic) IBOutlet UIButton *areaButton;
//门市选择
@property (weak, nonatomic) IBOutlet UIButton *shopButton;
//推广电话
@property (weak, nonatomic) IBOutlet UITextField *promoterTextField;

//地区选择器
@property (nonatomic,strong) SelectAddressView *selectAddressView;
//选择了地区的地区id
@property (nonatomic,strong) NSString *selectAreaId;
//选择了门市字典
@property (nonatomic,strong)NSDictionary *selectRetailDic;

@end

@implementation RegisterOneViewController
- (IBAction)leftBarButtonAction:(UIBarButtonItem *)sender {
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    //加载注册头部view
    RegisterHeaderView *registerHeadView = [[[NSBundle mainBundle] loadNibNamed:@"RegisterHeaderView" owner:self options:nil] firstObject];
    [registerHeadView updateWithStep:1];
    [self.headView addSubview:registerHeadView];
    
    
    
    //加载地区pickView
    self.selectAddressView = [[[NSBundle mainBundle] loadNibNamed:@"SelectAddressView" owner:self options:nil] firstObject];
    self.selectAddressView.frame = self.view.frame;
    //首先先隐藏
    self.selectAddressView.hidden = YES;
    [self.view addSubview:self.selectAddressView];
    
}

#pragma mark - 所在地区 -
//所在地区按钮
- (IBAction)areaButtonAction:(UIButton *)sender {
    Manager *manager = [Manager shareInstance];
    AlertManager *alertM = [AlertManager shareIntance];
    if (manager.areaTree.count == 0) {
        NSLog(@"需要请求");
        //需要请求
        [manager httpAreaTreeWithAreaSuccess:^(id successResult) {
            NSLog(@"%@",manager.areaTree);
            [self showAddressPickView];
        } withAreaFail:^(NSString *failResultStr) {
            [alertM showAlertViewWithTitle:@"暂时不能选择地区" withMessage:failResultStr actionTitleArr:@[@"确定"] withViewController:self withReturnCodeBlock:nil];
        }];
    }else {
        NSLog(@"不需要请求");
        NSLog(@"%@",manager.areaTree);
        [self showAddressPickView];

    }
}

//显示pickView
- (void)showAddressPickView {
    
    [self.selectAddressView showPickerViewEnterSelectAreaWithAreaInfo:^(NSString *areaId, NSString *shengStr, NSString *shiStr, NSString *quStr) {
        //
        NSLog(@"地区id%@",areaId);
        [self.areaButton setTitle:[NSString stringWithFormat:@"%@ %@ %@",shengStr,shiStr,quStr] forState:UIControlStateNormal];
        
        //选择了新的地址
        if (areaId != self.selectAreaId) {
            self.selectAreaId = areaId;
            //要清空门市信息
            self.selectRetailDic = nil;
            [self.shopButton setTitle:@"请选择门市" forState:UIControlStateNormal];

        }
        
        
        
        /*
        if (self.tempReceiveAddressModel != nil) {
            //修改的情况
            self.addressModelCopy.areaID = areaId;
            self.addressModelCopy.capitalname = shengStr;
            self.addressModelCopy.cityname = shiStr;
            self.addressModelCopy.countyname = quStr;
            
        }else {
            //新增的情况
            self.addReceiveAddressModel.areaID = areaId;
            self.addReceiveAddressModel.capitalname = shengStr;
            self.addReceiveAddressModel.cityname = shiStr;
            self.addReceiveAddressModel.countyname = quStr;
        }
         */
        
    }];
}




#pragma mark - 门市选择 -
//门市按钮
- (IBAction)shopButtonAction:(UIButton *)sender {
    Manager *manager = [Manager shareInstance];
    AlertManager *alertM = [AlertManager shareIntance];
    
    if (self.selectAreaId != nil && self.selectAreaId.length > 0) {
        [manager httpRetailListWithAreaId:self.selectAreaId withRetailSuccess:^(id successResult) {
            //请求出了门市
            NSArray *retailList = [NSArray arrayWithArray:successResult];

            if (retailList.count > 0) {
                UIAlertController *alertC = [UIAlertController alertControllerWithTitle:@"请选择门市" message:nil preferredStyle:UIAlertControllerStyleActionSheet];
                
                for (int i = 0 ; i < retailList.count; i++) {
                    UIAlertAction *action = [UIAlertAction actionWithTitle:[retailList[i] objectForKey:@"F_NAME"] style:(UIAlertActionStyleDefault) handler:^(UIAlertAction * _Nonnull action) {
                        
                        [self.shopButton setTitle:[retailList[i] objectForKey:@"F_NAME"] forState:UIControlStateNormal];
                        self.selectRetailDic = retailList[i];
                        
                    }];
                    [alertC addAction:action];
                }
                [self presentViewController:alertC animated:YES completion:nil];
                
            }else {
                [alertM showAlertViewWithTitle:@"这个地区还没有门市，请手动添加新门市" withMessage:nil actionTitleArr:@[@"确定"] withViewController:self withReturnCodeBlock:nil];
            }
            
        } withRetailFail:^(NSString *failResultStr) {
            [alertM showAlertViewWithTitle:@"门市请求失败" withMessage:failResultStr actionTitleArr:@[@"确定"] withViewController:self withReturnCodeBlock:nil];
        }];
    }else {
        //
        [alertM showAlertViewWithTitle:@"您还没有选择所在地区" withMessage:nil actionTitleArr:@[@"确定"] withViewController:self withReturnCodeBlock:nil];
    }
}

#pragma mark - 添加门市 -
//添加门市按钮
- (IBAction)addShoppingButtonAction:(UIButton *)sender {
    Manager *manager = [Manager shareInstance];
    AlertManager *alertM = [AlertManager shareIntance];
    //先验证推广电话
    if (self.promoterTextField.text != nil && self.promoterTextField.text.length == 11) {
        [manager httpPromoterWithMobile:self.promoterTextField.text withPromoterSuccess:^(id successResult) {
            //验证成功  跳转到添加门市界面
            [self performSegueWithIdentifier:@"registerToAddRetailVC" sender:self.promoterTextField.text];
            
            
        } withPromoterFail:^(NSString *failResultStr) {
            [alertM showAlertViewWithTitle:@"无效的推广人手机号" withMessage:nil actionTitleArr:@[@"确定"] withViewController:self withReturnCodeBlock:nil];

        }];

    }else {
        [alertM showAlertViewWithTitle:@"请填写正确的推广人手机号" withMessage:nil actionTitleArr:@[@"确定"] withViewController:self withReturnCodeBlock:nil];
    }
}

#pragma mark - 下一步 -
- (IBAction)nextButtonAction:(UIButton *)sender {


    //推广人手机
    Manager *manager = [Manager shareInstance];
    AlertManager *alertM = [AlertManager shareIntance];
    NSString *error = nil;
    //验证地区填写了没
    if (self.selectAreaId == nil && self.selectAreaId.length == 0) {
        error = @"请填写所在地区";
    }
    //验证门市填写了没
    if (self.selectRetailDic == nil) {
        error = @"请选择门市或者添加门市";
    }
    
    if (self.promoterTextField.text == nil || self.promoterTextField.text.length != 11) {
        error = @"请填写正确的推广人手机号";
    }
    
    if (error == nil) {
        //验证推广手机
        [manager httpPromoterWithMobile:self.promoterTextField.text withPromoterSuccess:^(id successResult) {
            //验证推广人成功 就可以跳转了
            NSDictionary *senderDic = @{@"areaid":self.selectAreaId,@"fuserid":[self.selectRetailDic objectForKey:@"F_ID"]};
            [self performSegueWithIdentifier:@"registerOneToTwoVC" sender:senderDic];
            
        } withPromoterFail:^(NSString *failResultStr) {
            [alertM showAlertViewWithTitle:@"无效的推广人手机号" withMessage:nil actionTitleArr:@[@"确定"] withViewController:self withReturnCodeBlock:nil];
            
        }];
    }else {
        [alertM showAlertViewWithTitle:error withMessage:nil actionTitleArr:@[@"确定"] withViewController:self withReturnCodeBlock:nil];

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
    if ([segue.identifier isEqualToString:@"registerToAddRetailVC"]) {
        RegisterAddRetailViewController *addRetailVC = [segue destinationViewController];
        addRetailVC.tempMobile = sender;
    }
    if ([segue.identifier isEqualToString:@"registerOneToTwoVC"]) {
        RegisterTwoViewController *registerTwoVC = [segue destinationViewController];
        registerTwoVC.tempAreaId = [sender objectForKey:@"areaid"];
        registerTwoVC.tempFuserId = [sender objectForKey:@"fuserid"];
    }

}


@end
