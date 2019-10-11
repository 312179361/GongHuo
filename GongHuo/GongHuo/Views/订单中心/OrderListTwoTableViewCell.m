//
//  OrderListTwoTableViewCell.m
//  GongHuo
//
//  Created by TongLi on 2017/9/22.
//  Copyright © 2017年 TongLi. All rights reserved.
//

#import "OrderListTwoTableViewCell.h"

@implementation OrderListTwoTableViewCell
- (void)updateOrderTwoCellWithModel:(OrderListModel *)tempModel {
    self.orderProductNameLabel.text = tempModel.pname;
    self.orderProductStandardLabel.text = tempModel.standard;
    self.orderProductNumberLabel.text = tempModel.num;
    self.orderProductFactory.text = tempModel.fname;

}

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
