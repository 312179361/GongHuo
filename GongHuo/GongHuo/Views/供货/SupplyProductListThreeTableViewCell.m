//
//  SupplyProductListThreeTableViewCell.m
//  GongHuo
//
//  Created by TongLi on 2017/9/19.
//  Copyright © 2017年 TongLi. All rights reserved.
//

#import "SupplyProductListThreeTableViewCell.h"
#import "UIImageView+ImageViewCategory.h"
@implementation SupplyProductListThreeTableViewCell
- (void)updateSupplyThreeCellWithModel:(SupplyListModel *)supplyModel withCellIndex:(NSIndexPath *)tempIndex {
    
    if (supplyModel.imageArr.count > 0) {
        [self.productImageView setWebImageURLWithImageUrlStr:supplyModel.imageArr[0] withErrorImage:nil withIsCenter:YES];
    }
    
    self.productNameLabel.text = supplyModel.A_NAME;
    self.productInventoryLabel.text = [NSString stringWithFormat:@"%@件",supplyModel.D_INVENTORY];
    self.productStandardLabel.text = supplyModel.A_STANDARD;
    self.productPriceLabel.text = [NSString stringWithFormat:@"%@元",supplyModel.A_PRICE_COST];
    
    
    self.bottomOneButton.btnIndex = tempIndex;
    self.bottomTwoButton.btnIndex = tempIndex;
    
    
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
