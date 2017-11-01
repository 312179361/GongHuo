//
//  InterfaceManager.m
//  GongHuo
//
//  Created by TongLi on 2017/9/13.
//  Copyright © 2017年 TongLi. All rights reserved.
//

#import "InterfaceManager.h"

@implementation InterfaceManager
+ (InterfaceManager *)shareInstance {
    static InterfaceManager *interfaceManager = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        interfaceManager = [[InterfaceManager alloc] init];
        interfaceManager.appKey = @"3jWPpCrXePh4PaSGH0JUot0CRDtP9VaQ";
    });
    return interfaceManager;
    
}

- (NSString *)mainUrl {
    //本地
//    return @"http://ybsat.vicp.io/";
    //线上
    return @"https://apigh.nongyao001.com/";
    
}


#pragma mark - 审核中心 -
//审核中心列表
- (NSString *)check_List_Base {
    return @"check.lists";
}

//产品详情
- (NSString *)check_Info_Base {
    return @"check.info";
}


//产品分类
- (NSString *)check_Class_Base {
    return @"check.class";
}
//添加产品
- (NSString *)check_Create_Base {
    return @"check.create";
}
//编辑产品
- (NSString *)check_Edit_Base {
    return @"check.edit";

}

//判断产品能否上传
- (NSString *)check_Accord_Base {
    return @"check.accord";
}


#pragma mark - 供货中心 -
//供货列表
- (NSString *)supply_list_Base {
    return @"supply.lists";
}

//产品编辑--包含 下架、改价、改库存
- (NSString *)supply_creat_Base {
    return @"supply.create";
}

//产品上架
- (NSString *)supply_shelves_Base {
    return @"supply.shelves";
}

//产品删除
- (NSString *)supply_del_Base {
    return @"supply.del";
}

//产品剂型
- (NSString *)supply_dosage_Base {
    return @"supply.dosage";
}

//删除修改记录，
- (NSString *)supply_hide_Base {
    return @"supply.hide";
}

#pragma mark - 订单 -
//订单列表
- (NSString *)order_list_Base {
    return @"order.list";
}

//订单接单
- (NSString *)order_orders_Base {
    return @"order.orders";
}


//订单发货
- (NSString *)order_deliver_Base {
    return @"order.deliver";
}


//查看发货单
- (NSString *)order_invoice_Base {
    return @"order.invoice";
}

//是否有新订单
- (NSString *)order_fresh_Base {
    return @"order.fresh";
}



#pragma mark - 人员管理 -
//人员管理列表
- (NSString *)user_list_Base {
    return @"user.lists";
}
//添加
- (NSString *)user_add_Base {
    return @"user.add";
}

//编辑
- (NSString *)user_create_Base {
    return @"user.create";

}

//是否允许添加老板
- (NSString *)user_boss_Base {
    return @"user.boss";
}




#pragma mark - 登录 -
- (NSString *)login_Base {
    return @"user.login";
}
#pragma mark - 注册 -
//验证推广人手机号
- (NSString *)promoter_Base {
    return @"reg.promoter";
}
//门市列表
- (NSString *)retail_Base {
    return @"reg.retail";
}
//市场列表
- (NSString *)mark_Base {
    return @"reg.market";
}

//添加门市
- (NSString *)suppliershop_Base {
    return @"reg.suppliershop";
}

//注册 添加负责人
- (NSString *)supplyLeader_Base {
    
    return @"reg.supply-leader";
}

//检验这个手机号是否被注册过
- (NSString *)regCheckPhone_Base {
    return @"reg.check-phone";
}

#pragma mark - 忘记密码 修改密码 -
//忘记密码
- (NSString *)forgetPassword_Base {
    return @"user.forgot-pwd";
}
//修改密码
- (NSString *)motifyPassword_Base {
    return @"user.pwd";
}

#pragma mark - 消息 -
//消息列表
- (NSString *)news_Base {
    return @"user.news";
}
//消息详情
- (NSString *)newsDetail_Base {
    return @"user.new-detail";
}


#pragma mark - 图片上传 和 删除-
- (NSString *)uploadImage_Base {
    return @"check.img";
}
- (NSString *)deleteImage_Base {
    return @"check.del";
}

#pragma mark - 其他 -
//全国地区
- (NSString *)area_Base {
    return @"user.area";
}
//发送短信验证码
- (NSString *)user_msg_Base {
    return @"user.msg";
}

//验证短信验证码是否正确
- (NSString *)user_check_Base {
    return @"user.check";
}

@end
