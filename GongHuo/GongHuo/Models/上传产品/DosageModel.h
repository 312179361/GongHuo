//
//  DosageModel.h
//  GongHuo
//
//  Created by TongLi on 2017/9/13.
//  Copyright © 2017年 TongLi. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface DosageModel : NSObject
@property(nonatomic,strong)NSString *dosageID;
@property(nonatomic,strong)NSString *dosageValue;
- (void)setValue:(id)value forUndefinedKey:(NSString *)key;
@end
