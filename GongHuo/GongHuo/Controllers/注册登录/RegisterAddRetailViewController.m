//
//  RegisterAddRetailViewController.m
//  GongHuo
//
//  Created by TongLi on 2017/10/14.
//  Copyright © 2017年 TongLi. All rights reserved.
//

#import "RegisterAddRetailViewController.h"
#import "SelectAddressView.h"
#import "Manager.h"
@interface RegisterAddRetailViewController ()

//地区选择
@property (weak, nonatomic) IBOutlet UIButton *areaButton;
//市场
@property (weak, nonatomic) IBOutlet UITextField *markTextField;
//门市名输入框
@property (weak, nonatomic) IBOutlet UITextField *retailNameTextField;
//门市地址输入框
@property (weak, nonatomic) IBOutlet UITextField *retailAddressTextField;

//地区选择器
@property (nonatomic,strong) SelectAddressView *selectAddressView;
//选择了地区的地区id
@property (nonatomic,strong) NSString *selectAreaId;

//选择的市场dic
@property (nonatomic,strong)NSDictionary *selectMarkDic;
@end

@implementation RegisterAddRetailViewController

- (IBAction)leftBarButtonAction:(UIBarButtonItem *)sender {

    [self.navigationController popViewControllerAnimated:YES];
}


- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    //加载地区pickView
    self.selectAddressView = [[[NSBundle mainBundle] loadNibNamed:@"SelectAddressView" owner:self options:nil] firstObject];
    self.selectAddressView.frame = self.view.frame;
    //首先先隐藏
    self.selectAddressView.hidden = YES;
    [self.view addSubview:self.selectAddressView];
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear: animated];
    [SVProgressHUD dismiss];
}


#pragma mark - 选择地区 -
//选择地区按钮
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
        [self.areaButton setTitleColor:k333333Color forState:UIControlStateNormal];
        
        //选择了新的地址
        if (areaId != self.selectAreaId) {
            self.selectAreaId = areaId;
            //清空市场
            self.selectMarkDic = nil;
            self.markTextField.text = nil;
        }
        //请求所在市场
        [self markListData];
        
    }];
}

#pragma mark - 市场 -
//市场的网络请求
- (void)markListData {
    Manager *manager = [Manager shareInstance];
    AlertManager *alertM = [AlertManager shareIntance];
    
    if (self.selectAreaId != nil && self.selectAreaId.length > 0) {
        [manager httpMarkListWithAreaId:self.selectAreaId withMarkSuccess:^(id successResult) {
            
            NSArray *markListArr = successResult;
            if (markListArr.count > 0) {
                //给市场赋值
                self.markTextField.text = [[markListArr firstObject] objectForKey:@"M_NAME"];
                self.selectMarkDic = [markListArr firstObject];
                
            }else {
                //没有市场
                [alertM showAlertViewWithTitle:@"这个地区没有市场" withMessage:nil actionTitleArr:@[@"确定"] withViewController:self withReturnCodeBlock:nil];
            }
            
        } withMarkFail:^(NSString *failResultStr) {
            [alertM showAlertViewWithTitle:@"市场获取失败" withMessage:failResultStr actionTitleArr:@[@"确定"] withViewController:self withReturnCodeBlock:nil];
        }];

    }
    
    
    
    
}

//添加门市按钮
- (IBAction)addRetailButtonAction:(UIButton *)sender {
    Manager *manager = [Manager shareInstance];
    AlertManager *alertM = [AlertManager shareIntance];
    
    NSString *error = nil;
    //门市地址
    if (self.retailAddressTextField.text == nil || self.retailAddressTextField.text.length == 0) {
        error = @"请填写门市地址";
    }
    //门市名称
    if (self.retailNameTextField.text == nil || self.retailNameTextField.text.length == 0) {
        error = @"请填写门市名称";
    }
    //市场id
    if (self.selectMarkDic == nil) {
        error = @"没有市场，暂不能添加门市";
    }
    
    if (error == nil) {
        [manager httpAddShopWithMid:[self.selectMarkDic objectForKey:@"M_ID"] withName:self.retailNameTextField.text withDeveloperName:self.tempMobile withAreaid:self.selectAreaId withAddress:self.retailAddressTextField.text withAddShopSuccess:^(id successResult) {
            

            [self.navigationController popViewControllerAnimated:YES];
            
        } withAddShopFail:^(NSString *failResultStr) {
            [alertM showAlertViewWithTitle:@"添加失败" withMessage:failResultStr actionTitleArr:@[@"确定"] withViewController:self withReturnCodeBlock:nil];

        }];
    }else {
        [alertM showAlertViewWithTitle:error withMessage:nil actionTitleArr:@[@"确定"] withViewController:self withReturnCodeBlock:nil];
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
