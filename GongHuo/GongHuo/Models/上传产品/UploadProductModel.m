//
//  UploadProductModel.m
//  GongHuo
//
//  Created by TongLi on 2017/9/13.
//  Copyright © 2017年 TongLi. All rights reserved.
//

#import "UploadProductModel.h"

@implementation UploadProductModel

- (NSMutableArray *)productImageArr {
    if (_productImageArr == nil) {
        self.productImageArr = [NSMutableArray arrayWithObjects:@"",@"",@"",@"",@"",@"", nil];
    }
    return _productImageArr;
}

@end
