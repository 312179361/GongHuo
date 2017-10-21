//
//  OrderListTwoTableViewCell.h
//  GongHuo
//
//  Created by TongLi on 2017/9/22.
//  Copyright © 2017年 TongLi. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Manager.h"
@interface OrderListTwoTableViewCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UILabel *orderProductNameLabel;//产品名
@property (weak, nonatomic) IBOutlet UILabel *orderProductStandardLabel;//产品规格
@property (weak, nonatomic) IBOutlet UILabel *orderProductNumberLabel;//产品数量
@property (weak, nonatomic) IBOutlet UILabel *orderProductFactory;//公司

- (void)updateOrderTwoCellWithModel:(OrderListModel *)tempModel;

@end
