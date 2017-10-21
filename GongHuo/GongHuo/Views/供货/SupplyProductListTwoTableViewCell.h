//
//  SupplyProductListTwoTableViewCell.h
//  GongHuo
//
//  Created by TongLi on 2017/9/18.
//  Copyright © 2017年 TongLi. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SupplyListModel.h"
@interface SupplyProductListTwoTableViewCell : UITableViewCell
//头部
@property (weak, nonatomic) IBOutlet UIView *headerView;
@property (weak, nonatomic) IBOutlet UIImageView *headerImageView;
@property (weak, nonatomic) IBOutlet UILabel *headerTitleLabel;
@property (weak, nonatomic) IBOutlet UIView *headerLine;

//中间
@property (weak, nonatomic) IBOutlet UIImageView *productImageView;
@property (weak, nonatomic) IBOutlet UILabel *productNameLabel;
@property (weak, nonatomic) IBOutlet UILabel *productStandardLabel;
@property (weak, nonatomic) IBOutlet UILabel *productNewInventoryLabel;
@property (weak, nonatomic) IBOutlet UILabel *productOldInventoryLabel;
@property (weak, nonatomic) IBOutlet UILabel *productNewPriceLabel;
@property (weak, nonatomic) IBOutlet UILabel *productOldPriceLabel;

//尾部
@property (weak, nonatomic) IBOutlet UILabel *productProposalLabel;


- (void)updateSupplyListTwoCellWithModel:(SupplyListModel *)supplyModel;

@end
