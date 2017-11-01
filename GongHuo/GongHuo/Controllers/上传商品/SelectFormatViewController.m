//
//  SelectFormatViewController.m
//  GongHuo
//
//  Created by TongLi on 2017/9/13.
//  Copyright © 2017年 TongLi. All rights reserved.
//

#import "SelectFormatViewController.h"

@interface SelectFormatViewController ()
@property (weak, nonatomic) IBOutlet UIImageView *backImageView;
//第一个View 袋、瓶、盒、桶
@property (weak, nonatomic) IBOutlet UIView *selectFormatViewOne;
@property (weak, nonatomic) IBOutlet UIImageView *selectDaiImageView;
@property (weak, nonatomic) IBOutlet UIImageView *selectPingImageView;
@property (weak, nonatomic) IBOutlet UIImageView *selectHeImageView;
@property (weak, nonatomic) IBOutlet UIImageView *selectTongImageView;


//第二个View 件、吨
@property (weak, nonatomic) IBOutlet UIView *selectFormatViewTwo;
@property (weak, nonatomic) IBOutlet UIImageView *selectJianImageView;
@property (weak, nonatomic) IBOutlet UIImageView *selectDunImageView;

//暂时选择的规格
@property (nonatomic,strong)NSString *selectStandardOne;
@property (nonatomic,strong)NSString *selectStandardTwo;

@end

@implementation SelectFormatViewController
- (IBAction)backButtonOneAction:(UIButton *)sender {
    
    [self dismissViewControllerAnimated:YES completion:nil];
}
- (IBAction)backButtonTwoAction:(UIButton *)sender {

    [self dismissViewControllerAnimated:YES completion:nil];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.backImageView.image = self.backImage;
    
    //给要选择的规格附上初值
    self.selectStandardOne = self.uploadModel.productStandardOne;
    self.selectStandardTwo = self.uploadModel.productStandardTwo;
    
    if (self.formatType == 0) {
        self.selectFormatViewOne.hidden = NO;
        self.selectFormatViewTwo.hidden = YES;
        [self updateOneSelectView];
        
    }else {
        self.selectFormatViewOne.hidden = YES;
        self.selectFormatViewTwo.hidden = NO;
        [self updateTwoSelectView];
        
    }
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    [SVProgressHUD dismiss];
    
}

#pragma mark - 第一个type的选择 -
- (IBAction)daiTapAction:(UITapGestureRecognizer *)sender {
    self.selectStandardOne = @"袋";
    [self updateOneSelectView];
}

- (IBAction)pingTapAction:(UITapGestureRecognizer *)sender {
    
    self.selectStandardOne = @"瓶";
    [self updateOneSelectView];
}

- (IBAction)heTapAction:(UITapGestureRecognizer *)sender {
    self.selectStandardOne = @"盒";
    [self updateOneSelectView];
}

- (IBAction)tongTapAction:(UITapGestureRecognizer *)sender {
    self.selectStandardOne = @"桶";
    [self updateOneSelectView];
}

- (IBAction)oneEnterAction:(UIButton *)sender {
    //给模型赋值
    self.uploadModel.productStandardOne = self.selectStandardOne;
    //刷新上个页面的规格UI
    self.refreshFormatUI();
    [self dismissViewControllerAnimated:YES completion:nil];
}

#pragma mark - 第二个type的选择 -
- (IBAction)jianTapAction:(UITapGestureRecognizer *)sender {
    self.selectStandardTwo = @"件";
    [self updateTwoSelectView];
}
- (IBAction)dunTapAction:(UITapGestureRecognizer *)sender {
    self.selectStandardTwo = @"吨";
    [self updateTwoSelectView];
}

- (IBAction)twoEnterAction:(UIButton *)sender {
    //给模型赋值
    self.uploadModel.productStandardTwo = self.selectStandardTwo;

    //刷新上个页面的规格UI
    self.refreshFormatUI();
    [self dismissViewControllerAnimated:YES completion:nil];
}

#pragma mark - 刷新选择按钮UI -
- (void)updateOneSelectView {
    self.selectDaiImageView.image = [UIImage imageNamed:@"btn_normal.png"];
    self.selectPingImageView.image = [UIImage imageNamed:@"btn_normal.png"];
    self.selectHeImageView.image = [UIImage imageNamed:@"btn_normal.png"];
    self.selectTongImageView.image = [UIImage imageNamed:@"btn_normal.png"];

    if ([self.selectStandardOne isEqualToString:@"袋"]) {
        self.selectDaiImageView.image = [UIImage imageNamed:@"btn_select.png"];
    }
    if ([self.selectStandardOne isEqualToString:@"瓶"]) {
        self.selectPingImageView.image = [UIImage imageNamed:@"btn_select.png"];
    }
    if ([self.selectStandardOne isEqualToString:@"盒"]) {
        self.selectHeImageView.image = [UIImage imageNamed:@"btn_select.png"];
    }
    if ([self.selectStandardOne isEqualToString:@"桶"]) {
        self.selectTongImageView.image = [UIImage imageNamed:@"btn_select.png"];
    }
    
}

- (void)updateTwoSelectView {
    self.selectJianImageView.image = [UIImage imageNamed:@"btn_normal.png"];
    self.selectDunImageView.image = [UIImage imageNamed:@"btn_normal.png"];

    if ([self.selectStandardTwo isEqualToString:@"件"]) {
        self.selectJianImageView.image = [UIImage imageNamed:@"btn_select.png"];
    }
    if ([self.selectStandardTwo isEqualToString:@"吨"]) {
        self.selectDunImageView.image = [UIImage imageNamed:@"btn_select.png"];
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
