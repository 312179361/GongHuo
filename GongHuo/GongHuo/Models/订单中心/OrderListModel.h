//
//  OrderListModel.h
//  GongHuo
//
//  Created by TongLi on 2017/9/21.
//  Copyright © 2017年 TongLi. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface OrderListModel : NSObject
@property(nonatomic,strong)NSString *orderId;
@property(nonatomic,strong)NSString *oid;

@property(nonatomic,strong)NSString *mobile;
@property(nonatomic,strong)NSString *img;
@property(nonatomic,strong)NSString *address;
@property(nonatomic,strong)NSString *standard;
@property(nonatomic,strong)NSString *fname;
@property(nonatomic,strong)NSString *pname;
@property(nonatomic,strong)NSString *name;
@property(nonatomic,strong)NSString *num;
@property(nonatomic,strong)NSString *price;

@property(nonatomic,assign)NSInteger time;//当前时间
@property(nonatomic,assign)NSInteger stm;//开始时间
@property(nonatomic,assign)NSInteger etm;//结束时间

@property(nonatomic,strong)NSString *ftm;
//status

//倒计时时长  etm - time 即结束时间-当前时间
@property(nonatomic,assign)NSInteger orderTimeCount;//倒计时时长

@property(nonatomic,assign)BOOL isCountDown;//是否需要倒计时
@property(nonatomic,strong)NSIndexPath *tempIndex;//模型在cell上的index

- (void)setValue:(id)value forUndefinedKey:(NSString *)key ;

@end
