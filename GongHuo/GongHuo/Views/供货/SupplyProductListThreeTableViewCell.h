//
//  SupplyProductListThreeTableViewCell.h
//  GongHuo
//
//  Created by TongLi on 2017/9/19.
//  Copyright © 2017年 TongLi. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "IndexButton.h"
#import "Manager.h"
@interface SupplyProductListThreeTableViewCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UIImageView *productImageView;
@property (weak, nonatomic) IBOutlet UILabel *productNameLabel;
@property (weak, nonatomic) IBOutlet UILabel *productInventoryLabel;
@property (weak, nonatomic) IBOutlet UILabel *productStandardLabel;
@property (weak, nonatomic) IBOutlet UILabel *productPriceLabel;

@property (weak, nonatomic) IBOutlet IndexButton *bottomOneButton;
@property (weak, nonatomic) IBOutlet IndexButton *bottomTwoButton;

- (void)updateSupplyThreeCellWithModel:(SupplyListModel *)supplyModel withCellIndex:(NSIndexPath *)tempIndex ;

@end
