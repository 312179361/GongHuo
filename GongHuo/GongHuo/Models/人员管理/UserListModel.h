//
//  UserListModel.h
//  GongHuo
//
//  Created by TongLi on 2017/9/26.
//  Copyright © 2017年 TongLi. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface UserListModel : NSObject


@property(nonatomic,strong)NSString *l_id;
@property(nonatomic,strong)NSString *l_s_id;
@property(nonatomic,strong)NSString *l_u_id;
@property(nonatomic,strong)NSString *edit;//0-不可编辑1可编辑

@property(nonatomic,strong)NSString *l_is_admin;//1老板/经理 2业务经理 3仓管 4发货负责人5财务
@property(nonatomic,strong)NSString *l_is_value;

@property(nonatomic,strong)NSString *l_name;
@property(nonatomic,strong)NSString *capitalcode;
@property(nonatomic,strong)NSString *capitalname;
@property(nonatomic,strong)NSString *citycode;
@property(nonatomic,strong)NSString *cityname;
@property(nonatomic,strong)NSString *countycode;
@property(nonatomic,strong)NSString *countyname;
@property(nonatomic,strong)NSString *l_area;

@property(nonatomic,strong)NSString *l_mobile;

@property(nonatomic,strong)NSString *l_tel;
@property(nonatomic,strong)NSString *u_email;
@property(nonatomic,strong)NSString *l_bank_name;
@property(nonatomic,strong)NSString *l_card_num;
@property(nonatomic,strong)NSString *l_note;
@property(nonatomic,strong)NSString *u_qq;
@property(nonatomic,strong)NSString *u_type;
@property(nonatomic,strong)NSString *l_status;
@property(nonatomic,strong)NSString *l_bank_account;

@property(nonatomic,strong)NSString *x_num;
@property(nonatomic,strong)NSString *l_time_create;
@property(nonatomic,strong)NSString *l_time_update;
@property(nonatomic,strong)NSString *rn;

- (void)setValue:(id)value forUndefinedKey:(NSString *)key;

@end
