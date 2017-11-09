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
@interface SendDetailViewController ()<UIImagePickerControllerDelegate,UINavigationControllerDelegate>
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

@property(nonatomic,strong)UIImagePickerController *picker;
@end

@implementation SendDetailViewController

- (IBAction)leftBarButtonAction:(UIBarButtonItem *)sender {
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    //初始化图片选择器
    self.picker = [[UIImagePickerController alloc]init];
    self.picker.delegate = self;
    
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
    [self selectCameraOrPhoto];
    
}

#pragma mark - 选择相机或者图库 -
- (void)selectCameraOrPhoto {
    //弹出相机或者图库的选择器
    UIAlertController *alertC = [UIAlertController alertControllerWithTitle:nil message:nil preferredStyle:UIAlertControllerStyleActionSheet];
    UIAlertAction *action1 = [UIAlertAction actionWithTitle:@"拍照" style:(UIAlertActionStyleDefault) handler:^(UIAlertAction * _Nonnull action) {
        [self takePhotoForCamera];
    }];
    UIAlertAction *action2 = [UIAlertAction actionWithTitle:@"相册选取" style:(UIAlertActionStyleDefault) handler:^(UIAlertAction * _Nonnull action) {
        [self takePhotoForPhotoAlbum];
    }];
    UIAlertAction *action3 = [UIAlertAction actionWithTitle:@"取消" style:(UIAlertActionStyleCancel) handler:nil];
    [alertC addAction:action1];
    [alertC addAction:action2];
    [alertC addAction:action3];
    [self presentViewController:alertC animated:YES completion:nil];
}

//通过照相机选取图片
- (void)takePhotoForCamera {
    if ([UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeCamera]) {
        
        self.picker.sourceType = UIImagePickerControllerSourceTypeCamera;
        self.picker.cameraCaptureMode = UIImagePickerControllerCameraCaptureModePhoto;
        self.picker.cameraDevice = UIImagePickerControllerCameraDeviceRear;
        //        picker.cameraDevice = UIImagePickerControllerCameraDeviceFront;
        self.picker.allowsEditing = YES;
        
    }else{
        NSLog(@"摄像头无法打开");
    }
    [self presentViewController:self.picker animated:YES completion:nil];
    
}

//通过相册选取图片
- (void)takePhotoForPhotoAlbum {
    self.picker.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
    self.picker.allowsEditing = YES;
    [self presentViewController:self.picker animated:YES completion:nil];
}

#pragma mark - 拍照的代理方法 -
//当得到照片
- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info{
    
    Manager *manager = [Manager shareInstance];
    
    NSString *mediaType = [info objectForKey:UIImagePickerControllerMediaType];
    if ([mediaType isEqualToString:(NSString *)kUTTypeImage]) {
        UIImage *tempImage = nil;
        
        if ([picker allowsEditing]) {
            tempImage = [info objectForKey:UIImagePickerControllerEditedImage];
        }else{
            tempImage = [info objectForKey:UIImagePickerControllerOriginalImage];
        }
        
        
        //给图片进行压缩
        UIImage *submitImg = [manager compressOriginalImage:tempImage toMaxDataSizeKBytes:100];
        //图片上传
        [self httpUploadImageWithImg:submitImg withUpSuccess:^(id successResult) {
            //赋值
            self.sendCerImageView.contentMode = UIViewContentModeScaleToFill;
            self.sendCerImageView.image = tempImage;
            self.sendCerLabel.hidden = YES;
        }];
        
    }
    //隐藏UIImagePickerController
    [picker dismissViewControllerAnimated:YES completion:nil];
}

//当用户取消时
- (void)imagePickerControllerDidCancel:(UIImagePickerController *)picker{
    //隐藏UIImagePickerController
    [picker dismissViewControllerAnimated:YES completion:nil];
}



#pragma mark - 上传照片 -
//上传图片
- (void)httpUploadImageWithImg:(UIImage *)uploadImg withUpSuccess:(SuccessResult)upSuccess {
    
    Manager *manager = [Manager shareInstance];
    AlertManager *alertM = [AlertManager shareIntance];
    
    [manager uploadImageWithUploadImage:uploadImg withUploadSuccess:^(id successResult) {
        //上传成功
        self.imgUrl = successResult;
        upSuccess(@"上传成功");
    } withUploadFail:^(NSString *failResultStr) {
        
        [alertM showAlertViewWithTitle:@"上传发货单失败" withMessage:failResultStr actionTitleArr:@[@"确定"] withViewController:self withReturnCodeBlock:nil];
    }];
}


#pragma mark - 提交发货 -
//提交发货
- (IBAction)sendButtonAction:(UIButton *)sender {
    
    Manager *manager = [Manager shareInstance];
    AlertManager *alertM = [AlertManager shareIntance];
    //假图片
//    self.imgUrl = @"20179/9/E5B93C5CFCA94E30B6C501BC4DCA7F4B.jpg";
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
