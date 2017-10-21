//
//  ReviewDetailViewController.m
//  GongHuo
//
//  Created by TongLi on 2017/9/15.
//  Copyright © 2017年 TongLi. All rights reserved.
//

#import "ReviewDetailViewController.h"
#import "UploadProductViewController.h"
@interface ReviewDetailViewController ()

//控件
//图片

//名称
@property (weak, nonatomic) IBOutlet UILabel *productNameLabel;

//信息
@property (weak, nonatomic) IBOutlet UILabel *productStandardLabel;
@property (weak, nonatomic) IBOutlet UILabel *productIngrendientLabel;
@property (weak, nonatomic) IBOutlet UILabel *factoryLabel;
@property (weak, nonatomic) IBOutlet UILabel *productPriceLabel;
@property (weak, nonatomic) IBOutlet UILabel *productInventoryLabel;
@property (weak, nonatomic) IBOutlet UILabel *productCodeLabel;
@property (weak, nonatomic) IBOutlet UILabel *productDosageLabel;
@property (weak, nonatomic) IBOutlet UILabel *productNHLabel;

//未通过原因
@property (weak, nonatomic) IBOutlet UILabel *noPassLabel;

//未通过原因标题高度
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *noPassTitleHeightLayout;
//未通过原因高度
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *noPassHeightLayout;

@end

@implementation ReviewDetailViewController
- (IBAction)leftBarButtonAction:(UIBarButtonItem *)sender {
    [self.navigationController popViewControllerAnimated:YES];
    
}

//编辑
- (IBAction)rightBarButtonAction:(UIBarButtonItem *)sender {
    
    [self performSegueWithIdentifier:@"productDetailToUploadVC" sender:self.tempCheckModel];
}


- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    //网络请求产品详情
    Manager *manager = [Manager shareInstance];
    
    switch (self.fromType) {
        case 0://从审核中心
        {
            [self updateInfoUIFromReviewList];
            
            [manager httpProductInfoWithAID:self.tempCheckModel.A_ID withProductInfoSuccess:^(id successResult) {
                
                self.tempCheckModel = successResult;
                [self updateInfoUIFromReviewList];
                
            } withProductInfoFail:^(NSString *failResultStr) {
                
            }];

        }
            break;
        case 1://从供货列表
        {
            //隐藏右边的navigationItem
            self.navigationItem.rightBarButtonItem = nil;
            [self updateInfoUIFromSupplyList];
            
        }
            break;
        default:
            break;
    }
    
    
    
    
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    switch (self.fromType) {
        case 0:
            if ([self.tempCheckModel.A_STATUS_CHECK isEqualToString:@"0"]) {
                self.noPassTitleHeightLayout.constant = 0;
                self.noPassHeightLayout.constant = 0;
            }
            break;
        case 1:
            //只有是修改记录，并且是修改不成功的，才会有审核不通过原因
            if (![self.currentType isEqualToString:@"1"] || ![self.tempSupplyModel.A_STATUS_CHECK isEqualToString:@"2"]) {
                self.noPassTitleHeightLayout.constant = 0;
                self.noPassHeightLayout.constant = 0;
            }
            
            break;
        default:
            break;
    }
    
    
    
    
}

//来源：供货列表 刷新UI
- (void)updateInfoUIFromReviewList {
    
    self.productNameLabel.text = self.tempCheckModel.A_NAME;
    self.productStandardLabel.text = self.tempCheckModel.A_STANDARD;
    self.productIngrendientLabel.text = self.tempCheckModel.A_INGREDIENT;
    self.factoryLabel.text = self.tempCheckModel.A_FACTORY_NAME;
    self.productPriceLabel.text = [NSString stringWithFormat:@"￥%@元",self.tempCheckModel.A_PRICE_COST];
    self.productInventoryLabel.text = self.tempCheckModel.A_INVENTORY;
    self.productCodeLabel.text = self.tempCheckModel.A_VALUE;
    self.productDosageLabel.text = self.tempCheckModel.A_DOSAGE_VALUE;
    self.productNHLabel.text = self.tempCheckModel.A_NH;
    
    self.noPassLabel.text = self.tempCheckModel.A_PROPOSAL;
    
}

//来源：供货中心 刷新UI
- (void)updateInfoUIFromSupplyList {
    self.productNameLabel.text = self.tempSupplyModel.A_NAME;
    self.productStandardLabel.text = self.tempSupplyModel.A_STANDARD;
    self.productIngrendientLabel.text = self.tempSupplyModel.A_INGREDIENT;
    self.factoryLabel.text = self.tempSupplyModel.A_MANUFACTOR;
    self.productCodeLabel.text = self.tempSupplyModel.A_CODE_VALUE;
    self.productDosageLabel.text = self.tempSupplyModel.A_DOSAGE_VALUE;
    self.productNHLabel.text = self.tempSupplyModel.A_METHOD;
    
    self.noPassLabel.text = self.tempSupplyModel.A_PROPOSAL;
    
    //价格和库存 先赋成原价格和原库存
    self.productPriceLabel.text = [NSString stringWithFormat:@"￥%@元",self.tempSupplyModel.A_PRICE_COST];
    self.productInventoryLabel.text = [NSString stringWithFormat:@"%@件",self.tempSupplyModel.D_INVENTORY];
    
    
    //只有修改记录中，并且是修改成功 的显示新价格和新库存，
    if ([self.currentType integerValue] == 1 && [self.tempSupplyModel.A_STATUS_CHECK integerValue] == 1) {
        
        if ([self.tempSupplyModel.A_EDIT_TYPE isEqualToString:@"2"]) {
            //新价格
            self.productPriceLabel.text = [NSString stringWithFormat:@"￥%@元",self.tempSupplyModel.A_PRICE];
        }
        
        if ([self.tempSupplyModel.A_EDIT_TYPE isEqualToString:@"3"]) {
            //新库存
            self.productInventoryLabel.text = [NSString stringWithFormat:@"%@件",self.tempSupplyModel.A_INVENTORY];
        }
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
    if ([segue.identifier isEqualToString:@"productDetailToUploadVC"]) {
        UploadProductViewController *uploadProductVC = [segue destinationViewController];
        uploadProductVC.tempType = 2;
        uploadProductVC.tempProductModel = sender;
    }
    
}


@end
