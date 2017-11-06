//
//  UploadProductViewController.m
//  GongHuo
//
//  Created by TongLi on 2017/7/3.
//  Copyright © 2017年 TongLi. All rights reserved.
//

#import "UploadProductViewController.h"
#import "Manager.h"
#import "UIImageView+ImageViewCategory.h"
#import "PlaceholdTextView.h"
#import "SelectFormatViewController.h"
#import "SelectProductImageViewController.h"
#import "NewsViewController.h"
@interface UploadProductViewController ()
//头部约束
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *headLayout;
@property (weak, nonatomic) IBOutlet UIView *noImgBackView;
@property (weak, nonatomic) IBOutlet UIView *imgBackView;
@property (weak, nonatomic) IBOutlet UILabel *pageLabel;
//产品图片scrollview的contentView
@property (weak, nonatomic) IBOutlet UIView *productImageContentView;
@property (nonatomic,strong)NSMutableArray *productImageViewArr;//产品imageViews数组，方便管理

//要上传的产品模型
@property(nonatomic,strong)UploadProductModel *uploadProductModel;
//选择规格的两个按钮
@property (weak, nonatomic) IBOutlet UIButton *selectFormatButtonOne;
@property (weak, nonatomic) IBOutlet UIButton *selectFormatButtonTwo;

//作物分类数组
@property(nonatomic,strong)NSMutableArray *classArr;
//剂量数组
@property(nonatomic,strong)NSMutableArray *dosageArr;

//名字
@property (weak, nonatomic) IBOutlet PlaceholdTextView *nameTextField;
//规格textField1
@property (weak, nonatomic) IBOutlet UITextField *standardTextFieldOne;
//规格textField2
@property (weak, nonatomic) IBOutlet UITextField *standardTextFieldTwo;
//成分textField
@property (weak, nonatomic) IBOutlet UITextField *ingrendientTextField;
//厂家textField
@property (weak, nonatomic) IBOutlet UITextField *factoryTextField;
//报价textField
@property (weak, nonatomic) IBOutlet UITextField *priceTextField;
//库存textField
@property (weak, nonatomic) IBOutlet UITextField *inventoryTextField;
//分类button
@property (weak, nonatomic) IBOutlet UIButton *codeButton;
//剂量button
@property (weak, nonatomic) IBOutlet UIButton *dosageButton;

//简介
@property (weak, nonatomic) IBOutlet PlaceholdTextView *HNTextView;

//上传成功后的alertView
@property (weak, nonatomic) IBOutlet UIView *uploadSuccessView;


@end

@implementation UploadProductViewController
- (IBAction)leftBarButtonAction:(UIBarButtonItem *)sender {
    [self.navigationController popViewControllerAnimated:YES];
}
- (IBAction)rightBarButtonAction:(UIBarButtonItem *)sender {
    NewsViewController *newsVC = [self.storyboard instantiateViewControllerWithIdentifier:@"newsViewController"];
    [self.navigationController pushViewController:newsVC animated:YES];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear: animated];
    
    BOOL isContainImages = NO;
    
    for (NSString *tempImageStr in self.uploadProductModel.productImageArr) {
        if (tempImageStr.length > 0) {
            isContainImages = YES;
            break;
        }
    }
    //如果这个模型中，没有图片，
    if (isContainImages == NO) {
        self.headLayout.constant = 145;
        self.noImgBackView.hidden = NO;
        self.imgBackView.hidden = YES;
        
    }else {
        //如果这个模型中有图片
        self.headLayout.constant = kScreenW/3*2+1;
        self.noImgBackView.hidden = YES;
        self.imgBackView.hidden = NO;
        //有图片，就给图片赋值
        [self updateImageUI];
    }
    
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    if (self.tempType == 1) {
        self.title = @"添加产品";
    }else {
        self.title = @"修改产品";
    }
    
    //在scrollView上加imageView
    for (int i = 0; i < 6; i++) {
        UIImageView *productImageView = [[UIImageView alloc] initWithFrame:CGRectMake(kScreenW*i, 0, kScreenW, kScreenW/3*2)];
        [self.productImageContentView addSubview:productImageView];
        [self.productImageViewArr addObject:productImageView];
    }
    
    
    self.uploadProductModel = [[UploadProductModel alloc] init];
    if (self.tempProductModel!= nil) {
        //如果是修改产品，要创建上传模型，然后赋值
        self.uploadProductModel.a_id = self.tempProductModel.A_ID;
        self.uploadProductModel.productImageArr = self.tempProductModel.A_imageArr;
        self.uploadProductModel.productName = self.tempProductModel.A_NAME;
        
        NSRange cutIndex = [self.tempProductModel.A_STANDARD rangeOfString:@"/"];
        self.uploadProductModel.productStandard = [self.tempProductModel.A_STANDARD substringToIndex:cutIndex.location-1];
        //得到第一单位(袋、瓶、盒、桶)和第二单位(件、吨)
        self.uploadProductModel.productStandardTwo = [self.tempProductModel.A_STANDARD substringFromIndex:cutIndex.location+1];
        self.uploadProductModel.productStandardOne = [self.tempProductModel.A_STANDARD substringWithRange:NSMakeRange(cutIndex.location-1, 1)];
        
        self.uploadProductModel.productIngrendient = self.tempProductModel.A_INGREDIENT;
        self.uploadProductModel.factory_name = self.tempProductModel.A_FACTORY_NAME;
        self.uploadProductModel.productPrice = self.tempProductModel.A_PRICE_COST;
        self.uploadProductModel.productInventory = self.tempProductModel.A_INVENTORY;
        self.uploadProductModel.product_NH = self.tempProductModel.A_NH;
        self.uploadProductModel.productDosageId = self.tempProductModel.A_DOSAGE;
        self.uploadProductModel.productCodeId = self.tempProductModel.A_CODE;
        //刷新产品内容UI
        [self updateProductUI];
        
    }else {
        //如果是上传产品，赋一些默认值
        self.uploadProductModel.productStandardOne = @"袋";//默认规格1
        self.uploadProductModel.productStandardTwo = @"件";//默认规格2
        self.uploadProductModel.productCodeId = @"";
        self.uploadProductModel.productDosageId = @"";
    }
    
    Manager *manager = [Manager shareInstance];
    //请求分类
    [manager httpProductClassWithClassSuccess:^(id successResult) {
        self.classArr = successResult;
    } withClassFail:^(NSString *failResultStr) {
    }];
    
    //请求剂量
    [manager httpProductDosageWithDosageSuccess:^(id successResult) {
        self.dosageArr = successResult;
    } withDosageFail:^(NSString *failResultStr) {
    }];
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear: animated];
    [SVProgressHUD dismiss];
    
}

- (NSMutableArray *)productImageViewArr {
    if (_productImageViewArr == nil) {
        self.productImageViewArr = [NSMutableArray array];
    }
    return _productImageViewArr;
}

#pragma mark - 刷新一下UI -
//刷新产品内容UI(不含图片)
- (void)updateProductUI {
    
    [self.selectFormatButtonOne setTitle:self.uploadProductModel.productStandardOne forState:UIControlStateNormal];
    [self.selectFormatButtonTwo setTitle:self.uploadProductModel.productStandardTwo forState:UIControlStateNormal];
    self.nameTextField.text = self.uploadProductModel.productName;
    
    NSRange cutIndex = [self.uploadProductModel.productStandard rangeOfString:@"*"];
    self.standardTextFieldOne.text = [self.uploadProductModel.productStandard substringToIndex:cutIndex.location];
    self.standardTextFieldTwo.text = [self.uploadProductModel.productStandard substringFromIndex:cutIndex.location+1];
    
    self.ingrendientTextField.text = self.uploadProductModel.productIngrendient;
    self.factoryTextField.text = self.uploadProductModel.factory_name;
    self.priceTextField.text = self.uploadProductModel.productPrice;
    self.inventoryTextField.text = self.uploadProductModel.productInventory;
    [self.codeButton setTitle:self.tempProductModel.A_VALUE forState:UIControlStateNormal];
    [self.dosageButton setTitle:self.tempProductModel.A_DOSAGE_VALUE forState:UIControlStateNormal];
    self.HNTextView.text = self.uploadProductModel.product_NH;
}

//刷新产品图片UI
- (void)updateImageUI {
    for (int i = 0; i < self.uploadProductModel.productImageArr.count; i++) {
        UIImageView *tempImageView = self.productImageViewArr[i];

        if ([self.uploadProductModel.productImageArr[i] length] > 0) {
            [tempImageView setWebImageURLWithImageUrlStr:self.uploadProductModel.productImageArr[i] withErrorImage:nil withIsCenter:NO];
        }else {
            tempImageView.image = nil;
        }
    }
}

#pragma mark - scrollView Delegate -
- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView{
    NSInteger index = scrollView.contentOffset.x/scrollView.frame.size.width;
    self.pageLabel.text = [NSString stringWithFormat:@"%ld/6",index+1];
}

#pragma mark - 上传图片按钮 -
// 到上传图片界面
- (IBAction)uploadProductImageAction:(UIButton *)sender {

    [self performSegueWithIdentifier:@"uploadProductToSelectProductImageVC" sender:sender];
}

#pragma mark - 选择规格 按钮 -
- (IBAction)formatButtonOne:(UIButton *)sender {
    [self performSegueWithIdentifier:@"toSelectFormatVC" sender:@"0"];
}

- (IBAction)formatButtonTwo:(UIButton *)sender {
    [self performSegueWithIdentifier:@"toSelectFormatVC" sender:@"1"];

}


#pragma mark - 分类 剂量 按钮 -
- (IBAction)selectClassButtonAction:(UIButton *)sender {

    if (self.classArr!= nil && self.classArr.count > 0) {
        UIAlertController *alertC = [UIAlertController alertControllerWithTitle:nil message:@"请选择产品分类" preferredStyle:UIAlertControllerStyleActionSheet];
        for (int i = 0; i < self.classArr.count ; i++) {
            ProductClassModel *tempModel = self.classArr[i];
            UIAlertAction *action1 = [UIAlertAction actionWithTitle:tempModel.d_value style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
                //给模型赋值
                self.uploadProductModel.productCodeId = tempModel.d_code;
                //给button赋值
                NSLog(@"%@",tempModel.d_value);
                [sender setTitle:tempModel.d_value forState:UIControlStateNormal];
                [sender setTitleColor:k333333Color forState:UIControlStateNormal];
                
            }];
            [alertC addAction:action1];
        }
        [self presentViewController:alertC animated:YES completion:nil];

    }else {
        NSLog(@"暂时没有分类");
    }
}
- (IBAction)selectDosageButtonAction:(UIButton *)sender {
    if (self.dosageArr!= nil && self.dosageArr.count > 0) {
        UIAlertController *alertC = [UIAlertController alertControllerWithTitle:nil message:@"请选择剂形" preferredStyle:UIAlertControllerStyleActionSheet];
        for (int i = 0; i < self.dosageArr.count ; i++) {
            DosageModel *tempModel = self.dosageArr[i];
            UIAlertAction *action1 = [UIAlertAction actionWithTitle:tempModel.dosageValue style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
                //给模型赋值
                self.uploadProductModel.productDosageId = [NSString stringWithFormat:@"%@",tempModel.dosageID];
                //给button赋值
                NSLog(@"%@",tempModel.dosageValue);
                [sender setTitle:tempModel.dosageValue forState:UIControlStateNormal];
                [sender setTitleColor:k333333Color forState:UIControlStateNormal];

                
            }];
            [alertC addAction:action1];
        }
        [self presentViewController:alertC animated:YES completion:nil];
        
    }else {
        NSLog(@"暂时没有分类");
    }

}

#pragma mark - 上传 -
- (IBAction)submitUploadButtonAction:(UIButton *)sender {
    Manager *manager = [Manager shareInstance];
    AlertManager *alertM = [AlertManager shareIntance];
    NSString *errorStr = @"";
    
    if (self.HNTextView.text.length > 0) {
        self.uploadProductModel.product_NH = self.HNTextView.text;
    }else{
        errorStr = @"请填写产品的用法用量";
    }
    
    if (self.uploadProductModel.productDosageId.length <= 0) {
        errorStr = @"请选择剂型";
    }
    
    if (self.uploadProductModel.productCodeId.length <= 0) {
        errorStr = @"请选择分类";
    }
    
    if (self.inventoryTextField.text.length > 0) {
        self.uploadProductModel.productInventory = self.inventoryTextField.text;
    }else{
        errorStr = @"请输入库存";
    }
    
    if (self.priceTextField.text.length > 0) {
        self.uploadProductModel.productPrice = self.priceTextField.text;
    }else{
        errorStr = @"请输入报价";
    }
    
    if (self.factoryTextField.text.length > 0) {
        self.uploadProductModel.factory_name = self.factoryTextField.text;
    }else{
        errorStr = @"请输入厂家";
    }
    
    if (self.ingrendientTextField.text.length > 0) {
        self.uploadProductModel.productIngrendient = self.ingrendientTextField.text;
    }else{
        errorStr = @"请输入成分";
    }
    
    if ([self.uploadProductModel.productImageArr[2] length] == 0) {
        errorStr = @"请上传PD证";
    }
    if ([self.uploadProductModel.productImageArr[1] length] == 0) {
        errorStr = @"请上传产品反面";
    }
    if ([self.uploadProductModel.productImageArr[0] length] == 0) {
        errorStr = @"请上传产品正面";
    }
    
    if (self.standardTextFieldOne.text.length > 0 && self.standardTextFieldTwo.text.length > 0) {
        self.uploadProductModel.productStandard = [NSString stringWithFormat:@"%@*%@", self.standardTextFieldOne.text ,self.standardTextFieldTwo.text];
    }else{
        errorStr = @"请输入规格";
    }
    
    if (self.nameTextField.text.length > 0) {
        self.uploadProductModel.productName = self.nameTextField.text;
    }else {
        errorStr = @"请输入产品名";
    }
    
    if ([errorStr isEqualToString:@""]) {
        if (self.tempType == 1) {
            //上传产品
            [manager addProductWithUploadProductModel:self.uploadProductModel withMemberInfo:manager.memberInfoModel withAddProductSuccess:^(id successResult) {
                
                self.uploadSuccessView.hidden = NO;
                
            } withAddProductFail:^(NSString *failResultStr) {
                [alertM showAlertViewWithTitle:@"上传失败" withMessage:failResultStr actionTitleArr:@[@"确定"] withViewController:self withReturnCodeBlock:nil];
                
            }];            
        }
        
        if (self.tempType == 2) {
            //编辑产品
            [manager editProductWithUploadProductModel:self.uploadProductModel withMemberInfo:manager.memberInfoModel withEditProductSuccess:^(id successResult) {
                self.uploadSuccessView.hidden = NO;
                //发送通知，到审核列表中，刷新审核列表页面
                [[NSNotificationCenter defaultCenter] postNotificationName:@"refreshReviewList" object:self userInfo:nil];
                
            } withEditProductFail:^(NSString *failResultStr) {
                [alertM showAlertViewWithTitle:@"修改产品失败" withMessage:failResultStr actionTitleArr:@[@"确定"] withViewController:self withReturnCodeBlock:nil];

            }];
        }
        
    }else {
        NSLog(@"%@",errorStr);
        [alertM showAlertViewWithTitle:@"暂不能上传产品" withMessage:errorStr actionTitleArr:@[@"确定"] withViewController:self withReturnCodeBlock:nil];

    }
}


- (IBAction)uploadSuccessButtonAction:(UIButton *)sender {
    if (self.tempType == 1) {
        [self.navigationController popViewControllerAnimated:YES];

    }
    if (self.tempType == 2) {
        
        //返回到审核中心列表
        [self.navigationController popToViewController:[self.navigationController.viewControllers objectAtIndex:1] animated:YES];
        
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
    Manager *manager = [Manager shareInstance];
    if ([segue.identifier isEqualToString:@"toSelectFormatVC"]) {
        SelectFormatViewController *selectFormatVC = [segue destinationViewController];
        selectFormatVC.backImage = [manager screenShot];
        selectFormatVC.formatType = [sender integerValue];
        selectFormatVC.uploadModel = self.uploadProductModel;
        
        selectFormatVC.refreshFormatUI = ^{
            [self.selectFormatButtonOne setTitle:self.uploadProductModel.productStandardOne forState:UIControlStateNormal];
            [self.selectFormatButtonTwo setTitle:self.uploadProductModel.productStandardTwo forState:UIControlStateNormal];
        };
    }
    
    //上传图片
    if ([segue.identifier isEqualToString:@"uploadProductToSelectProductImageVC"]) {
        SelectProductImageViewController *selectImgVC = [segue destinationViewController];
        selectImgVC.tempUploadProductModel = self.uploadProductModel;
        
    }
    
}


@end
