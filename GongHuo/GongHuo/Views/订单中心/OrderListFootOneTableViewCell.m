//
//  OrderListFootOneTableViewCell.m
//  GongHuo
//
//  Created by TongLi on 2017/9/22.
//  Copyright © 2017年 TongLi. All rights reserved.
//

#import "OrderListFootOneTableViewCell.h"

@implementation OrderListFootOneTableViewCell
- (void)updateOrderCellWithModel:(OrderListModel *)tempModel withType:(NSString *)type withCellIndex:(NSIndexPath *)tempIndex {
    
    /*type代表是待接单，还是待发货，
     如果是待接单，
     acceptOrderViewHeightLayout = 38;
     如果待发货
     acceptOrderViewHeightLayout = 0;
     */
//    tempModel.tempIndex = tempIndex;
    
    if ([type isEqualToString:@"0"]) {
        //待接单
        self.footOneViewHeightLayout.constant = 38;
        self.acceptOrderTimeLabel.hidden = NO;
        self.productCountLabel.text = tempModel.num;//商品个数
        self.sendOrderTimeLabel.hidden = YES;
        [self.bottomButton setTitle:@"接单" forState:UIControlStateNormal];
        
        if (tempModel.isCountDown == YES) {
            //需要倒计时
            self.footTwoViewHeightLayout.constant = 48;
            self.acceptOrderTimeLabel.text = [NSString stringWithFormat:@"接单倒计时：%ld",tempModel.orderTimeCount];//接单倒计时

        }else{
            self.footTwoViewHeightLayout.constant = 0;
            self.acceptOrderTimeLabel.text = @"订单未处理";//接单倒计时

        }
    }
    
    
    if ([type isEqualToString:@"1"]) {
        //待发货
        self.footOneViewHeightLayout.constant = 0;
        self.footTwoViewHeightLayout.constant = 48;
        self.sendOrderTimeLabel.hidden = NO;
        self.sendOrderTimeLabel.text = [NSString stringWithFormat:@"发货倒计时：%ld",tempModel.orderTimeCount];// 发货倒计时
        self.sendOrderTimeLabel.textColor = kMainColor;
        [self.bottomButton setTitle:@"发货" forState:UIControlStateNormal];

    }
    
    
    if ([type isEqualToString:@"3"]) {
        //待接单
        self.footOneViewHeightLayout.constant = 38;
        self.footTwoViewHeightLayout.constant = 48;
        self.acceptOrderTimeLabel.hidden = YES;
        self.productCountLabel.text = tempModel.num;//商品个数
        self.sendOrderTimeLabel.hidden = NO;
        self.sendOrderTimeLabel.text = [NSString stringWithFormat:@"发货时间：%@",tempModel.ftm];
        self.sendOrderTimeLabel.textColor = k666666Color;
        [self.bottomButton setTitle:@"查看发货单" forState:UIControlStateNormal];

    }

    
    
    
    self.bottomButton.btnIndex = tempIndex;//底部按钮

    
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
