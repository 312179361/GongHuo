//
//  SelectFormatViewController.h
//  GongHuo
//
//  Created by TongLi on 2017/9/13.
//  Copyright © 2017年 TongLi. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Manager.h"

typedef void(^RefreshFormatUI)();

@interface SelectFormatViewController : UIViewController
@property(nonatomic,strong)UIImage *backImage;
//0-第一个type 1-第二个type
@property(nonatomic,assign)NSInteger formatType;
//上传模型
@property(nonatomic,strong)UploadProductModel *uploadModel;

//刷新规格UI
@property(nonatomic,copy)RefreshFormatUI refreshFormatUI;

@end
