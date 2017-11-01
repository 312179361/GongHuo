//
//  SendDetailViewController.m
//  GongHuo
//
//  Created by TongLi on 2017/9/23.
//  Copyright © 2017年 TongLi. All rights reserved.
//

#import "SendDetailViewController.h"
#import "Manager.h"
#import "AlertManager.h"
#import "PlaceholdTextView.h"
#import "SendCerViewController.h"
#import "UIImageView+ImageViewCategory.h"
@interface SendDetailViewController ()
//view1
@property (weak, nonatomic) IBOutlet UILabel *addressLabel;//收货人地址
@property (weak, nonatomic) IBOutlet UILabel *nameLabel;//收货人姓名
@property (weak, nonatomic) IBOutlet UILabel *mobileLabel;//收货人手机


@property (weak, nonatomic) IBOutlet UIImageView *productImageView;
@property (weak, nonatomic) IBOutlet UILabel *productNameLabel;//产品名
@property (weak, nonatomic) IBOutlet UILabel *productStandardLabel;//产品规格
@property (weak, nonatomic) IBOutlet UILabel *productNumberLabel;//产品数量
@property (weak, nonatomic) IBOutlet UILabel *productFactoryLabel;//产品公司

//view2
@property (weak, nonatomic) IBOutlet UIImageView *sendCerImageView;//发货单imageView
@property (weak, nonatomic) IBOutlet UILabel *sendCerLabel;//上传发货单 这5个字

//view3
@property (weak, nonatomic) IBOutlet PlaceholdTextView *sendReMarkTextView;//备注
@property (nonatomic,strong)NSString *imgUrl;

@end

@implementation SendDetailViewController
- (IBAction)leftBarButtonAction:(UIBarButtonItem *)sender {
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    //刷新view1
    [self updateViewOne];
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    [SVProgressHUD dismiss];
}

- (void)updateViewOne {
    [self.productImageView setWebImageURLWithImageUrlStr:self.tempOrderListModel.img withErrorImage:nil withIsCenter:YES];
    
    self.addressLabel.text = self.tempOrderListModel.address;
    self.nameLabel.text = self.tempOrderListModel.name;
    self.mobileLabel.text = self.tempOrderListModel.mobile;
    self.productNameLabel.text = self.tempOrderListModel.pname;
    self.productStandardLabel.text = self.tempOrderListModel.standard;
    self.productNumberLabel.text = [NSString stringWithFormat:@"数量：%@", self.tempOrderListModel.num];
    self.productFactoryLabel.text = self.tempOrderListModel.fname;
    
}

//上传发货单
- (IBAction)uploadSendCerTapAction:(UITapGestureRecognizer *)sender {

    
}




//提交发货
- (IBAction)sendButtonAction:(UIButton *)sender {
    
    Manager *manager = [Manager shareInstance];
    AlertManager *alertM = [AlertManager shareIntance];
    //假图片
    self.imgUrl = @"20179/9/E5B93C5CFCA94E30B6C501BC4DCA7F4B.jpg";
    NSString *error;
    if (self.imgUrl == nil || [self.imgUrl isEqualToString:@""]) {
        error = @"没有上传图片";
    }
    if ([self.sendReMarkTextView.text isEqualToString:@""]) {
        error = @"没有备注";
    }
    
    if (![error isEqualToString:@""]) {
        [manager httpOrderDeliverWithAId:self.tempOrderListModel.orderId withOId:self.tempOrderListModel.oid withToken:manager.memberInfoModel.token withAFUid:manager.memberInfoModel.userid withAFile:self.imgUrl withANote:self.sendReMarkTextView.text withDeliverSuccess:^(id successResult) {
            //发货成功
            [self performSegueWithIdentifier:@"toSendSuccessVC" sender:nil];
            
            
        } withDeliverFail:^(NSString *failResultStr) {
            [alertM showAlertViewWithTitle:@"发货失败" withMessage:failResultStr actionTitleArr:@[@"确定"] withViewController:self withReturnCodeBlock:nil];
        }];

    }else {
        [alertM showAlertViewWithTitle:@"不能发货" withMessage:error actionTitleArr:@[@"确定"] withViewController:self withReturnCodeBlock:nil];
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
    
   
}

@end
