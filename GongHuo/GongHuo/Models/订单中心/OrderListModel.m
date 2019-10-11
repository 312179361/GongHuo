//
//  OrderListModel.m
//  GongHuo
//
//  Created by TongLi on 2017/9/21.
//  Copyright © 2017年 TongLi. All rights reserved.
//

#import "OrderListModel.h"

@implementation OrderListModel
- (void)setValue:(id)value forUndefinedKey:(NSString *)key {
    if ([key isEqualToString:@"id"]) {
        self.orderId = value;
    }
}

@end
