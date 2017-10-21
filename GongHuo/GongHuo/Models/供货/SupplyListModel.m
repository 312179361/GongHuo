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
    if ([key isEqualToString:@"A_IMAGE_1"] || [key isEqualToString:@"A_IMAGE_2"] || [key isEqualToString:@"A_IMAGE_3"] || [key isEqualToString:@"A_IMAGE_4"] || [key isEqualToString:@"A_IMAGE_5"] ) {
        if ([value isKindOfClass: [NSString class]]) {
            [self.imageArr addObject:value];
            
        }
    }

}

- (NSMutableArray *)imageArr {
    if (_imageArr == nil) {
        self.imageArr = [NSMutableArray array];
    }
    return _imageArr;
}

@end
