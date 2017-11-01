//
//  SupplyListModel.m
//  GongHuo
//
//  Created by TongLi on 2017/9/18.
//  Copyright © 2017年 TongLi. All rights reserved.
//

#import "SupplyListModel.h"

@implementation SupplyListModel
- (void)setValue:(id)value forUndefinedKey:(NSString *)key {
    if ([key isEqualToString:@"A_IMAGE_1"]) {
        if ([value isKindOfClass:[NSString class]]) {
            [self.imageArr replaceObjectAtIndex:0 withObject:value];
        }
    }
    
    if ([key isEqualToString:@"A_IMAGE_2"]) {
        if ([value isKindOfClass:[NSString class]]) {
            [self.imageArr replaceObjectAtIndex:1 withObject:value];
        }
    }
    
    if ([key isEqualToString:@"A_IMAGE_3"]) {
        if ([value isKindOfClass:[NSString class]]) {
            [self.imageArr replaceObjectAtIndex:2 withObject:value];
        }
    }
    
    if ([key isEqualToString:@"A_IMAGE_4"]) {
        if ([value isKindOfClass:[NSString class]]) {
            [self.imageArr replaceObjectAtIndex:3 withObject:value];
        }
    }
    
    if ([key isEqualToString:@"A_IMAGE_5"]) {
        if ([value isKindOfClass:[NSString class]]) {
            [self.imageArr replaceObjectAtIndex:4 withObject:value];
        }
    }
    
    if ([key isEqualToString:@"A_IMAGE_6"]) {
        if ([value isKindOfClass:[NSString class]]) {
            [self.imageArr replaceObjectAtIndex:5 withObject:value];
        }
    }

}


- (NSMutableArray *)imageArr {
    if (_imageArr == nil) {
        self.imageArr = [NSMutableArray arrayWithObjects:@"",@"",@"",@"",@"",@"", nil];
    }
    return _imageArr;
}

@end
