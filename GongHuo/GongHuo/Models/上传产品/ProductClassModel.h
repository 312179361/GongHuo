//
//  ProductClassModel.h
//  GongHuo
//
//  Created by TongLi on 2017/9/13.
//  Copyright © 2017年 TongLi. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface ProductClassModel : NSObject
@property(nonatomic,strong)NSString *d_code;
@property(nonatomic,strong)NSString *d_value;
- (void)setValue:(id)value forUndefinedKey:(NSString *)key;
@end
