//
//  OrderListHeaderTableViewCell.h
//  GongHuo
//
//  Created by TongLi on 2017/9/22.
//  Copyright © 2017年 TongLi. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Manager.h"
@interface OrderListHeaderTableViewCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UILabel *headerTypeLabel;
@property (weak, nonatomic) IBOutlet UILabel *addressLabel;
@property (weak, nonatomic) IBOutlet UILabel *nameLabel;
@property (weak, nonatomic) IBOutlet UILabel *mobileLabel;

- (void)updateOrderListHeaderCellWithModel:(OrderListModel *)tempModel withType:(NSString *)type ;


@end
