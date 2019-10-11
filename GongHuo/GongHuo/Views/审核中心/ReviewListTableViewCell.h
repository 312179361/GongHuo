//
//  ReviewListTableViewCell.h
//  GongHuo
//
//  Created by TongLi on 2017/7/4.
//  Copyright © 2017年 TongLi. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CheckListModel.h"
@interface ReviewListTableViewCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UIImageView *productImageView;
@property (weak, nonatomic) IBOutlet UILabel *productNameLabel;

@property (weak, nonatomic) IBOutlet UILabel *productInventory;//库存
@property (weak, nonatomic) IBOutlet UILabel *productStandard;//规格
@property (weak, nonatomic) IBOutlet UILabel *productPrice;//价格

- (void)updateReviewCellWithListModel:(CheckListModel *)listModel ;


@end
