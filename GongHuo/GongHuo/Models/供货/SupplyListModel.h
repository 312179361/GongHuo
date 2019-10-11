//
//  SupplyListModel.h
//  GongHuo
//
//  Created by TongLi on 2017/9/18.
//  Copyright © 2017年 TongLi. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface SupplyListModel : NSObject
@property(nonatomic,strong)NSString *A_NAME;//产品名
@property(nonatomic,strong)NSString *A_INGREDIENT;//成分

@property(nonatomic,strong)NSString *D_INVENTORY;//库存
@property(nonatomic,strong)NSString *A_O_INVENTORY;//修改前库存
@property(nonatomic,strong)NSString *A_INVENTORY;//修改后库存

@property(nonatomic,strong)NSString *A_CODE;//分类
@property(nonatomic,strong)NSString *A_CODE_VALUE;//分类名称

@property(nonatomic,strong)NSString *A_PRICE_COST;//报价
@property(nonatomic,strong)NSString *A_O_PRICE;//修改前报价
@property(nonatomic,strong)NSString *A_PRICE;//修改后报价



@property(nonatomic,strong)NSString *A_MANUFACTOR;//公司
@property(nonatomic,strong)NSMutableArray *imageArr;
@property(nonatomic,strong)NSString *A_STANDARD;//规格
@property(nonatomic,strong)NSString *A_METHOD;//作用


@property(nonatomic,strong)NSString *A_STATUS_CHECK;//0修改中。1修改成功。2修改失败
@property(nonatomic,strong)NSString *A_PROPOSAL;//原因
@property(nonatomic,strong)NSString *A_EDIT_TYPE;//2修改价格 3修改库存

@property(nonatomic,strong)NSString *A_DOSAGE_VALUE;//剂型

@property(nonatomic,strong)NSString *A_STATUS_DO;
@property(nonatomic,strong)NSString *P_DRUG_FORM;
@property(nonatomic,strong)NSString *S_P_ID;
@property(nonatomic,strong)NSString *A_SHELF;
@property(nonatomic,strong)NSString *S_ID;
@property(nonatomic,strong)NSString *A_ID;
@property(nonatomic,strong)NSString *A_SHELF_TYPE;
@property(nonatomic,strong)NSString *S_CODE;
@property(nonatomic,strong)NSString *A_TYPE;

- (void)setValue:(id)value forUndefinedKey:(NSString *)key;
@end
