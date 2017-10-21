//
//  OrderListOneTableViewCell.m
//  GongHuo
//
//  Created by TongLi on 2017/9/21.
//  Copyright © 2017年 TongLi. All rights reserved.
//

#import "OrderListOneTableViewCell.h"
#import "UIImageView+ImageViewCategory.h"
@implementation OrderListOneTableViewCell
- (void)updateOrderOneCellWithModel:(OrderListModel *)tempModel {
    [self.orderProductImageView setWebImageURLWithImageUrlStr:tempModel.img withErrorImage:nil withIsCenter:YES];
    self.orderProductNameLabel.text = tempModel.pname;
    self.orderProductStandardLabel.text = tempModel.standard;
    self.orderProductNumberLabel.text = [NSString stringWithFormat:@"数量：%@", tempModel.num ];
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
