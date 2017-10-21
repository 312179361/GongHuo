//
//  AlertCustomizeViewController.h
//  GongHuo
//
//  Created by TongLi on 2017/9/19.
//  Copyright © 2017年 TongLi. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "PlaceholdTextView.h"
//枚举是那个自定义的alertView
typedef NS_ENUM(NSInteger , AlertTypeInt) {
    alertOne,//下架
    alertTwo//修改库存 修改价格
};

//点击返回的block
typedef void(^EnterBlock)(id enterBLock);

@interface AlertCustomizeViewController : UIViewController
//type编号，是哪一个alertView
@property(nonatomic,assign)AlertTypeInt alertTypeInt;
//确定block
@property(nonatomic,copy)EnterBlock enterBlock;

//第一个alertView  下架
@property (weak, nonatomic) IBOutlet UIView *alertOneView;
@property (weak, nonatomic) IBOutlet UIButton *noDelegateBtn;//不代理btn
@property (weak, nonatomic) IBOutlet UIButton *stockBtn;//缺货btn
@property (weak, nonatomic) IBOutlet UIButton *otherBtn;//其他btn
@property (weak, nonatomic) IBOutlet PlaceholdTextView *reasonTextView;//下架原因



//第二个alertView 修改库存 修改价格
@property (weak, nonatomic) IBOutlet UIView *alertTwoView;
@property (weak, nonatomic) IBOutlet UILabel *alertTwoTitleLabel;
@property(nonatomic,strong)NSString *alertTwoTitleStr;

@property (nonatomic,strong)NSString *oldNumberStr;//老库存 老价格
@property (weak, nonatomic) IBOutlet UITextField *numberTextField;//数量价格textField




@end
