//
//  RegisterAddRetailViewController.h
//  GongHuo
//
//  Created by TongLi on 2017/10/14.
//  Copyright © 2017年 TongLi. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef void(^TempAreaInfo)(NSInteger shengInt, NSInteger shiInt, NSInteger quInt);

@interface RegisterAddRetailViewController : UIViewController
@property (nonatomic,strong)NSString *tempMobile;//推广人手机

@property (nonatomic,copy)TempAreaInfo tempAreaInfo;

@end
