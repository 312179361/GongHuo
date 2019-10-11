//
//  AddPeopleViewController.h
//  GongHuo
//
//  Created by TongLi on 2017/7/5.
//  Copyright © 2017年 TongLi. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "UserListModel.h"
//typedef void(^RefreshListBlock)();
@interface AddPeopleViewController : UIViewController
@property(nonatomic,strong)UserListModel *tempUserModel;

//刷新Block
//@property(nonatomic,copy)RefreshListBlock refreshListBlock;

@end
