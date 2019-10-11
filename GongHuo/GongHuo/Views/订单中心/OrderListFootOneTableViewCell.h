//
//  OrderListFootOneTableViewCell.h
//  GongHuo
//
//  Created by TongLi on 2017/9/22.
//  Copyright © 2017年 TongLi. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Manager.h"
#import "IndexButton.h"
@interface OrderListFootOneTableViewCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UILabel *acceptOrderTimeLabel;//接单倒计时
@property (weak, nonatomic) IBOutlet UILabel *productCountLabel;//商品个数
@property (weak, nonatomic) IBOutlet UILabel *sendOrderTimeLabel;// 发货倒计时

@property (weak, nonatomic) IBOutlet IndexButton *bottomButton;//底部按钮


@property (weak, nonatomic) IBOutlet NSLayoutConstraint *footOneViewHeightLayout;//上面的View高度 38
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *footTwoViewHeightLayout;//下面的View高度 48


//type代表是待接单，还是待发货，
- (void)updateOrderCellWithModel:(OrderListModel *)tempModel withType:(NSString *)type withCellIndex:(NSIndexPath *)tempIndex;


@end
