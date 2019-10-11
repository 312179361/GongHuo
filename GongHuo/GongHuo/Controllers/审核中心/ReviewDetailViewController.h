//
//  ReviewDetailViewController.h
//  GongHuo
//
//  Created by TongLi on 2017/9/15.
//  Copyright © 2017年 TongLi. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Manager.h"
@interface ReviewDetailViewController : UIViewController
@property(nonatomic,assign)NSInteger fromType;//来源 0-从审核中心 1-从供货列表

@property(nonatomic,strong)CheckListModel *tempCheckModel;

@property(nonatomic,strong)SupplyListModel *tempSupplyModel;
@property(nonatomic,strong)NSString *currentType;//从供货列表中的类型，0上架中、1、修改记录、2已下架

@end
