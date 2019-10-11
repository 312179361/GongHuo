//
//  CheckListModel.m
//  GongHuo
//
//  Created by TongLi on 2017/9/15.
//  Copyright © 2017年 TongLi. All rights reserved.
//

#import "CheckListModel.h"

@implementation CheckListModel
- (void)setValue:(id)value forUndefinedKey:(NSString *)key{
    if ([key isEqualToString:@"A_IMAGE_1"]) {
        if ([value isKindOfClass:[NSString class]]) {
            [self.A_imageArr replaceObjectAtIndex:0 withObject:value];
        }
    }
    
    if ([key isEqualToString:@"A_IMAGE_2"]) {
        if ([value isKindOfClass:[NSString class]]) {
            [self.A_imageArr replaceObjectAtIndex:1 withObject:value];
        }
    }
    
    if ([key isEqualToString:@"A_IMAGE_3"]) {
        if ([value isKindOfClass:[NSString class]]) {
            [self.A_imageArr replaceObjectAtIndex:2 withObject:value];
        }
    }
    
    if ([key isEqualToString:@"A_IMAGE_4"]) {
        if ([value isKindOfClass:[NSString class]]) {
            [self.A_imageArr replaceObjectAtIndex:3 withObject:value];
        }
    }
    
    if ([key isEqualToString:@"A_IMAGE_5"]) {
        if ([value isKindOfClass:[NSString class]]) {
            [self.A_imageArr replaceObjectAtIndex:4 withObject:value];
        }
    }
    
    if ([key isEqualToString:@"A_IMAGE_6"]) {
        if ([value isKindOfClass:[NSString class]]) {
            [self.A_imageArr replaceObjectAtIndex:5 withObject:value];
        }
    }
    
    
}

- (NSMutableArray *)A_imageArr {
    if (_A_imageArr == nil) {
        self.A_imageArr = [NSMutableArray arrayWithObjects:@"",@"",@"",@"",@"",@"", nil];
    }
    return _A_imageArr;
}



@end
