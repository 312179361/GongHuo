//
//  SupplyProductListTableViewCell.m
//  GongHuo
//
//  Created by TongLi on 2017/7/4.
//  Copyright © 2017年 TongLi. All rights reserved.
//

#import "SupplyProductListTableViewCell.h"
#import "UIImageView+ImageViewCategory.h"
@implementation SupplyProductListTableViewCell
- (void)updateSupplyListCellWithModel:(SupplyListModel *)supplyModel withCellIndex:(NSIndexPath *)tempIndex {
    NSLog(@"%ld--%ld",tempIndex.section ,tempIndex.row);
    if (supplyModel.imageArr.count > 0) {
        [self.productImageView setWebImageURLWithImageUrlStr:supplyModel.imageArr[0] withErrorImage:nil withIsCenter:YES];
    }
    self.productNameLabel.text = supplyModel.A_NAME;
    self.productInventoryLabel.text = [NSString stringWithFormat:@"%@件",supplyModel.D_INVENTORY ];
    self.productStandardLabel.text = supplyModel.A_STANDARD;
    self.productPriceLabel.text = [NSString stringWithFormat:@"%@元",supplyModel.A_PRICE_COST];
    
    self.bottomOneBtn.btnIndex = tempIndex;
    self.bottomTwoBtn.btnIndex = tempIndex;
    self.bottomThreeBtn.btnIndex = tempIndex;

    
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
