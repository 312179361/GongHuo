//
//  OrderListOneTableViewCell.h
//  GongHuo
//
//  Created by TongLi on 2017/9/21.
//  Copyright © 2017年 TongLi. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "OrderListModel.h"
@interface OrderListOneTableViewCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UIImageView *orderProductImageView;//产品图片
@property (weak, nonatomic) IBOutlet UILabel *orderProductNameLabel;//产品名
@property (weak, nonatomic) IBOutlet UILabel *orderProductStandardLabel;//产品规格
@property (weak, nonatomic) IBOutlet UILabel *orderProductNumberLabel;//产品数量
@property (weak, nonatomic) IBOutlet UILabel *orderProductFactory;//

- (void)updateOrderOneCellWithModel:(OrderListModel *)tempModel;
@end
