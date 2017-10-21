//
//  UploadProductViewController.h
//  GongHuo
//
//  Created by TongLi on 2017/7/3.
//  Copyright © 2017年 TongLi. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CheckListModel.h"
@interface UploadProductViewController : UIViewController
@property (nonatomic,assign)NSInteger tempType;
@property (nonatomic,strong)CheckListModel *tempProductModel;

@end
