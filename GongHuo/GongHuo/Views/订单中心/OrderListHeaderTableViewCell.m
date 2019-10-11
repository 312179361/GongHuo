//
//  OrderListHeaderTableViewCell.m
//  GongHuo
//
//  Created by TongLi on 2017/9/22.
//  Copyright © 2017年 TongLi. All rights reserved.
//

#import "OrderListHeaderTableViewCell.h"

@implementation OrderListHeaderTableViewCell
- (void)updateOrderListHeaderCellWithModel:(OrderListModel *)tempModel withType:(NSString *)type {
    
    if ([type isEqualToString:@"1"]) {
        self.headerTypeLabel.text = @"订单信息";
    }else {
        self.headerTypeLabel.text = @"收货人信息";
    }

    self.addressLabel.text =  tempModel.address;
    self.nameLabel.text = tempModel.name;
    self.mobileLabel.text = tempModel.mobile;
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
