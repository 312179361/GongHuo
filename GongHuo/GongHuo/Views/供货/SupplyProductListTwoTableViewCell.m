//
//  SupplyProductListTwoTableViewCell.m
//  GongHuo
//
//  Created by TongLi on 2017/9/18.
//  Copyright © 2017年 TongLi. All rights reserved.
//

#import "SupplyProductListTwoTableViewCell.h"
#import "UIImageView+ImageViewCategory.h"
@implementation SupplyProductListTwoTableViewCell

- (void)updateSupplyListTwoCellWithModel:(SupplyListModel *)supplyModel {
    
    if (supplyModel.imageArr.count > 0) {
        [self.productImageView setWebImageURLWithImageUrlStr:supplyModel.imageArr[0] withErrorImage:nil withIsCenter:YES];
    }
    self.productNameLabel.text = supplyModel.A_NAME;
    self.productStandardLabel.text = supplyModel.A_STANDARD;
    
    //添加删除线
//    [self deleteLineWithLabel:self.productOldInventoryLabel];
//    [self deleteLineWithLabel:self.productOldPriceLabel];
    
    if ([supplyModel.A_EDIT_TYPE isEqualToString:@"2"]) {
        //修改价格
        self.productNewInventoryLabel.hidden = NO;
        self.productOldInventoryLabel.hidden = YES;
        self.productNewPriceLabel.hidden = NO;
        self.productOldPriceLabel.hidden = NO;
        
        self.productNewInventoryLabel.text = [NSString stringWithFormat:@"%@件", supplyModel.A_O_INVENTORY];
        self.productNewPriceLabel.text = [NSString stringWithFormat:@"%@元", supplyModel.A_PRICE];
        self.productOldPriceLabel.text = [NSString stringWithFormat:@"原价：%@元", supplyModel.A_O_PRICE];
        
    }else if ([supplyModel.A_EDIT_TYPE isEqualToString:@"3"]) {
        //修改库存
        self.productNewInventoryLabel.hidden = NO;
        self.productOldInventoryLabel.hidden = NO;
        self.productNewPriceLabel.hidden = NO;
        self.productOldPriceLabel.hidden = YES;
        
        self.productNewInventoryLabel.text = [NSString stringWithFormat:@"%@件", supplyModel.A_INVENTORY];
        self.productOldInventoryLabel.text = [NSString stringWithFormat:@"%@件", supplyModel.A_O_INVENTORY];
        self.productNewPriceLabel.text = [NSString stringWithFormat:@"%@元", supplyModel.A_O_PRICE];

        
    }else {
        self.productNewInventoryLabel.hidden = NO;
        self.productOldInventoryLabel.hidden = YES;
        self.productNewPriceLabel.hidden = NO;
        self.productOldPriceLabel.hidden = YES;
        
    }
    
    
    
    //0 修改中
    if ([supplyModel.A_STATUS_CHECK isEqualToString:@"0"]) {
        //头部颜色
        self.headerView.backgroundColor = [UIColor whiteColor];
        self.headerTitleLabel.textColor = kMainColor;
        self.headerTitleLabel.text = @"正在处理中...";
        self.headerImageView.image = [UIImage imageNamed:@"icon_wait"];
        self.headerLine.hidden = NO;

        //修改中，没有底部View
        self.productProposalLabel.text = @"";
    }
    
    //1 修改成功
    if ([supplyModel.A_STATUS_CHECK isEqualToString:@"1"]) {
        //头部
        self.headerView.backgroundColor = kColor(250, 44, 78, 1);
        self.headerTitleLabel.textColor = [UIColor whiteColor];
        self.headerTitleLabel.text = @"修改成功";
        self.headerImageView.image = [UIImage imageNamed:@"icon_success"];
        self.headerLine.hidden = YES;
        
        //修改成功，没有底部View
        self.productProposalLabel.text = @"";
        
    }

    
    //2 修改失败
    if ([supplyModel.A_STATUS_CHECK isEqualToString:@"2"]) {
        self.headerView.backgroundColor = kColor(140, 140, 140, 1);
        self.headerTitleLabel.textColor = [UIColor whiteColor];
        self.headerTitleLabel.text = @"修改失败";
        self.headerImageView.image = [UIImage imageNamed:@"icon_fail"];
        self.headerLine.hidden = YES;

        
        //修改失败.有底部的View
        self.productProposalLabel.text = [NSString stringWithFormat:@"原因：%@",supplyModel.A_PROPOSAL];
    }

}

//删除线
- (void)deleteLineWithLabel:(UILabel *)label{
    
    NSMutableAttributedString *attritu = [[NSMutableAttributedString alloc]initWithString:label.text];
    [attritu addAttributes:@{
                             NSStrikethroughStyleAttributeName:@(NSUnderlineStyleSingle),
                             NSForegroundColorAttributeName:k666666Color,
                             NSBaselineOffsetAttributeName:@(0)
                             }
                     range:NSMakeRange(0, label.text.length)];
    label.attributedText = attritu;
   
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
