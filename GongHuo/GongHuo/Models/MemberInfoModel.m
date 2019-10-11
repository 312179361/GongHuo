//
//  MemberInfoModel.m
//  GongHuo
//
//  Created by TongLi on 2017/9/14.
//  Copyright © 2017年 TongLi. All rights reserved.
//

#import "MemberInfoModel.h"

@implementation MemberInfoModel
- (void)setValue:(id)value forUndefinedKey:(NSString *)key {
    
}

#pragma mark - NSCoding Methods -
//通过编码对象aCoder对Person类中的各个属性对应的实例对象或变量做编码操作。将类的成员变量通过一个键值编码
- (void)encodeWithCoder:(NSCoder *)aCoder{
    
    [aCoder encodeObject:self.u_mobile forKey:@"u_mobile"];
    [aCoder encodeObject:self.password forKey:@"password"];
    
}

//解码操作。将键值读出
- (id)initWithCoder:(NSCoder *)aDecoder{
    
    if (self = [super init]) {
        self.u_mobile = [aDecoder decodeObjectForKey:@"u_mobile"];
        self.password = [aDecoder decodeObjectForKey:@"password"];
        
    }
    return self;
}


@end
