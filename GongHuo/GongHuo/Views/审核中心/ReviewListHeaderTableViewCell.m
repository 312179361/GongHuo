//
//  ReviewListHeaderTableViewCell.m
//  GongHuo
//
//  Created by TongLi on 2017/7/4.
//  Copyright © 2017年 TongLi. All rights reserved.
//

#import "ReviewListHeaderTableViewCell.h"

@implementation ReviewListHeaderTableViewCell
- (void)updateHeaderCellWithListModel:(CheckListModel *)listModel {
    if ([listModel.A_STATUS_CHECK isEqualToString:@"0"]) {
        //待审核
        self.reviewStatusImageView.image = [UIImage imageNamed:@"icon_audit_s"];
        self.reviewStatusLabel.text = @"审核中......";
    }
    if ([listModel.A_STATUS_CHECK isEqualToString:@"1"]) {
        //通过
        self.reviewStatusImageView.image = [UIImage imageNamed:@"icon_pass_s"];
        self.reviewStatusLabel.text = @"审核通过";
    }
    if ([listModel.A_STATUS_CHECK isEqualToString:@"2"]) {
        //未通过
        self.reviewStatusImageView.image = [UIImage imageNamed:@"icon_fail_s"];
        self.reviewStatusLabel.text = @"审核未通过";
    }
    
    
    
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
