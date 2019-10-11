//
//  DosageModel.m
//  GongHuo
//
//  Created by TongLi on 2017/9/13.
//  Copyright © 2017年 TongLi. All rights reserved.
//

#import "DosageModel.h"

@implementation DosageModel
- (void)setValue:(id)value forUndefinedKey:(NSString *)key {
    if ([key isEqualToString:@"key"]) {
        self.dosageID = value;
    }
    if ([key isEqualToString:@"val"]) {
        self.dosageValue = value;
    }
}

@end
