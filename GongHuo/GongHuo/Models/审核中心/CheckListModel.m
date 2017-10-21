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
    
    if ([key isEqualToString:@"A_IMAGE_1"] || [key isEqualToString:@"A_IMAGE_2"] || [key isEqualToString:@"A_IMAGE_3"] || [key isEqualToString:@"A_IMAGE_4"] || [key isEqualToString:@"A_IMAGE_5"] ) {
        if ([value isKindOfClass: [NSString class]]) {
            [self.A_imageArr addObject:value];

        }
    }
    
    
}

- (NSMutableArray *)A_imageArr {
    if (_A_imageArr == nil) {
        self.A_imageArr = [NSMutableArray array];
    }
    return _A_imageArr;
}



@end
