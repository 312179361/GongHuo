//
//  InterfaceManager.h
//  GongHuo
//
//  Created by TongLi on 2017/9/13.
//  Copyright © 2017年 TongLi. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface InterfaceManager : NSObject
@property(nonatomic,strong)NSString *appKey;

+ (InterfaceManager *)shareInstance;
- (NSString *)mainUrl;

#pragma mark - 审核中心 -
//审核中心列表
- (NSString *)check_List_Base;
//产品详情
- (NSString *)check_Info_Base;

//产品分类
- (NSString *)check_Class_Base;

//添加产品
- (NSString *)check_Create_Base;
//编辑产品
- (NSString *)check_Edit_Base;

//判断产品能否上传
- (NSString *)check_Accord_Base;



#pragma mark - 供货中心 -
//供货列表
- (NSString *)supply_list_Base;

//产品编辑--包含 下架、改价、改库存
- (NSString *)supply_creat_Base;

//产品上架
- (NSString *)supply_shelves_Base;

//产品删除
- (NSString *)supply_del_Base;

//产品剂型
- (NSString *)supply_dosage_Base;

#pragma mark - 订单 -
//订单列表
- (NSString *)order_list_Base;

//订单接单
- (NSString *)order_orders_Base;

//订单发货
- (NSString *)order_deliver_Base;

//查看发货单
- (NSString *)order_invoice_Base;


#pragma mark - 人员管理 -
//人员管理列表
- (NSString *)user_list_Base;
//人员添加
- (NSString *)user_add_Base ;
//人员编辑
- (NSString *)user_create_Base ;



#pragma mark - 登录  -
- (NSString *)login_Base;
#pragma mark - 注册 -
//验证推广人手机号
- (NSString *)promoter_Base;
//门市列表
- (NSString *)retail_Base;
//市场列表
- (NSString *)mark_Base;

//添加门市
- (NSString *)suppliershop_Base;

//注册 添加负责人
- (NSString *)supplyLeader_Base;

//检验这个手机号是否被注册过
- (NSString *)regCheckPhone_Base;

#pragma mark - 忘记密码 修改密码 -
//忘记密码
- (NSString *)forgetPassword_Base;
//修改密码
- (NSString *)motifyPassword_Base;

#pragma mark - 消息 -
//消息列表
- (NSString *)news_Base;

//消息详情
- (NSString *)newsDetail_Base;

#pragma mark - 图片上传 -
- (NSString *)uploadImage_Base;

#pragma mark - 其他 -
//全国地区
- (NSString *)area_Base;
//发送短信验证码
- (NSString *)user_msg_Base;
//验证短信验证码是否正确
- (NSString *)user_check_Base;



@end
