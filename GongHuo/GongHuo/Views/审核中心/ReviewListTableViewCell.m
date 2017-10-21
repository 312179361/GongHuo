//
//  ReviewListTableViewCell.m
//  GongHuo
//
//  Created by TongLi on 2017/7/4.
//  Copyright © 2017年 TongLi. All rights reserved.
//

#import "ReviewListTableViewCell.h"
#import "UIImageView+ImageViewCategory.h"
@implementation ReviewListTableViewCell
- (void)updateReviewCellWithListModel:(CheckListModel *)listModel {
    if (listModel.A_imageArr.count > 0) {
        [self.productImageView setWebImageURLWithImageUrlStr:listModel.A_imageArr[0] withErrorImage:nil withIsCenter:YES];
    }
    self.productNameLabel.text = listModel.A_NAME;
    self.productInventory.text = [NSString stringWithFormat:@"%@件", listModel.A_INVENTORY ];
    self.productStandard.text = listModel.A_STANDARD;//规格
    //单位
    NSString *danWeiStr = [listModel.A_STANDARD substringFromIndex:[listModel.A_STANDARD rangeOfString:@"/"].location+1];
    NSLog(@"%@",danWeiStr);
    self.productPrice.text = [NSString stringWithFormat:@"%@元/%@", listModel.A_PRICE_COST,danWeiStr];//价格
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
