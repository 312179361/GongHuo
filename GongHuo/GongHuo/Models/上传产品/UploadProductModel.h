//
//  UploadProductModel.h
//  GongHuo
//
//  Created by TongLi on 2017/9/13.
//  Copyright © 2017年 TongLi. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface UploadProductModel : NSObject
@property(nonatomic,strong)NSString *a_id;
@property(nonatomic,strong)NSMutableArray *productImageArr;
@property(nonatomic,strong)NSString *productName;
@property(nonatomic,strong)NSString *productStandard;//产品规格 eg:1000ml*50
@property(nonatomic,strong)NSString *productStandardOne;//产品规格1 eg:袋、瓶、盒、桶
@property(nonatomic,strong)NSString *productStandardTwo;//产品规格2 eg:件、吨
@property(nonatomic,strong)NSString *productIngrendient;//成分
@property(nonatomic,strong)NSString *factory_name;//厂家
@property(nonatomic,strong)NSString *productPrice;//报价
@property(nonatomic,strong)NSString *productInventory;//产品库存
@property(nonatomic,strong)NSString *product_NH;//产品简介
@property(nonatomic,strong)NSString *productDosageId;//产品剂型id
@property(nonatomic,strong)NSString *productCodeId;//产品分类id




















@end
