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

@end

@implementation SelectFormatViewController
- (IBAction)backButtonOneAction:(UIButton *)sender {
    //刷新上个页面的规格UI
    self.refreshFormatUI();
    [self dismissViewControllerAnimated:YES completion:nil];
}
- (IBAction)backButtonTwoAction:(UIButton *)sender {
    //刷新上个页面的规格UI
    self.refreshFormatUI();
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.backImageView.image = self.backImage;
    
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

#pragma mark - 第一个type的选择 -
- (IBAction)daiTapAction:(UITapGestureRecognizer *)sender {
    self.uploadModel.productStandardOne = @"袋";
    [self updateOneSelectView];
}

- (IBAction)pingTapAction:(UITapGestureRecognizer *)sender {
    self.uploadModel.productStandardOne = @"瓶";
    [self updateOneSelectView];
}

- (IBAction)heTapAction:(UITapGestureRecognizer *)sender {
    self.uploadModel.productStandardOne = @"盒";
    [self updateOneSelectView];
}

- (IBAction)tongTapAction:(UITapGestureRecognizer *)sender {
    self.uploadModel.productStandardOne = @"桶";
    [self updateOneSelectView];
}

- (IBAction)oneEnterAction:(UIButton *)sender {
    //刷新上个页面的规格UI
    self.refreshFormatUI();
    [self dismissViewControllerAnimated:YES completion:nil];
}

#pragma mark - 第二个type的选择 -
- (IBAction)jianTapAction:(UITapGestureRecognizer *)sender {
    self.uploadModel.productStandardTwo = @"件";
    [self updateTwoSelectView];
}
- (IBAction)dunTapAction:(UITapGestureRecognizer *)sender {
    self.uploadModel.productStandardTwo = @"吨";
    [self updateTwoSelectView];
}

- (IBAction)twoEnterAction:(UIButton *)sender {
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

    if ([self.uploadModel.productStandardOne isEqualToString:@"袋"]) {
        self.selectDaiImageView.image = [UIImage imageNamed:@"btn_select.png"];
    }
    if ([self.uploadModel.productStandardOne isEqualToString:@"瓶"]) {
        self.selectPingImageView.image = [UIImage imageNamed:@"btn_select.png"];
    }
    if ([self.uploadModel.productStandardOne isEqualToString:@"盒"]) {
        self.selectHeImageView.image = [UIImage imageNamed:@"btn_select.png"];
    }
    if ([self.uploadModel.productStandardOne isEqualToString:@"桶"]) {
        self.selectTongImageView.image = [UIImage imageNamed:@"btn_select.png"];
    }
    
}

- (void)updateTwoSelectView {
    self.selectJianImageView.image = [UIImage imageNamed:@"btn_normal.png"];
    self.selectDunImageView.image = [UIImage imageNamed:@"btn_normal.png"];

    if ([self.uploadModel.productStandardTwo isEqualToString:@"件"]) {
        self.selectJianImageView.image = [UIImage imageNamed:@"btn_select.png"];
    }
    if ([self.uploadModel.productStandardTwo isEqualToString:@"吨"]) {
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
