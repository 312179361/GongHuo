//
//  SelectProductImageViewController.m
//  GongHuo
//
//  Created by TongLi on 2017/9/12.
//  Copyright © 2017年 TongLi. All rights reserved.
//

#import "SelectProductImageViewController.h"
#import "Manager.h"
#import "UIImageView+ImageViewCategory.h"
#import "UIButton+UIButtonCategory.h"
@interface SelectProductImageViewController ()<UIScrollViewDelegate,UIImagePickerControllerDelegate,UINavigationControllerDelegate>

//大图imageViews数组，和小button数组
@property(nonatomic,strong)NSMutableArray *bigImageViewsArr;
@property(nonatomic,strong)NSArray *littleButtonArr;

@property (weak, nonatomic) IBOutlet UIScrollView *imageViewScrollView;
//产品图片contentView
@property (weak, nonatomic) IBOutlet UIView *imageViewContentView;

@property (weak, nonatomic) IBOutlet UILabel *pageLabel;
//删除图片按钮
@property (weak, nonatomic) IBOutlet UIButton *deleteImageBtn;

@property (weak, nonatomic) IBOutlet UIButton *littleImageButtonOne;
@property (weak, nonatomic) IBOutlet UIButton *littleImageButtonTwo;
@property (weak, nonatomic) IBOutlet UIButton *littleImageButtonThree;
@property (weak, nonatomic) IBOutlet UIButton *littleImageButtonFour;
@property (weak, nonatomic) IBOutlet UIButton *littleImageButtonFive;
@property (weak, nonatomic) IBOutlet UIButton *littleImageButtonSix;

@property (nonatomic,assign)NSInteger imgIndex;

@property (nonatomic,strong)NSMutableArray *changeImageArr;
@property (nonatomic,strong)NSMutableArray *imageUrlArrOld;
@property (nonatomic,strong)NSMutableArray *imagesArrNew;


@end

@implementation SelectProductImageViewController
//相机
UIImagePickerController *picker;

- (IBAction)leftBarButtonAction:(UIBarButtonItem *)sender {
    
    [self.navigationController popViewControllerAnimated:YES];
}


- (IBAction)rightBarButtonAction:(UIBarButtonItem *)sender {
    AlertManager *alertM = [AlertManager shareIntance];
    
    //将图片链接数组，赋值给模型
    NSString *errorStr = nil;
    if (![self isHiddenDeleteImageBtnWithIndex:2]) {
        errorStr = @"请上传PD证";
    }
    if (![self isHiddenDeleteImageBtnWithIndex:1]) {
        errorStr = @"请上传反面";
    }
    if (![self isHiddenDeleteImageBtnWithIndex:0]) {
        errorStr = @"请上传正面";
    }
    
    
    if (errorStr == nil) {
        //记录一下一共有多少个图片需要改变了
        __block NSInteger maxChange = 0;
        for (NSString *tempChange in self.changeImageArr) {
            if ([tempChange isEqualToString:@"YES"]) {
                maxChange++ ;
            }
        }
        if (maxChange > 0) {
            //保存
            //先查看修改标记，如果有标记，才做操作，
            for (int i = 0; i < self.changeImageArr.count; i++) {
                //如果有标记
                if ([self.changeImageArr[i] isEqualToString:@"YES"]) {
                    /*  分四种情况
                     1、有旧链接 有新图片 -- 删除旧链接，上传图片
                     2、有旧链接 无新图片 -- 删除旧链接
                     3、无旧链接 有新图片 -- 上传新图片
                     4、无旧链接 无新图片 -- 无操作
                     */
                    if ([self.imageUrlArrOld[i] length] > 0) {
                        if ([self.imagesArrNew[i] isKindOfClass:[UIImage class]]) {
                            //有旧链接 有新图片
                            [self httpDeleteImageWithImgUrl:self.imageUrlArrOld[i] withImageInt:i withDeleteSuccess:^(id successResult) {
                                
                            }];
                            [self httpUploadImageWithUploadImg:self.imagesArrNew[i] withImageInt:i withUpSuccess:^(id successResult) {
                                maxChange--;
                                NSLog(@"-------还有%ld图片",maxChange);
                                
                                if (maxChange == 0) {
                                    [self.navigationController popViewControllerAnimated:YES];
                                }
                                
                                
                            }];
                            
                        }else {
                            //有旧链接 无新图片
                            [self httpDeleteImageWithImgUrl:self.imageUrlArrOld[i] withImageInt:i withDeleteSuccess:^(id successResult) {
                                maxChange--;
                                NSLog(@"-------还有%ld图片",maxChange);
                                if (maxChange == 0) {
                                    [self.navigationController popViewControllerAnimated:YES];
                                }
                            }];
                        }
                        
                        
                    }else {
                        
                        if ([self.imagesArrNew[i] isKindOfClass:[UIImage class]]) {
                            //无旧链接 有新图片
                            [self httpUploadImageWithUploadImg:self.imagesArrNew[i] withImageInt:i withUpSuccess:^(id successResult) {
                                maxChange--;
                                NSLog(@"-------还有%ld图片",maxChange);
                                if (maxChange == 0) {
                                    [self.navigationController popViewControllerAnimated:YES];
                                }
                            }];
                        }
                        //无旧链接 无新图片，没有任何操作
                    }
                }
            }
        }else {
            [self.navigationController popViewControllerAnimated:YES];
        }
        
      
    }else {
        [alertM showAlertViewWithTitle:@"提交失败" withMessage:errorStr actionTitleArr:@[@"确定"] withViewController:self withReturnCodeBlock:nil];
    }
    
    
    
    
    
    
    
    
    
  
    
    
    
    
    /*
    //将图片链接数组，赋值给模型
    NSString *errorStr = nil;
    if (self.imageUrlArr.count == 6) {
        if ([self.imageUrlArr[2] isEqualToString:@""]) {
            errorStr = @"请上传PD证";
        }
        if ([self.imageUrlArr[1] isEqualToString:@""]) {
            errorStr = @"请上传反面";
        }
        if ([self.imageUrlArr[0] isEqualToString:@""]) {
            errorStr = @"请上传正面";
        }
        
        if (errorStr == nil) {
            //必要的都上传了 给模型赋值，然后返回
            self.tempUploadProductModel.productImageArr = self.imageUrlArr;
            [self.navigationController popViewControllerAnimated:YES];
            
        }else {
            [alertM showAlertViewWithTitle:@"提交失败" withMessage:errorStr actionTitleArr:@[@"确定"] withViewController:self withReturnCodeBlock:nil];

        }
        
    }else {
        [alertM showAlertViewWithTitle:@"提交失败" withMessage:@"您还没有上传任何图片" actionTitleArr:@[@"确定"] withViewController:self withReturnCodeBlock:nil];
        
    }
    
    
  */
    
}


- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    //初始化图片选择器
    picker = [[UIImagePickerController alloc]init];
    picker.delegate = self;
    
    //初始化旧的图片链接数组(原有的图片链接) 和 新的图片数组(要上传的图片) 和 创建一下标记图片是否改变(包含增加，删除，替换)
    self.imageUrlArrOld = [self.tempUploadProductModel.productImageArr mutableCopy];
    //新图片数组的初始化
    self.imagesArrNew = [NSMutableArray array];
    //改变图片标记的初始化
    self.changeImageArr = [NSMutableArray array];
    
    //创建大图imageView
    self.bigImageViewsArr = [NSMutableArray array];
    for (int i = 0; i < 6; i++) {
        //新图片数组的初始化
        [self.imagesArrNew addObject:@""];
        //改变图片标记的初始化
        [self.changeImageArr addObject:@"NO"];
        
        UIImageView *tempImageView = [[UIImageView alloc] initWithFrame:CGRectMake(i*kScreenW, 0, kScreenW, kScreenW/3*2)];
        [self.imageViewContentView addSubview:tempImageView];
        [self.bigImageViewsArr addObject:tempImageView];
        
    }
    //button 数组 初始化
    self.littleButtonArr = @[self.littleImageButtonOne,
                             self.littleImageButtonTwo,
                             self.littleImageButtonThree,
                             self.littleImageButtonFour,
                             self.littleImageButtonFive,
                             self.littleImageButtonSix];
    
    
    //给图片赋值,即将老链接赋值
    for (int i = 0; i < self.imageUrlArrOld.count; i++) {
        
        if ([self.imageUrlArrOld[i] length] > 0) {
            
            //给图片链接加到imageUrlArr中 方便管理
            UIImageView *tempBigImageView = self.bigImageViewsArr[i];
            [tempBigImageView setWebImageURLWithImageUrlStr:self.imageUrlArrOld[i] withErrorImage:nil withIsCenter:NO];
            
            UIButton *tempLittleButton = self.littleButtonArr[i];
            [tempLittleButton setWebImageURLWithImageUrlStr:self.imageUrlArrOld[i] withErrorImage:[UIImage imageNamed:@"btn_upload_2"]];
        }
    }
    
    //执行以下scrollView 的代理方法,更新一下页码和删除按钮
    [self scrollViewDidEndDecelerating:self.imageViewScrollView];
    
}


- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    [SVProgressHUD dismiss];
}

#pragma mark - 删除图片按钮 -
- (IBAction)deleteImageButtonAction:(UIButton *)sender {
    NSInteger index = self.imageViewScrollView.contentOffset.x/self.imageViewScrollView.frame.size.width;
    NSLog(@"%ld",index);
    //本地删除图片
    [self deleteImageWithImageInt:index];
  
    
}




#pragma mark - scrollView Delegate -
- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView{
    NSInteger index = scrollView.contentOffset.x/scrollView.frame.size.width;
    self.pageLabel.text = [NSString stringWithFormat:@"%ld/6",index+1];
    
    //判断是否有删除按钮
    [self isHiddenDeleteImageBtnWithIndex:index];
    
    
}

#pragma mark - 是否显示删除按钮 -
- (BOOL)isHiddenDeleteImageBtnWithIndex:(NSInteger)tempIndex {

    if ([self.changeImageArr[tempIndex] isEqualToString:@"NO"]) {
        if ([self.imageUrlArrOld[tempIndex] length] > 0) {
            self.deleteImageBtn.hidden = NO;
            return YES;
        }else{
            self.deleteImageBtn.hidden = YES;
            return NO;

        }
    }else {
        if ([self.imagesArrNew[tempIndex] isKindOfClass:[UIImage class]]) {
            self.deleteImageBtn.hidden = NO;
            return YES;
        }else{
            self.deleteImageBtn.hidden = YES;
            return NO;
        }
    }
}

#pragma mark - 下面的五个按钮点击 -
- (IBAction)uploadImgButtonOneAction:(UIButton *)sender {
    self.imgIndex = 0;
    
    [self selectCameraOrPhoto];
}
- (IBAction)uploadImgButtonTwoAction:(UIButton *)sender {
    self.imgIndex = 1;

    [self selectCameraOrPhoto];
}
- (IBAction)uploadImgButtonThreeAction:(UIButton *)sender {
    self.imgIndex = 2;

    [self selectCameraOrPhoto];
    
}
- (IBAction)uploadImgButtonFourAction:(UIButton *)sender {
    self.imgIndex = 3;

    [self selectCameraOrPhoto];
}
- (IBAction)uploadImgButtonFiveAction:(UIButton *)sender {
    self.imgIndex = 4;

    [self selectCameraOrPhoto];
}
- (IBAction)uploadImgButtonSixAction:(UIButton *)sender {
    self.imgIndex = 5;
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
        
        picker.sourceType = UIImagePickerControllerSourceTypeCamera;
        picker.cameraCaptureMode = UIImagePickerControllerCameraCaptureModePhoto;
        picker.cameraDevice = UIImagePickerControllerCameraDeviceRear;
        //        picker.cameraDevice = UIImagePickerControllerCameraDeviceFront;
        picker.allowsEditing = YES;
        
    }else{
        NSLog(@"摄像头无法打开");
    }
    [self presentViewController:picker animated:YES completion:nil];
    
}

//通过相册选取图片
- (void)takePhotoForPhotoAlbum {
    picker.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
    picker.allowsEditing = YES;
    [self presentViewController:picker animated:YES completion:nil];
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
        
        //本地添加图片操作和刷新UI
        [self addImageWithTempImage:submitImg withImageInt:self.imgIndex];
       
        //图片进行上传
//        [self httpUploadImageWithUploadImg:submitImg withImageInt:self.imgIndex];

    }
    //隐藏UIImagePickerController
    [picker dismissViewControllerAnimated:YES completion:nil];
}

//当用户取消时
- (void)imagePickerControllerDidCancel:(UIImagePickerController *)picker{
    //隐藏UIImagePickerController
    [picker dismissViewControllerAnimated:YES completion:nil];
}


#pragma mark - 本地操作 添加图片 和 删除图片 -
//本地添加
- (void)addImageWithTempImage:(UIImage *)tempImage withImageInt:(NSInteger )imageInt {
    
    //标记这张图片被修改了
    self.changeImageArr[imageInt] = @"YES";
    //在新图片数组中加入图片
    self.imagesArrNew[imageInt] = tempImage;
    
    //刷新UI
    UIImageView *tempBigImageView = self.bigImageViewsArr[imageInt];
    tempBigImageView.image = tempImage;
    
    UIButton *tempLittleButton = self.littleButtonArr[imageInt];
    [tempLittleButton setImage:tempImage forState:UIControlStateNormal];

    [self isHiddenDeleteImageBtnWithIndex:imageInt];
}

//本地删除
- (void)deleteImageWithImageInt:(NSInteger )imageInt {
    
    //标记这张图片被修改了,如果这个原理有图片，现在删除了，说明没有改变
    if ([self.imageUrlArrOld[imageInt] length] > 0) {
        self.changeImageArr[imageInt] = @"YES";
    }else{
        self.changeImageArr[imageInt] = @"NO";
    }

    //在新图片数组中删除图片
    self.imagesArrNew[imageInt] = @"";
    
    //刷新UI
    UIImageView *tempBigImageView = self.bigImageViewsArr[imageInt];
    tempBigImageView.image = nil;
    
    UIButton *tempLittleButton = self.littleButtonArr[imageInt];
    [tempLittleButton setImage:[UIImage imageNamed:@"btn_upload_2"] forState:UIControlStateNormal];

    [self isHiddenDeleteImageBtnWithIndex:imageInt];

}



#pragma mark - 上传图片 和 删除图片 网络请求  -

//上传图片
- (void)httpUploadImageWithUploadImg:(UIImage *)uploadImg withImageInt:(NSInteger)tempImageInt withUpSuccess:(SuccessResult)upSuccess {
    
    Manager *manager = [Manager shareInstance];
    AlertManager *alertM = [AlertManager shareIntance];
    
    [manager uploadImageWithUploadImage:uploadImg withUploadSuccess:^(id successResult) {
        //上传成功 给模型赋值图片链接
        self.tempUploadProductModel.productImageArr[tempImageInt] = successResult;
        
      
        upSuccess(@"上传成功");
        
        
        
//        [self.imageUrlArr replaceObjectAtIndex:tempImageInt withObject:successResult];
        
/*
        UIImageView *tempImageView = [[self.imageViewAndButtonDic objectForKey:@"imageViews"] objectAtIndex:tempImageInt];
        tempImageView.image = uploadImg;

        
 
        //给imageView和button赋值
        switch (self.imgIndex) {
            case 0:
                [self.littleImageButtonOne setImage:uploadImg forState:UIControlStateNormal];
                break;
            case 1:
//                self.bigImageViewTwo.image = uploadImg;
                [self.littleImageButtonTwo setImage:uploadImg forState:UIControlStateNormal];
                break;
            case 2:
//                self.bigImageViewThree.image = uploadImg;
                [self.littleImageButtonThree setImage:uploadImg forState:UIControlStateNormal];
                break;
            case 3:
//                self.bigImageViewFour.image = uploadImg;
                [self.littleImageButtonFour setImage:uploadImg forState:UIControlStateNormal];
                break;
            case 4:
//                self.bigImageViewFive.image = uploadImg;
                [self.littleImageButtonFive setImage:uploadImg forState:UIControlStateNormal];
                break;
            case 5:
                [self.littleImageButtonSix setImage:uploadImg forState:UIControlStateNormal];
                break;
            default:
                break;
        }
        
        */
        
    } withUploadFail:^(NSString *failResultStr) {
        NSString *errorStr = nil;
        
        switch (tempImageInt) {
            case 0:
                errorStr = @"上传正面失败，请稍后再试或者联系客服";
                break;
            case 1:
                errorStr = @"上传反面失败，请稍后再试或者联系客服";
                break;
            case 2:
                errorStr = @"上传PD证失败，请稍后再试或者联系客服";
                break;
            case 3:
                errorStr = @"上传其他1失败，请稍后再试或者联系客服";
                break;
            case 4:
                errorStr = @"上传其他2失败，请稍后再试或者联系客服";
                break;
            case 5:
                errorStr = @"上传其他3失败，请稍后再试或者联系客服";
                break;
            default:
                break;
        }
        
        [alertM showAlertViewWithTitle:errorStr withMessage:failResultStr actionTitleArr:@[@"确定"] withViewController:self withReturnCodeBlock:nil];
    }];
}


//删除图片
- (void)httpDeleteImageWithImgUrl:(NSString *)imgUrl withImageInt:(NSInteger)tempImageInt withDeleteSuccess:(SuccessResult)deleteSuccess {
    Manager *manager = [Manager shareInstance];
    AlertManager *alertM = [AlertManager shareIntance];
    //直接删除模型中的连接
    self.tempUploadProductModel.productImageArr[tempImageInt] = @"";
    
    [manager deleteImageWithDeleteImageUrl:imgUrl withToken:manager.memberInfoModel.token withDeleteSuccess:^(id successResult) {
        NSLog(@"删除成功");
        
        deleteSuccess(@"删除成功");

        
    } withDeleteFail:^(NSString *failResultStr) {
        NSLog(@"删除失败");
        
        
    }];
    
    
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
