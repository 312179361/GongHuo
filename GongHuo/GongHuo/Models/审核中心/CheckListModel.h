//
//  CheckListModel.h
//  GongHuo
//
//  Created by TongLi on 2017/9/15.
//  Copyright © 2017年 TongLi. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "SupplyListModel.h"
@interface CheckListModel : NSObject

@property(nonatomic,strong)NSString *A_ID;
@property(nonatomic,strong)NSString *A_SP_ID;
@property(nonatomic,strong)NSString *A_U_ID;
@property(nonatomic,strong)NSString *A_USER_ID_CREATE;
@property(nonatomic,strong)NSString *A_USER_ID_UPDATE;
@property(nonatomic,strong)NSString *A_TIME_CREATE;
@property(nonatomic,strong)NSString *A_TIME_UPDATE;
@property(nonatomic,strong)NSString *A_STATUS_DO;
@property(nonatomic,strong)NSString *A_MOBILE;
@property(nonatomic,strong)NSString *A_REG;

@property(nonatomic,strong)NSString *A_STATUS_CHECK;//审核结果

@property(nonatomic,strong)NSMutableArray *A_imageArr;//图片

@property(nonatomic,strong)NSString *A_NAME;
@property(nonatomic,strong)NSString *A_STANDARD;//规格
@property(nonatomic,strong)NSString *A_INGREDIENT;//成分
@property(nonatomic,strong)NSString *A_FACTORY_NAME;//厂家
@property(nonatomic,strong)NSString *A_PRICE_COST;//报价
@property(nonatomic,strong)NSString *A_INVENTORY;//库存
@property(nonatomic,strong)NSString *A_CODE;//分类id
@property(nonatomic,strong)NSString *A_VALUE;//分类value

@property(nonatomic,strong)NSString *A_DOSAGE;//剂型id
@property(nonatomic,strong)NSString *A_DOSAGE_VALUE;//剂型value

@property(nonatomic,strong)NSString *A_NH;//简介

@property(nonatomic,strong)NSString *A_PROPOSAL;//审核不通过原因


- (void)setValue:(id)value forUndefinedKey:(NSString *)key;

@end
