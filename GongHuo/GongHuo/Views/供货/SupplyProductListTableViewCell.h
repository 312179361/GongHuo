//
//  SupplyProductListTableViewCell.h
//  GongHuo
//
//  Created by TongLi on 2017/7/4.
//  Copyright © 2017年 TongLi. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Manager.h"
#import "IndexButton.h"
@interface SupplyProductListTableViewCell : UITableViewCell

@property (weak, nonatomic) IBOutlet UIImageView *productImageView;
@property (weak, nonatomic) IBOutlet UILabel *productNameLabel;
@property (weak, nonatomic) IBOutlet UILabel *productInventoryLabel;
@property (weak, nonatomic) IBOutlet UILabel *productStandardLabel;
@property (weak, nonatomic) IBOutlet UILabel *productPriceLabel;
@property (weak, nonatomic) IBOutlet IndexButton *bottomOneBtn;
@property (weak, nonatomic) IBOutlet IndexButton *bottomTwoBtn;
@property (weak, nonatomic) IBOutlet IndexButton *bottomThreeBtn;


- (void)updateSupplyListCellWithModel:(SupplyListModel *)supplyModel withCellIndex:(NSIndexPath *)tempIndex;


@end
