//
//  Manager.m
//  GongHuo
//
//  Created by TongLi on 2017/9/13.
//  Copyright © 2017年 TongLi. All rights reserved.
//

#import "Manager.h"
#import <CommonCrypto/CommonCrypto.h>

@implementation Manager
+ (Manager *)shareInstance {
    static Manager *manager = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        manager = [[Manager alloc]init];
    });
    return manager;

}

#pragma mark - 审核中心 -
//审核中心列表 A_STATUS_CHECK：审核状态 0待审核 1通过 2未通过
- (void)httpCheckListWithA_SP_ID:(NSString *)a_sp_id withMobile:(NSString *)mobile withStatus:(NSString *)status withIsAdmin:(NSString *)isAdmin withUserID:(NSString *)userid withPageIndex:(NSInteger )pageIndex withCheckListSuccess:(SuccessResult)checkListSuccess withCheckListFail:(FailResult)checkListFail {
    InterfaceManager *iM = [InterfaceManager shareInstance];
    NSDictionary *parDic = @{@"access":[self digest:[NSString stringWithFormat:@"%@%@",iM.appKey,[iM check_List_Base]]],@"route":[iM check_List_Base],@"params":@{@"A_SP_ID":a_sp_id,@"A_MOBILE":mobile,@"A_STATUS_CHECK":status,@"IS_ADMIN":isAdmin,@"USER_ID":userid,@"PAGE":[NSString stringWithFormat:@"%ld",pageIndex],@"SIZE":@"10"}};
    
    [[NetManager shareInstance] postRequestWithURL:[iM mainUrl] withParameters:parDic withResponseType:nil withContentTypes:nil withSuccessResult:^(AFHTTPRequestOperation *operation, id successResult) {
        
        if ([[successResult objectForKey:@"status"] integerValue] == 200) {
            //解析
            NSMutableArray *checkListArr = [self analyzeCheckListWithDataArr:[[successResult objectForKey:@"data"] objectForKey:@"list"]];
            checkListSuccess(@{@"list":checkListArr,@"pages":[[successResult objectForKey:@"data"] objectForKey:@"pages"]});
            
        }else {
            checkListFail([successResult objectForKey:@"msg"]);
        }
        
    } withError:^(AFHTTPRequestOperation *operation, NSError *errorResult) {
        checkListFail(@"网络错误");
    }];
    
}


//解析审核列表
- (NSMutableArray *)analyzeCheckListWithDataArr:(NSArray *)dataArr {
    NSMutableArray *checkListArr = [NSMutableArray array];
    
    for (NSDictionary *dataDic in dataArr) {
        CheckListModel *tempModel = [[CheckListModel alloc] init];
        [tempModel setValuesForKeysWithDictionary:dataDic];
        [checkListArr addObject:tempModel];
        
    }
    return checkListArr;
}

//产品详情
- (void)httpProductInfoWithAID:(NSString *)aid withProductInfoSuccess:(SuccessResult)infoSuccess withProductInfoFail:(FailResult )infoFail {
    
    
    InterfaceManager *iM = [InterfaceManager shareInstance];
    NSDictionary *parDic = @{@"access":[self digest:[NSString stringWithFormat:@"%@%@",iM.appKey,[iM check_Info_Base]]],@"route":[iM check_Info_Base],@"params":@{@"A_ID":aid}};
    
    [[NetManager shareInstance] postRequestWithURL:[iM mainUrl] withParameters:parDic withResponseType:nil withContentTypes:nil withSuccessResult:^(AFHTTPRequestOperation *operation, id successResult) {
        
        NSLog(@"%@",[self dictionaryToJson:successResult]);
        
        if ([[successResult objectForKey:@"status"] integerValue] == 200) {
            //解析
            CheckListModel *tempModel = [[CheckListModel alloc] init];
            [tempModel setValuesForKeysWithDictionary:[successResult objectForKey:@"data"]];
            infoSuccess(tempModel);
            
        }else {
            infoFail([successResult objectForKey:@"msg"]);
        }
        
    } withError:^(AFHTTPRequestOperation *operation, NSError *errorResult) {
        infoFail(@"网络错误");
    }];

    
}





//产品分类
- (void)httpProductClassWithClassSuccess:(SuccessResult)classSuccess withClassFail:(FailResult)classFail {
    InterfaceManager *iM = [InterfaceManager shareInstance];
    NSDictionary *parDic = @{@"access":[self digest:[NSString stringWithFormat:@"%@%@",iM.appKey,[iM check_Class_Base]]],@"route":[iM check_Class_Base],@"params":@{}};
    
    [[NetManager shareInstance] postRequestWithURL:[iM mainUrl] withParameters:parDic withResponseType:nil withContentTypes:nil withSuccessResult:^(AFHTTPRequestOperation *operation, id successResult) {
        
        if ([[successResult objectForKey:@"status"] integerValue] == 200) {
            NSMutableArray *classModelArr = [NSMutableArray array];
            for (NSDictionary *tempDic in [successResult objectForKey:@"data"]) {
                ProductClassModel *classModel = [[ProductClassModel alloc] init];
                [classModel setValuesForKeysWithDictionary:tempDic];
                [classModelArr addObject:classModel];
            }
            classSuccess(classModelArr);
        }else {
            classFail([successResult objectForKey:@"msg"]);
        }
        
    } withError:^(AFHTTPRequestOperation *operation, NSError *errorResult) {
        classFail(@"网络错误");
    }];
    
}

//产品添加
- (void)addProductWithUploadProductModel:(UploadProductModel *)uploadModel withMemberInfo:(MemberInfoModel *)memberInfo withAddProductSuccess:(SuccessResult)addSuccess withAddProductFail:(FailResult)addFail {
    InterfaceManager *iM = [InterfaceManager shareInstance];
    
    NSDictionary *paramsDic = @{
                                @"A_TIME_CREATE":@"",
                                @"A_USER_ID_CREATE":memberInfo.userid,
                                @"A_TIME_UPDATE":@"",
                                @"A_USER_ID_UPDATE":memberInfo.userid,
                                @"A_SP_ID":memberInfo.l_s_id,
                                @"A_U_ID":memberInfo.userid,
                                @"A_NAME":uploadModel.productName,
                                @"A_STANDARD":[NSString stringWithFormat:@"%@%@/%@",uploadModel.productStandard,uploadModel.productStandardOne,uploadModel.productStandardTwo],
                                @"A_PRICE_COST":uploadModel.productPrice,
                                @"A_INVENTORY":uploadModel.productInventory,
                                @"A_CODE":uploadModel.productCodeId,
                                @"A_NH":uploadModel.product_NH,
                                @"A_IMAGE_1":uploadModel.productImageArr[0],
                                @"A_IMAGE_2":uploadModel.productImageArr[1],
                                @"A_IMAGE_3":uploadModel.productImageArr[2],
                                @"A_IMAGE_4":uploadModel.productImageArr[3],
                                @"A_IMAGE_5":uploadModel.productImageArr[4],
                                @"A_STATUS_CHECK":@"0",
                                @"A_PROPOSAL":@"",
                                @"A_STATUS_DO":@"0",
                                @"A_FACTORY_NAME":uploadModel.factory_name,
                                @"A_INGREDIENT":uploadModel.productIngrendient,
                                @"A_DOSAGE":uploadModel.productDosageId
                                };
    
    
    NSDictionary *parDic = @{@"access":[self digest:[NSString stringWithFormat:@"%@%@",iM.appKey,[iM check_Create_Base]]],@"route":[iM check_Create_Base],@"params":paramsDic};
    
    [[NetManager shareInstance] postRequestWithURL:[iM mainUrl] withParameters:parDic withResponseType:nil withContentTypes:nil withSuccessResult:^(AFHTTPRequestOperation *operation, id successResult) {
        if ([[successResult objectForKey:@"status"] integerValue] == 200) {
            addSuccess(@"上传成功");
        }else {
            addFail([successResult objectForKey:@"msg"]);
        }
        
    } withError:^(AFHTTPRequestOperation *operation, NSError *errorResult) {
        addFail(@"网络错误");
    }];
}


//产品编辑
- (void)editProductWithUploadProductModel:(UploadProductModel *)uploadModel withMemberInfo:(MemberInfoModel *)memberInfo withEditProductSuccess:(SuccessResult)addSuccess withEditProductFail:(FailResult)addFail {
    
    InterfaceManager *iM = [InterfaceManager shareInstance];
    NSDictionary *paramsDic = @{
                                @"A_ID":uploadModel.a_id,
                                @"A_TIME_UPDATE":@"",
                                @"A_USER_ID_UPDATE":memberInfo.userid,
                                @"A_U_ID":memberInfo.userid,
                                @"A_NAME":uploadModel.productName,
                                @"A_STANDARD":[NSString stringWithFormat:@"%@%@/%@",uploadModel.productStandard,uploadModel.productStandardOne,uploadModel.productStandardTwo],
                                @"A_PRICE_COST":uploadModel.productPrice,
                                @"A_INVENTORY":uploadModel.productInventory,
                                @"A_NH":uploadModel.product_NH,
                                @"A_IMAGE_1":uploadModel.productImageArr[0],
                                @"A_IMAGE_2":uploadModel.productImageArr[1],
                                @"A_IMAGE_3":uploadModel.productImageArr[2],
                                @"A_IMAGE_4":uploadModel.productImageArr[3],
                                @"A_IMAGE_5":uploadModel.productImageArr[4],
                                @"A_FACTORY_NAME":uploadModel.factory_name,
                                @"A_INGREDIENT":uploadModel.productIngrendient,
                                @"A_CODE":uploadModel.productCodeId,
                                @"A_DOSAGE":uploadModel.productDosageId,
                                @"A_MOBILE":memberInfo.u_mobile
                                };
    
    
    NSDictionary *parDic = @{@"access":[self digest:[NSString stringWithFormat:@"%@%@",iM.appKey,[iM check_Edit_Base]]],@"route":[iM check_Edit_Base],@"params":paramsDic};
    
    [[NetManager shareInstance] postRequestWithURL:[iM mainUrl] withParameters:parDic withResponseType:nil withContentTypes:nil withSuccessResult:^(AFHTTPRequestOperation *operation, id successResult) {
        if ([[successResult objectForKey:@"status"] integerValue] == 200) {
            addSuccess(@"编辑成功");
        }else {
            addFail([successResult objectForKey:@"msg"]);
        }
        
    } withError:^(AFHTTPRequestOperation *operation, NSError *errorResult) {
        addFail(@"网络错误");
    }];
}

//判断产品能否上传
- (void)httpCheckAccordUploadWithASpId:(NSString *)a_sp_id withCheckAccordSuccess:(SuccessResult )checkAccordSuccess withCheckAccordFail:(FailResult )checkAccordFail {
    InterfaceManager *iM = [InterfaceManager shareInstance];
    NSDictionary *parDic = @{@"access":[self digest:[NSString stringWithFormat:@"%@%@",iM.appKey,[iM check_Accord_Base]]],@"route":[iM check_Accord_Base],@"params":@{@"A_SP_ID":a_sp_id}};
    
    [[NetManager shareInstance] postRequestWithURL:[iM mainUrl] withParameters:parDic withResponseType:nil withContentTypes:nil withSuccessResult:^(AFHTTPRequestOperation *operation, id successResult) {
        
        if ([[successResult objectForKey:@"status"] integerValue] == 200) {
            if ([[successResult objectForKey:@"data"] isEqualToString:@""]) {
                checkAccordSuccess(@"可以上传");
            }else{
                checkAccordFail([NSString stringWithFormat:@"目前缺少 %@ 信息\n到店铺管理添加发货人员信息", [successResult objectForKey:@"data"]]);
            }
            
        }else {
            checkAccordFail([successResult objectForKey:@"msg"]);
        }
        
    } withError:^(AFHTTPRequestOperation *operation, NSError *errorResult) {
        checkAccordFail(@"网络错误");
    }];

    
}


#pragma mark - 供货中心 -
//供货中心列表和详情
- (void)httpSupplyListWithDFID:(NSString *)d_f_id withStatusCheck:(NSString *)a_status_check withSid:(NSString *)s_id withAid:(NSString *)a_id withPageIndex:(NSInteger)pageIndex withSupplyListSuccess:(SuccessResult )supplyListSuccess withSupplyListFail:(FailResult)supplyListFail {
    
//    d_f_id = @"627";
    
    InterfaceManager *iM = [InterfaceManager shareInstance];
    NSDictionary *parDic = @{@"access":[self digest:[NSString stringWithFormat:@"%@%@",iM.appKey,[iM supply_list_Base]]],@"route":[iM supply_list_Base],@"params":@{@"D_F_ID":d_f_id,@"A_STATUS_CHECK":a_status_check,@"A_ID":a_id,@"PAGE":[NSString stringWithFormat:@"%ld",pageIndex],@"SIZE":@"10",@"S_ID":s_id}};
    
    [[NetManager shareInstance] postRequestWithURL:[iM mainUrl] withParameters:parDic withResponseType:nil withContentTypes:nil withSuccessResult:^(AFHTTPRequestOperation *operation, id successResult) {
        NSLog(@"%@",[self dictionaryToJson:successResult]);
        
        if ([[successResult objectForKey:@"status"] integerValue] == 200) {
            
            //解析列表
            NSMutableArray *listArr = [self analyzeSupplyListWithDataArr:[[successResult objectForKey:@"data"] objectForKey:@"list"]];
            supplyListSuccess(@{@"list":listArr,@"page":[[successResult objectForKey:@"data"] objectForKey:@"pages"]});
            
        }else {
            supplyListFail([successResult objectForKey:@"msg"]);
        }
        
    } withError:^(AFHTTPRequestOperation *operation, NSError *errorResult) {
        supplyListFail(@"网络错误");
    }];
    
    
}

//解析供货中心列表
- (NSMutableArray *)analyzeSupplyListWithDataArr:(NSArray *)dataArr {
    NSMutableArray *supplyListArr = [NSMutableArray array];
    for (NSDictionary *jsonDic in dataArr) {
        SupplyListModel *supplyModel = [[SupplyListModel alloc] init];
        [supplyModel setValuesForKeysWithDictionary:jsonDic];
        [supplyListArr addObject:supplyModel];
    }
    return supplyListArr;
    
}

//供货中心的产品编辑
- (void)httpEditSupplyProductWithModel:(SupplyListModel *)productModel withMemberInfo:(MemberInfoModel *)memberInfo withEditType:(NSString *)editType withNewPrice:(NSString *)newPrice withNewInventory:(NSString *)newInventory withShelfInt:(NSString *)shelfInt withShelfReason:(NSString *)shelfReason withEditSupplySuccess:(SuccessResult)editSupplySuccess withEditSupplyFail:(FailResult)editSupplyFail {
    
//    editSupplySuccess(@"修改成功");

    
    InterfaceManager *iM = [InterfaceManager shareInstance];
    NSDictionary *paramsDic = @{
                                @"A_ID": productModel.A_ID,
                                @"A_USER_ID_CREATE":memberInfo.userid,
                                @"A_USER_ID_UPDATE":memberInfo.userid,
                                @"A_SP_ID": memberInfo.l_s_id,
                                @"A_U_ID": memberInfo.userid,
                                @"A_P_ID": productModel.S_P_ID,
                                @"A_S_ID": productModel.S_ID,
                                @"A_EDIT_TYPE":editType,
                                
                                @"A_PRICE_COST":newPrice,
                                @"A_O_PRICE":productModel.A_PRICE_COST,
                                
                                @"A_INVENTORY":newInventory,
                                @"A_O_INVENTORY":productModel.D_INVENTORY,
                                
                                @"A_TYPE":shelfInt,
                                @"A_REASON":shelfReason
                                };
    
    NSDictionary *parDic = @{@"access":[self digest:[NSString stringWithFormat:@"%@%@",iM.appKey,[iM supply_creat_Base]]],@"route":[iM supply_creat_Base],@"params":paramsDic};
    
     [[NetManager shareInstance] postRequestWithURL:[iM mainUrl] withParameters:parDic withResponseType:nil withContentTypes:nil withSuccessResult:^(AFHTTPRequestOperation *operation, id successResult) {
         if ([[successResult objectForKey:@"status"] integerValue] == 200) {
             editSupplySuccess(@"修改成功");
         }else{
             editSupplyFail([successResult objectForKey:@"msg"]);
         }
         
     } withError:^(AFHTTPRequestOperation *operation, NSError *errorResult) {
         editSupplyFail(@"网络错误");
     }];
}



//产品上架
- (void)httpSupplyShelvesWithAid:(NSString *)a_id withAUid:(NSString *)a_u_id withShelvesSuccess:(SuccessResult)shelvesSuccess withShelvesFail:(FailResult)shelvesFail {
    
    InterfaceManager *iM = [InterfaceManager shareInstance];
    NSDictionary *parDic = @{@"access":[self digest:[NSString stringWithFormat:@"%@%@",iM.appKey,[iM supply_shelves_Base]]],@"route":[iM supply_shelves_Base],@"params":@{@"A_ID":a_id,@"A_U_ID":a_u_id}};
    
    [[NetManager shareInstance] postRequestWithURL:[iM mainUrl] withParameters:parDic withResponseType:nil withContentTypes:nil withSuccessResult:^(AFHTTPRequestOperation *operation, id successResult) {
        
        if ([[successResult objectForKey:@"status"] integerValue] == 200) {
            
            shelvesSuccess(@"");
        }else {
            shelvesFail([successResult objectForKey:@"msg"]);
        }
        
    } withError:^(AFHTTPRequestOperation *operation, NSError *errorResult) {
        shelvesFail(@"网络错误");
    }];

    
}

//产品删除
- (void)httpSupplyDeleteWithAid:(NSString *)a_id withSupplyDeleteSuccess:(SuccessResult)supplyDeleteSuccess withSupplyDeleteFail:(FailResult)supplyDeleteFail {
    
    InterfaceManager *iM = [InterfaceManager shareInstance];
    NSDictionary *parDic = @{@"access":[self digest:[NSString stringWithFormat:@"%@%@",iM.appKey,[iM supply_del_Base]]],@"route":[iM supply_del_Base],@"params":@{@"A_ID":a_id}};
    
    [[NetManager shareInstance] postRequestWithURL:[iM mainUrl] withParameters:parDic withResponseType:nil withContentTypes:nil withSuccessResult:^(AFHTTPRequestOperation *operation, id successResult) {
        
        if ([[successResult objectForKey:@"status"] integerValue] == 200) {
            
            supplyDeleteSuccess(@"");
        }else {
            supplyDeleteFail([successResult objectForKey:@"msg"]);
        }
        
    } withError:^(AFHTTPRequestOperation *operation, NSError *errorResult) {
        supplyDeleteFail(@"网络错误");
    }];
    
}

//产品剂型
- (void)httpProductDosageWithDosageSuccess:(SuccessResult)dosageSuccess withDosageFail:(FailResult)dosageFail {
    InterfaceManager *iM = [InterfaceManager shareInstance];
    NSDictionary *parDic = @{@"access":[self digest:[NSString stringWithFormat:@"%@%@",iM.appKey,[iM supply_dosage_Base]]],@"route":[iM supply_dosage_Base],@"params":@{}};
    
    [[NetManager shareInstance] postRequestWithURL:[iM mainUrl] withParameters:parDic withResponseType:nil withContentTypes:nil withSuccessResult:^(AFHTTPRequestOperation *operation, id successResult) {
        
        if ([[successResult objectForKey:@"status"] integerValue] == 200) {
            NSMutableArray *classModelArr = [NSMutableArray array];
            for (NSDictionary *tempDic in [successResult objectForKey:@"data"]) {
                DosageModel *classModel = [[DosageModel alloc] init];
                [classModel setValuesForKeysWithDictionary:tempDic];
                [classModelArr addObject:classModel];
            }
            dosageSuccess(classModelArr);
        }else {
            dosageFail([successResult objectForKey:@"msg"]);
        }
        
    } withError:^(AFHTTPRequestOperation *operation, NSError *errorResult) {
        dosageFail(@"网络错误");
    }];

}

#pragma mark - 订单 -
//订单列表
- (void)httpOrderListWithAFID:(NSString *)a_f_id withAStatus:(NSString *)a_status withPageIndex:(NSInteger)pageIndex withOrderListSuccess:(SuccessResult)orderListSuccess withOrderListFail:(FailResult)orderListFail {
#warning 测试数据
    a_f_id = @"2205";
    
    
    InterfaceManager *iM = [InterfaceManager shareInstance];
    NSDictionary *parDic = @{@"access":[self digest:[NSString stringWithFormat:@"%@%@",iM.appKey,[iM order_list_Base]]],@"route":[iM order_list_Base],@"params":@{@"A_F_ID":a_f_id,@"A_STATUS":a_status,@"SIZE":@"10",@"PAGE":[NSString stringWithFormat:@"%ld",pageIndex]}};

    
    [[NetManager shareInstance] postRequestWithURL:[iM mainUrl] withParameters:parDic withResponseType:nil withContentTypes:nil withSuccessResult:^(AFHTTPRequestOperation *operation, id successResult) {
        
        NSLog(@"%@",[self dictionaryToJson:successResult]);
        if ([[successResult objectForKey:@"status"] integerValue] == 200) {
            
            //解析订单数据
            NSMutableArray *orderListArr = [self httpOrderListWithJsonArr:[[successResult objectForKey:@"data"] objectForKey:@"list"]];

            orderListSuccess(@{@"page":[[successResult objectForKey:@"data"] objectForKey:@"pages"],@"list":orderListArr});
            
        }else {
            orderListFail([successResult objectForKey:@"msg"]);
        }
        
    } withError:^(AFHTTPRequestOperation *operation, NSError *errorResult) {
        orderListFail(@"网络错误");
    }];

}

//解析订单列表
- (NSMutableArray *)httpOrderListWithJsonArr:(NSArray *)jsonArr {
    NSMutableArray *orderListArr = [NSMutableArray array];

    for (NSDictionary *jsonDic in jsonArr) {
        
        OrderListModel *orderListModel = [[OrderListModel alloc] init];
        [orderListModel setValuesForKeysWithDictionary:jsonDic];
        //计算倒计时时长
        orderListModel.orderTimeCount = orderListModel.etm - orderListModel.time;
        //
        if (orderListModel.orderTimeCount > 0) {
            //需要倒计时
            orderListModel.isCountDown = YES;
        }else{
            orderListModel.isCountDown = NO;
        }
        //因为只刷新第3个cell，所以标记row为2
        orderListModel.tempIndex = [NSIndexPath indexPathForRow:2 inSection:orderListArr.count];
        [orderListArr addObject:orderListModel];
        
    }
    return orderListArr;

}

//订单接单
- (void)httpOrdersWithAId:(NSString *)a_id withOrdersSuccess:(SuccessResult)ordersSuccess withOrdersFail:(FailResult)ordersFail {
    
    InterfaceManager *iM = [InterfaceManager shareInstance];
    NSDictionary *parDic = @{@"access":[self digest:[NSString stringWithFormat:@"%@%@",iM.appKey,[iM order_orders_Base]]],@"route":[iM order_orders_Base],@"params":@{@"A_ID":a_id}};
    
    [[NetManager shareInstance] postRequestWithURL:[iM mainUrl] withParameters:parDic withResponseType:nil withContentTypes:nil withSuccessResult:^(AFHTTPRequestOperation *operation, id successResult) {
        
        NSLog(@"%@",[self dictionaryToJson:successResult]);
        if ([[successResult objectForKey:@"status"] integerValue] == 200) {
            
            ordersSuccess(@"");
            
        }else {
            ordersFail([successResult objectForKey:@"msg"]);
        }
        
    } withError:^(AFHTTPRequestOperation *operation, NSError *errorResult) {
        ordersFail(@"网络错误");
    }];

    
   


}


//订单发货
- (void)httpOrderDeliverWithAId:(NSString *)a_id withOId:(NSString *)o_id withToken:(NSString *)token withAFUid:(NSString *)a_f_uid withAFile:(NSString *)a_file withANote:(NSString *)a_note withDeliverSuccess:(SuccessResult)deliverSuccess withDeliverFail:(FailResult)deliverFail {
    //A_ID列表中的id O_ID列表中的oid A_F_UID:"操作人id即是登陆人id" A_FILE:"发货单"
    
    InterfaceManager *iM = [InterfaceManager shareInstance];
    NSDictionary *parDic = @{@"access":[self digest:[NSString stringWithFormat:@"%@%@",iM.appKey,[iM order_deliver_Base]]],@"route":[iM order_deliver_Base],@"params":@{@"A_ID":a_id,@"O_ID":o_id,@"TOKEN":token,@"A_F_UID":a_f_uid,@"A_FILE":a_file,@"A_NOTE":a_note}};
    
    [[NetManager shareInstance] postRequestWithURL:[iM mainUrl] withParameters:parDic withResponseType:nil withContentTypes:nil withSuccessResult:^(AFHTTPRequestOperation *operation, id successResult) {
        
        NSLog(@"%@",[self dictionaryToJson:successResult]);
        if ([[successResult objectForKey:@"status"] integerValue] == 200) {
            
            deliverSuccess(@"");
            
        }else {
            deliverFail([successResult objectForKey:@"msg"]);
        }
        
    } withError:^(AFHTTPRequestOperation *operation, NSError *errorResult) {
        deliverFail(@"网络错误");
    }];

}

- (void)httpOrderInvoiceWithAid:(NSString *)a_id withInvoiceSuccess:(SuccessResult)invoiceSuccess withInvoiceFail:(FailResult)invoiceFail {

    InterfaceManager *iM = [InterfaceManager shareInstance];
    NSDictionary *parDic = @{@"access":[self digest:[NSString stringWithFormat:@"%@%@",iM.appKey,[iM order_invoice_Base]]],@"route":[iM order_invoice_Base],@"params":@{@"A_ID":a_id}};
    
    [[NetManager shareInstance] postRequestWithURL:[iM mainUrl] withParameters:parDic withResponseType:nil withContentTypes:nil withSuccessResult:^(AFHTTPRequestOperation *operation, id successResult) {
        
        NSLog(@"%@",[self dictionaryToJson:successResult]);
        if ([[successResult objectForKey:@"status"] integerValue] == 200) {
            
            invoiceSuccess([successResult objectForKey:@"data"]);
            
        }else {
            invoiceFail([successResult objectForKey:@"msg"]);
        }
        
    } withError:^(AFHTTPRequestOperation *operation, NSError *errorResult) {
        invoiceFail(@"网络错误");
    }];
}

#pragma mark - 人员管理 -
//人员管理列表
- (void)httpUserListWithASpId:(NSString *)a_sp_id withMobile:(NSString *)mobile withUserId:(NSString *)u_id withUserListSuccess:(SuccessResult)userListSuccess withUserListFail:(FailResult)userListFail {
    
    InterfaceManager *iM = [InterfaceManager shareInstance];
    NSDictionary *parDic = @{@"access":[self digest:[NSString stringWithFormat:@"%@%@",iM.appKey,[iM user_list_Base]]],@"route":[iM user_list_Base],@"params":@{@"A_SP_ID":a_sp_id,@"mobile":@"",@"uid":u_id}};
    
    [[NetManager shareInstance] postRequestWithURL:[iM mainUrl] withParameters:parDic withResponseType:nil withContentTypes:nil withSuccessResult:^(AFHTTPRequestOperation *operation, id successResult) {
        
        NSLog(@"%@",[self dictionaryToJson:successResult]);
        if ([[successResult objectForKey:@"status"] integerValue] == 200) {
            //解析
            NSMutableArray *listArr = [self analyzeUserListWithJsonArr:[[successResult objectForKey:@"data"] objectForKey:@"list"]];
            
            userListSuccess(@{@"page":[[successResult objectForKey:@"data"] objectForKey:@"pages"],@"list":listArr});
            
        }else {
            userListFail([successResult objectForKey:@"msg"]);
        }
        
    } withError:^(AFHTTPRequestOperation *operation, NSError *errorResult) {
        userListFail(@"网络错误");
    }];
    
}
//解析用户列表
- (NSMutableArray *)analyzeUserListWithJsonArr:(NSArray *)jsonArr {
    NSMutableArray *tempArr = [NSMutableArray array];
    for (NSDictionary *jsonDic in jsonArr) {
        UserListModel *userListModel = [[UserListModel alloc] init];
        [userListModel setValuesForKeysWithDictionary:jsonDic];
        [tempArr addObject:userListModel];
    }
    return tempArr;
}


//人员添加
- (void)httpAddUserWithMemberInfo:(MemberInfoModel *)memberInfo withPostionType:(NSInteger )postionType withTureName:(NSString *)trueName withMobile:(NSString *)mobile withCardPeople:(NSString *)cardPeople withCard:(NSString *)card withAddUserSuccess:(SuccessResult)addUserSuccess withAddUserFail:(FailResult)addUserFail {
   
    InterfaceManager *iM = [InterfaceManager shareInstance];
    NSDictionary *parDic = @{@"access":[self digest:[NSString stringWithFormat:@"%@%@",iM.appKey,[iM user_add_Base]]],@"route":[iM user_add_Base],@"params":@{@"fuserid":memberInfo.l_s_id,@"password":@"",@"utype":@"4",@"truename":trueName,@"mobile":mobile,@"areaid":memberInfo.l_area_id,@"area":@"",@"bank":@"农业银行",@"bankname":cardPeople,@"card":card,@"isadmin":[NSString stringWithFormat:@"%ld",postionType],@"token":memberInfo.token}};
    
    [[NetManager shareInstance] postRequestWithURL:[iM mainUrl] withParameters:parDic withResponseType:nil withContentTypes:nil withSuccessResult:^(AFHTTPRequestOperation *operation, id successResult) {
        NSLog(@"%@",successResult);
        if ([[successResult objectForKey:@"status"] integerValue] == 200) {
            addUserSuccess(@"添加成功");
        }else {
            addUserFail([successResult objectForKey:@"msg"]);
        }
        
    } withError:^(AFHTTPRequestOperation *operation, NSError *errorResult) {
        addUserFail(@"网络错误");
    }];
   
}

//人员编辑
- (void)httpEditUserWithMemberInfo:(UserListModel *)userList withToken:(NSString *)token withPostionType:(NSInteger )postionType withTureName:(NSString *)trueName withMobile:(NSString *)mobile withCardPeople:(NSString *)cardPeople withCard:(NSString *)card withEditUserSuccess:(SuccessResult)editUserSuccess withEditUserFail:(FailResult)editUserFail {
    
    InterfaceManager *iM = [InterfaceManager shareInstance];
    NSDictionary *parDic = @{@"access":[self digest:[NSString stringWithFormat:@"%@%@",iM.appKey,[iM user_create_Base]]],@"route":[iM user_create_Base],@"params":@{@"id":userList.l_u_id,@"truename":trueName,@"areaid":userList.countycode,@"area":userList.l_area,@"tel":mobile,@"bank":@"农业银行",@"bankname":cardPeople,@"card":card,@"isadmin":[NSString stringWithFormat:@"%ld",postionType],@"token":token}};
    
    [[NetManager shareInstance] postRequestWithURL:[iM mainUrl] withParameters:parDic withResponseType:nil withContentTypes:nil withSuccessResult:^(AFHTTPRequestOperation *operation, id successResult) {
        if ([[successResult objectForKey:@"status"] integerValue] == 200) {
            editUserSuccess(@"编辑成功");
        }else {
            editUserFail([successResult objectForKey:@"msg"]);
        }
    } withError:^(AFHTTPRequestOperation *operation, NSError *errorResult) {
        editUserFail(@"网络错误");
    }];

}




#pragma mark - 登录 -
- (BOOL)isLoginStatus {
    if (self.memberInfoModel.userid != nil && ![self.memberInfoModel.userid isEqualToString:@""]) {
        return YES;
    }else {
        return NO;
    }
}

//登录
- (void)httpLoginWithMobile:(NSString *)mobile withPassword:(NSString *)password withLoginSuccess:(SuccessResult)loginSuccess withLoginFail:(FailResult)loginFail {
    InterfaceManager *iM = [InterfaceManager shareInstance];
    NSDictionary *parDic = @{@"access":[self digest:[NSString stringWithFormat:@"%@%@",iM.appKey,[iM login_Base]]],@"route":[iM login_Base],@"params":@{@"LOGINNAME":mobile,@"PASSWORD":[self digest:password],@"FACILITY":@"4"}};
    
    [[NetManager shareInstance] postRequestWithURL:[iM mainUrl] withParameters:parDic withResponseType:nil withContentTypes:nil withSuccessResult:^(AFHTTPRequestOperation *operation, id successResult) {
        NSLog(@"%@",[self dictionaryToJson:successResult]);
        if ([[successResult objectForKey:@"status"] integerValue] == 200) {
            //解析
            BOOL isSave = [self analyzeMemberWithJsonDic:[successResult objectForKey:@"data"] withPassword:password];
            if (isSave == YES) {
                //发送通知。说明切换了账号
                [[NSNotificationCenter defaultCenter] postNotificationName:@"loginNoti" object:self userInfo:nil];
                
                loginSuccess(@"登录成功");
            }else {
                loginFail(@"保存账号到本地失败");
            }
            
        }else {
            loginFail([successResult objectForKey:@"msg"]);
        }
    } withError:^(AFHTTPRequestOperation *operation, NSError *errorResult) {
        loginFail(@"网络错误");
    }];
}
//解析用户登录信息
- (BOOL)analyzeMemberWithJsonDic:(NSDictionary *)jsonDic withPassword:(NSString *)password {
    
    MemberInfoModel *memberInfoModel = [[MemberInfoModel alloc] init];
    [memberInfoModel setValuesForKeysWithDictionary:jsonDic ];
    memberInfoModel.password = password;
    
    //账号密码登录，需要存到本地
    //存到本地利用归档
    BOOL saveResult = [self saveMemberInfoModelToLocationWithMemberInfo:memberInfoModel];
    if (saveResult == YES) {
        //存入本地成功
        self.memberInfoModel = memberInfoModel;
        return YES;
    }else{
        return NO;
        
    }
}

//退出登录
- (void)logOffAction {
    //清空单例模型
    self.memberInfoModel = nil;
    //清空本地存储的模型
    [self clearMemberInfoFromLocation];
    
}

//清空本地的用户信息
- (void)clearMemberInfoFromLocation {
    NSArray *_paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *_documentPath = [_paths lastObject];
    NSFileManager *fileManager = [NSFileManager defaultManager];
    
    NSString *memberInfoPath = [_documentPath stringByAppendingPathComponent:@"memberInfoModel.archiver"];
    
    BOOL isExists = [fileManager fileExistsAtPath:memberInfoPath];
    
    if (isExists) {
        
        NSError *err;
        
        [fileManager removeItemAtPath:memberInfoPath error:&err];
        
    }
}

#pragma mark - 注册 -
//验证推广人手机
- (void)httpPromoterWithMobile:(NSString *)mobile withPromoterSuccess:(SuccessResult)promoterSuccess withPromoterFail:(FailResult)promoterFail {
    InterfaceManager *iM = [InterfaceManager shareInstance];
    NSDictionary *parDic = @{@"access":[self digest:[NSString stringWithFormat:@"%@%@",iM.appKey,[iM promoter_Base]]],@"route":[iM promoter_Base],@"params":@{@"mobile":mobile}};
    
    [[NetManager shareInstance] postRequestWithURL:[iM mainUrl] withParameters:parDic withResponseType:nil withContentTypes:nil withSuccessResult:^(AFHTTPRequestOperation *operation, id successResult) {
        if ([[successResult objectForKey:@"status"] integerValue] == 200) {
            promoterSuccess(@"验证通过");
        }else {
            promoterFail([successResult objectForKey:@"msg"]);
        }
    } withError:^(AFHTTPRequestOperation *operation, NSError *errorResult) {
        promoterFail(@"网络错误");
    }];
}

//门市列表
- (void)httpRetailListWithAreaId:(NSString *)areaId withRetailSuccess:(SuccessResult)retailSuccess withRetailFail:(FailResult)retailFail {
    
    InterfaceManager *iM = [InterfaceManager shareInstance];
    NSDictionary *parDic = @{@"access":[self digest:[NSString stringWithFormat:@"%@%@",iM.appKey,[iM retail_Base]]],@"route":[iM retail_Base],@"params":@{@"areaid":areaId}};
    
    [[NetManager shareInstance] postRequestWithURL:[iM mainUrl] withParameters:parDic withResponseType:nil withContentTypes:nil withSuccessResult:^(AFHTTPRequestOperation *operation, id successResult) {
        if ([[successResult objectForKey:@"status"] integerValue] == 200) {
            NSLog(@"%@",[self dictionaryToJson:successResult]);
            retailSuccess([[successResult objectForKey:@"data"] objectForKey:@"list"]);
        }else {
            retailFail([successResult objectForKey:@"msg"]);
        }
    } withError:^(AFHTTPRequestOperation *operation, NSError *errorResult) {
        retailFail(@"网络错误");
    }];
    
}

//市场列表
- (void)httpMarkListWithAreaId:(NSString *)areaId withMarkSuccess:(SuccessResult)markSuccess withMarkFail:(FailResult)markFail {
    
    InterfaceManager *iM = [InterfaceManager shareInstance];
    NSDictionary *parDic = @{@"access":[self digest:[NSString stringWithFormat:@"%@%@",iM.appKey,[iM mark_Base]]],@"route":[iM mark_Base],@"params":@{@"areaid":areaId}};
    
    [[NetManager shareInstance] postRequestWithURL:[iM mainUrl] withParameters:parDic withResponseType:nil withContentTypes:nil withSuccessResult:^(AFHTTPRequestOperation *operation, id successResult) {
        NSLog(@"%@",[self dictionaryToJson:successResult]);
        
        if ([[successResult objectForKey:@"status"] integerValue] == 200) {
            markSuccess([successResult objectForKey:@"data"]);
            
        }else {
            markFail([successResult objectForKey:@"msg"]);
        }
        
    } withError:^(AFHTTPRequestOperation *operation, NSError *errorResult) {
        markFail(@"网络错误");
    }];
}

//添加门市 mid-市场id name-门市名称 developername-推广者手机 address-门市地址
- (void)httpAddShopWithMid:(NSString *)mid withName:(NSString *)name withDeveloperName:(NSString *)developerName withAreaid:(NSString *)areaId withAddress:(NSString *)address withAddShopSuccess:(SuccessResult)addShopSuccess withAddShopFail:(FailResult)addShopFail {
    
    InterfaceManager *iM = [InterfaceManager shareInstance];
    NSDictionary *parDic = @{@"access":[self digest:[NSString stringWithFormat:@"%@%@",iM.appKey,[iM suppliershop_Base]]],@"route":[iM suppliershop_Base],@"params":@{@"mid":mid,@"name":name,@"developername":developerName,@"areaid":areaId,@"addr":address}};
    
    [[NetManager shareInstance] postRequestWithURL:[iM mainUrl] withParameters:parDic withResponseType:nil withContentTypes:nil withSuccessResult:^(AFHTTPRequestOperation *operation, id successResult) {
        if ([[successResult objectForKey:@"status"] integerValue] == 200) {
            
            addShopSuccess(@"添加成功");
        }else {
            addShopFail([successResult objectForKey:@"msg"]);
        }
    } withError:^(AFHTTPRequestOperation *operation, NSError *errorResult) {
        addShopFail(@"网络错误");
    }];
    
}

//注册 添加负责人
- (void)httpRegisterSupplyLeaderWithFuserId:(NSString *)fuserid withPassword:(NSString *)password withTruename:(NSString *)truename withMobile:(NSString *)mobile withAreaid:(NSString *)areaId withIsadmin:(NSString *)isadmin withRegisterSuccess:(SuccessResult)registerSuccess withRegisterFail:(FailResult)registerFail {
    
//    {"access":"F05C177D1606B1D1C52093B1755D1F63","route":"reg.supply-leader","params":{"fuserid":"1029","password":"","truename":"农","mobile":"5555","areaid":"841","isadmin":3}}

    InterfaceManager *iM = [InterfaceManager shareInstance];
    NSDictionary *parDic = @{@"access":[self digest:[NSString stringWithFormat:@"%@%@",iM.appKey,[iM supplyLeader_Base]]],@"route":[iM supplyLeader_Base],@"params":@{@"fuserid":fuserid,@"password":[self digest:password],@"truename":truename,@"mobile":mobile,@"areaid":areaId,@"isadmin":isadmin}};
    
    [[NetManager shareInstance] postRequestWithURL:[iM mainUrl] withParameters:parDic withResponseType:nil withContentTypes:nil withSuccessResult:^(AFHTTPRequestOperation *operation, id successResult) {
        
        if ([[successResult objectForKey:@"status"] integerValue] == 200) {
            registerSuccess(@"注册成功");
            
        }else {
            registerFail([successResult objectForKey:@"msg"]);
        }
        
    } withError:^(AFHTTPRequestOperation *operation, NSError *errorResult) {
        registerFail(@"网络错误");
    }];
    

}

//检验这个手机号是否被注册
- (void)httpRegisterCheckPhoneWithMobile:(NSString *)mobile withCheckPhoneSuccess:(SuccessResult)checkPhoneSuccess withCheckPhoneFail:(FailResult)checkPhoneFail {
    
    InterfaceManager *iM = [InterfaceManager shareInstance];
    NSDictionary *parDic = @{@"access":[self digest:[NSString stringWithFormat:@"%@%@",iM.appKey,[iM regCheckPhone_Base]]],@"route":[iM regCheckPhone_Base],@"params":@{@"mobile":mobile}};

    [[NetManager shareInstance] postRequestWithURL:[iM mainUrl] withParameters:parDic withResponseType:nil withContentTypes:nil withSuccessResult:^(AFHTTPRequestOperation *operation, id successResult) {
        if ([[successResult objectForKey:@"status"] integerValue] == 200) {
            checkPhoneSuccess(@"");
        }else if([[successResult objectForKey:@"status"] integerValue] == 403){
            checkPhoneFail(@"此手机号已经注册过，不能重复注册");
        }else {
            checkPhoneFail([successResult objectForKey:@"msg"]);
        }
    } withError:^(AFHTTPRequestOperation *operation, NSError *errorResult) {
        checkPhoneFail(@"网络错误");
    }];
    
}

#pragma mark - 忘记密码 -
- (void)httpForgetPasswordWithMobile:(NSString *)mobile withPassword:(NSString *)password withForgetSuccess:(SuccessResult)forgetSuccess withForgetFail:(FailResult)forgetFail {
    
    InterfaceManager *iM = [InterfaceManager shareInstance];
    NSDictionary *parDic = @{@"access":[self digest:[NSString stringWithFormat:@"%@%@",iM.appKey,[iM forgetPassword_Base]]],@"route":[iM forgetPassword_Base],@"params":@{@"mobile":mobile,@"pwd":[self digest:password]}};
    
    [[NetManager shareInstance] postRequestWithURL:[iM mainUrl] withParameters:parDic withResponseType:nil withContentTypes:nil withSuccessResult:^(AFHTTPRequestOperation *operation, id successResult) {
        if ([[successResult objectForKey:@"status"] integerValue] == 200) {
            forgetSuccess(@"修改成功");
        }else {
            forgetFail([successResult objectForKey:@"msg"]);
        }
    } withError:^(AFHTTPRequestOperation *operation, NSError *errorResult) {
        forgetFail(@"网络错误");
    }];

    
}

//修改密码
- (void)httpMotifyPasswordWithUserId:(NSString *)userId withPassword:(NSString *)password withMotifySuccess:(SuccessResult)motifySuccess withMotifyFail:(FailResult)motifyFail {
    
    InterfaceManager *iM = [InterfaceManager shareInstance];
    NSDictionary *parDic = @{@"access":[self digest:[NSString stringWithFormat:@"%@%@",iM.appKey,[iM motifyPassword_Base]]],@"route":[iM motifyPassword_Base],@"params":@{@"USERID":userId,@"PWD":[self digest:password]}};
    
    [[NetManager shareInstance] postRequestWithURL:[iM mainUrl] withParameters:parDic withResponseType:nil withContentTypes:nil withSuccessResult:^(AFHTTPRequestOperation *operation, id successResult) {
        if ([[successResult objectForKey:@"status"] integerValue] == 200) {
            motifySuccess(@"修改成功");
        }else {
            motifyFail([successResult objectForKey:@"msg"]);
        }
    } withError:^(AFHTTPRequestOperation *operation, NSError *errorResult) {
        motifyFail(@"网络错误");
    }];
    
}


#pragma mark - 短信验证码 -
//发送短信验证码
- (void)httpSendMsgCodeWithMobile:(NSString *)mobile withSendMsgSuccess:(SuccessResult)sendMsgSuccess withSendMsgFail:(FailResult)sendMsgFail {
    
    InterfaceManager *iM = [InterfaceManager shareInstance];
    NSDictionary *parDic = @{@"access":[self digest:[NSString stringWithFormat:@"%@%@",iM.appKey,[iM user_msg_Base]]],@"route":[iM user_msg_Base],@"params":@{@"TEL":mobile}};
    
    [[NetManager shareInstance] postRequestWithURL:[iM mainUrl] withParameters:parDic withResponseType:nil withContentTypes:nil withSuccessResult:^(AFHTTPRequestOperation *operation, id successResult) {
        if ([[successResult objectForKey:@"status"] integerValue] == 200) {
            sendMsgSuccess(@"发送成功");
        }else {
            sendMsgFail([successResult objectForKey:@"msg"]);
        }
    } withError:^(AFHTTPRequestOperation *operation, NSError *errorResult) {
        sendMsgFail(@"网络错误");
    }];
    
}


//验证短信验证码
- (void)httpCheckMsgCodeWithMobile:(NSString *)mobile withMobileCode:(NSString *)mobileCode withCheckCodeSuccess:(SuccessResult)checkCodeSuccess withCheckCodeFail:(FailResult)checkCodeFail {
    
    InterfaceManager *iM = [InterfaceManager shareInstance];
    NSDictionary *parDic = @{@"access":[self digest:[NSString stringWithFormat:@"%@%@",iM.appKey,[iM user_check_Base]]],@"route":[iM user_check_Base],@"params":@{@"TEL":mobile,@"CODE":mobileCode}};
    
    [[NetManager shareInstance] postRequestWithURL:[iM mainUrl] withParameters:parDic withResponseType:nil withContentTypes:nil withSuccessResult:^(AFHTTPRequestOperation *operation, id successResult) {
        if ([[successResult objectForKey:@"status"] integerValue] == 200) {
            checkCodeSuccess(@"验证成功");
        }else {
            checkCodeFail([successResult objectForKey:@"msg"]);
        }
    } withError:^(AFHTTPRequestOperation *operation, NSError *errorResult) {
        checkCodeFail(@"网络错误");
    }];

}

#pragma mark - 消息 -
//消息列表
- (void)httpMyNewsListWithPageIndex:(NSInteger)pageIndex withNewsSuccess:(SuccessResult)newsSuccess withNewsFail:(FailResult)newsFail {
    
    InterfaceManager *iM = [InterfaceManager shareInstance];
    NSDictionary *parDic = @{@"access":[self digest:[NSString stringWithFormat:@"%@%@",iM.appKey,[iM news_Base]]],@"route":[iM news_Base],@"params":@{@"pageindex":[NSString stringWithFormat:@"%ld",pageIndex],@"pagesize":@"10"}};

    [[NetManager shareInstance] postRequestWithURL:[iM mainUrl] withParameters:parDic withResponseType:nil withContentTypes:nil withSuccessResult:^(AFHTTPRequestOperation *operation, id successResult) {
        if ([[successResult objectForKey:@"status"] integerValue] == 200) {
            //解析消息列表
            NSLog(@"%@",[self dictionaryToJson:successResult]);
            NSMutableArray *newsListArr = [self analyzeMyNewsWithJsonArr:[[successResult objectForKey:@"data"] objectForKey:@"content"]];
            

            newsSuccess(@{@"list":newsListArr,@"pages":[[successResult objectForKey:@"data"] objectForKey:@"totalpages"]});
        }else {
            newsFail([successResult objectForKey:@"msg"]);
        }
    } withError:^(AFHTTPRequestOperation *operation, NSError *errorResult) {
        newsFail(@"网络错误");
    }];
}

//解析消息列表
- (NSMutableArray *)analyzeMyNewsWithJsonArr:(NSArray *)jsonArr {
    NSMutableArray *newsArr = [NSMutableArray array];
    for (NSDictionary *jsonDic in jsonArr) {
        NewsModel *tempNewsModel = [[NewsModel alloc] init];
        [tempNewsModel setValuesForKeysWithDictionary:jsonDic];
        [newsArr addObject:tempNewsModel];
    }
    
    return newsArr;
}

//消息详情
- (void)httpNewsDetailWithICode:(NSString *)i_code withNewsDetailSuccess:(SuccessResult)newsDetailSuccess withNewsDetailFail:(FailResult)newsDetailFail {
    
    InterfaceManager *iM = [InterfaceManager shareInstance];
    NSDictionary *parDic = @{@"access":[self digest:[NSString stringWithFormat:@"%@%@",iM.appKey,[iM newsDetail_Base]]],@"route":[iM newsDetail_Base],@"params":@{@"id":i_code}};
    
    [[NetManager shareInstance] postRequestWithURL:[iM mainUrl] withParameters:parDic withResponseType:nil withContentTypes:nil withSuccessResult:^(AFHTTPRequestOperation *operation, id successResult) {
        NSLog(@"%@",[self dictionaryToJson:successResult]);
        
        if ([[successResult objectForKey:@"status"] integerValue] == 200) {
            
        }else {
            newsDetailFail([successResult objectForKey:@"msg"]);
        }
        
    } withError:^(AFHTTPRequestOperation *operation, NSError *errorResult) {
        newsDetailFail(@"网络错误");
    }];
}


#pragma mark - 其他 -
- (NSArray *)areaTree {
    if (_areaTree == nil) {
        self.areaTree = [NSArray array];
    }
    return _areaTree;
}
//全国地区请求
- (void)httpAreaTreeWithAreaSuccess:(SuccessResult)areaSuccess withAreaFail:(FailResult)areaFail {

    InterfaceManager *iM = [InterfaceManager shareInstance];
    NSDictionary *parDic = @{@"access":[self digest:[NSString stringWithFormat:@"%@%@",iM.appKey,[iM area_Base]]],@"route":[iM area_Base]};
    
    [[NetManager shareInstance] postRequestWithURL:[iM mainUrl] withParameters:parDic withResponseType:nil withContentTypes:nil withSuccessResult:^(AFHTTPRequestOperation *operation, id successResult) {
        if ([[successResult objectForKey:@"status"] integerValue] == 200) {
            self.areaTree = [successResult objectForKey:@"data"];
            areaSuccess(self.areaTree);
        }else {
            areaFail([successResult objectForKey:@"msg"]);
        }
        
    } withError:^(AFHTTPRequestOperation *operation, NSError *errorResult) {
        areaFail(@"网络错误");
    }];
}

//上传图片附件
- (void)uploadImageWithUploadImage:(UIImage *)uploadImage withUploadSuccess:(SuccessResult )uploadSuccess withUploadFail:(FailResult)uploadFail {
    
    InterfaceManager *iM = [InterfaceManager shareInstance];
    
    NSArray *imageInfo = [self image2DataURL:uploadImage];
    //imageInfo 下标0是类型 下标1是base64字符串
//    NSDictionary *valueDic = @{@"ext":imageInfo[0],@"file":imageInfo[1]};
    NSDictionary *valueDic = @{@"ext":imageInfo[0],@"file":@"111"};

    NSDictionary *valueDic1 = @{@"ext":imageInfo[0]};
    NSDictionary *valueDic2 = @{@"file":@"111"};

    
    NSDictionary *parDic = @{@"access":[self digest:[NSString stringWithFormat:@"%@%@",iM.appKey,[iM uploadImage_Base]]],
                             @"route":[iM uploadImage_Base],
                             @"params":@{
                                     @"token":self.memberInfoModel.token,
                                     @"img":@[valueDic]
                                     }
                             };
    
    
    [[NetManager shareInstance] postRequestWithURL:[iM mainUrl] withParameters:parDic withResponseType:nil withContentTypes:nil withSuccessResult:^(AFHTTPRequestOperation *operation, id successResult) {
        NSString *imgPath = [[successResult objectForKey:@"path"] objectAtIndex:0];
        uploadSuccess(imgPath);

    } withError:^(AFHTTPRequestOperation *operation, NSError *errorResult) {
        NSLog(@"%ld",operation.response.statusCode);
        uploadFail(@"上传图片失败");
    }];
    
}

//图片  ->  base64
- (BOOL) imageHasAlpha: (UIImage *) image
{
    CGImageAlphaInfo alpha = CGImageGetAlphaInfo(image.CGImage);
    return (alpha == kCGImageAlphaFirst ||
            alpha == kCGImageAlphaLast ||
            alpha == kCGImageAlphaPremultipliedFirst ||
            alpha == kCGImageAlphaPremultipliedLast);
}
- (NSArray *) image2DataURL: (UIImage *) image
{
    NSData *imageData = nil;
    NSString *mimeType = nil;
    
    if ([self imageHasAlpha: image]) {
        imageData = UIImagePNGRepresentation(image);
        mimeType = @".png";
    } else {
        imageData = UIImageJPEGRepresentation(image, 1.0f);
        mimeType = @".jpeg";
    }
    //0是类型，1是base64转码
    NSString *base64Str = [NSString stringWithFormat:@"%@",[imageData base64EncodedStringWithOptions:0]];
    NSArray *infoArr = @[mimeType,base64Str];
    return infoArr;
}




//归档 写入沙盒
- (BOOL)saveMemberInfoModelToLocationWithMemberInfo:(MemberInfoModel *)memberInfo {
    NSArray *_paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *_documentPath = [_paths lastObject];
    NSLog(@"%@",_documentPath);
    NSString *_personFilePath = [_documentPath stringByAppendingPathComponent:@"memberInfoModel.archiver"];
    
    //实例化一个可变二进制数据的对象
    NSMutableData *_writingData = [NSMutableData data];
    //根据_writingData创建归档器对象
    NSKeyedArchiver *_archiver = [[NSKeyedArchiver alloc]initForWritingWithMutableData:_writingData];
    //对指定数据做归档，并将归档数据写入到_writingData中
    [_archiver encodeObject:memberInfo forKey:@"memberInfoModel"];
    //完成归档
    [_archiver finishEncoding];
    
    //将_writingData写入到指定文件路径
    return  [_writingData writeToFile:_personFilePath atomically:YES];
}

//反归档，从沙盒中读取
- (BOOL)readMemberInfoModelFromLocation {
    NSArray *_paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *_documentPath = [_paths lastObject];
    NSLog(@"%@",_documentPath);
    
    NSString *_personFilePath = [_documentPath stringByAppendingPathComponent:@"memberInfoModel.archiver"];
    //获取二进制字节流对象
    NSData *_readingData = [NSData dataWithContentsOfFile:_personFilePath];
    //通过_readingData对象来创建解档器对象
    NSKeyedUnarchiver *_unarchiver = [[NSKeyedUnarchiver alloc]initForReadingWithData:_readingData];
    if (_unarchiver == nil) {
        return NO;
    }else {
        //对二进制字节流做解档操作
        MemberInfoModel *membermodel = [_unarchiver decodeObjectForKey:@"memberInfoModel"];
        //完成解档
        [_unarchiver finishDecoding];
        //将从沙盒读取的个人信息，赋给当前的单例model
        if (membermodel.u_mobile != nil || ![membermodel.u_mobile isEqualToString:@""]) {
            self.memberInfoModel = membermodel;
            return YES;
        }else{
            return NO;
        }
        
    }
    
}



//base64加密
- (NSString *)digest:(NSString *)sourceStr {
    //把OC要转化为C语言字符串
    const char * cStr = [sourceStr UTF8String];
    
    //得到C语言字符串的长度
    unsigned long cStrLenth = strlen(cStr);
    //  声明一个字符数组,个数为16
    unsigned char theResult[CC_MD5_DIGEST_LENGTH];
    //使用这个函数进行加密。参数1：要加密的字符串；参数2：C语言字符串的长度。参数3：MD5函数声明的密文由16个16进制的字符组成，这个参数，其实就是一个数组首地址的指针，这个数组用来存放这个函数生成16个16进制的字符
    CC_MD5(cStr, (CC_LONG)cStrLenth, theResult);
    
    //遍历这个数组，把他们拼接起来就是加密后的字符串(密文)了
    NSMutableString *secretStr = [NSMutableString string];
    for (int i = 0; i < CC_MD5_DIGEST_LENGTH; i++) {
        NSLog(@"%02X",theResult[i]);
        //这个数组中的类型是%02X
        [secretStr appendFormat:@"%02X",theResult[i]];
    }
    return secretStr;
}


//截屏
-(UIImage *)screenShot {
    
    UIWindow *keyWindow = [[UIApplication sharedApplication] keyWindow];
    CGRect rect = [keyWindow bounds];
    
    UIGraphicsBeginImageContextWithOptions(rect.size, NO, 0.0); //currentView 当前的view  创建一个基于位图的图形上下文并指定大小为
    
    [keyWindow.layer renderInContext:UIGraphicsGetCurrentContext()];//renderInContext呈现接受者及其子范围到指定的上下文
    UIImage *viewImage = UIGraphicsGetImageFromCurrentImageContext();//返回一个基于当前图形上下文的图片
    UIGraphicsEndImageContext();//移除栈顶的基于当前位图的图形上下文
    
    return viewImage;
    //    UIImageWriteToSavedPhotosAlbum(viewImage, nil, nil, nil);//然后将该图片保存到图片图
    
}

//将字典变为json格式的字符串 -
- (NSString *)dictionaryToJson:(id )dic {
    
    NSError *parseError = nil;
    NSData *jsonData = [NSJSONSerialization dataWithJSONObject:dic options:NSJSONWritingPrettyPrinted error:&parseError];
    NSString *tempStr = [[NSString alloc] initWithData:jsonData encoding:NSUTF8StringEncoding];
    
    tempStr = [tempStr stringByReplacingOccurrencesOfString:@"\n" withString:@""];
    tempStr = [tempStr stringByReplacingOccurrencesOfString:@" " withString:@""];
    return tempStr;
}

#pragma mark - 隐藏navigationBar -
//隐藏navigationBar下面的那条线
- (void)isClearNavigationBarLine:(BOOL )hideLine withNavigationController:(UINavigationController *)navi{
    /*
     navigationBar上有两个视图：1、_UINavigationBarBackground；2、_UINavigationBarBackIndicatorView
     其中_UINavigationBarBackground中又有两个视图：1、_UIBackdropView；2、UIImageView，这个imageView就是那一条线
     而_UINavigationBarBackIndicatorView上面没有视图了
     */
    
    //获取navigationBar上面的上面的视图
    NSArray *list = navi.navigationBar.subviews;
    for (UIView *navigationBarBackgroud in list) {
        
        //找到_UINavigationBarBackground
        if ([navigationBarBackgroud isKindOfClass:NSClassFromString(@"_UIBarBackground")]) {
            //在获取_UINavigationBarBackground上面的视图
            for (UIView *lineImageView in navigationBarBackgroud.subviews) {
                
                //如果上面是imageView的话，就是那条线
                if ([lineImageView isKindOfClass:[UIImageView class]]) {
                    if (hideLine == YES) {
                        //将这个线隐藏
                        lineImageView.hidden = YES;
                    }else {
                        //不隐藏这个线
                        lineImageView.hidden = NO;
                    }
                    
                }
            }
        }
    }
    
}


/**
 *  根据透明度去绘制一个图片，也可以省略此处用一个透明的图片，没这个效果好
 */
-(UIImage *)getImageWithAlpha:(CGFloat)alpha{
    
    UIColor *color = kColor(250, 53, 78, alpha);
    CGSize colorSize=CGSizeMake(1, 1);
    
    UIGraphicsBeginImageContext(colorSize);
    
    CGContextRef context = UIGraphicsGetCurrentContext();
    
    CGContextSetFillColorWithColor(context, color.CGColor);
    
    CGContextFillRect(context, CGRectMake(0, 0, 1, 1));
    
    UIImage *img = UIGraphicsGetImageFromCurrentImageContext();
    
    UIGraphicsEndImageContext();
    
    return img;
    
}





@end
