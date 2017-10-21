//
//  MemberInfoModel.h
//  GongHuo
//
//  Created by TongLi on 2017/9/14.
//  Copyright © 2017年 TongLi. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface MemberInfoModel : NSObject<NSCoding>
@property(nonatomic,strong)NSString *l_is_admin;
@property(nonatomic,strong)NSString *l_s_id;
@property(nonatomic,strong)NSString *l_card_num;
@property(nonatomic,strong)NSString *l_bank_name;
@property(nonatomic,strong)NSString *l_bank_account;
@property(nonatomic,strong)NSString *u_type;
@property(nonatomic,strong)NSString *userid;
@property(nonatomic,strong)NSString *capitalcode;
@property(nonatomic,strong)NSString *capitalname;
@property(nonatomic,strong)NSString *citycode;
@property(nonatomic,strong)NSString *cityname;
@property(nonatomic,strong)NSString *countycode;
@property(nonatomic,strong)NSString *countyname;
@property(nonatomic,strong)NSString *l_area_id;
@property(nonatomic,strong)NSString *addr;
@property(nonatomic,strong)NSString *f_name;

@property(nonatomic,strong)NSString *u_truename;
@property(nonatomic,strong)NSString *u_mobile;

//@property(nonatomic,strong)NSString *l_tel;
//@property(nonatomic,strong)NSString *l_area;

@property(nonatomic,strong)NSString *password;
@property(nonatomic,strong)NSString *token;

- (void)setValue:(id)value forUndefinedKey:(NSString *)key;


@end
