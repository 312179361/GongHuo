//
//  PeopleManagerTableViewCell.m
//  GongHuo
//
//  Created by TongLi on 2017/7/4.
//  Copyright © 2017年 TongLi. All rights reserved.
//

#import "PeopleManagerTableViewCell.h"

@implementation PeopleManagerTableViewCell
- (void)updatePeopleManagerCellWithModel:(UserListModel *)tempModel {
    
    self.nameAndPhoneLabel.text = [NSString stringWithFormat:@"%@ %@",tempModel.l_name,tempModel.l_mobile];
    
    if (tempModel.l_area != nil && ![tempModel.l_area isEqualToString:@""]) {
        self.addressLabel.text = tempModel.l_area;
    }
    
    //1老板/经理 2业务经理 3仓管 4发货负责人5财务
    switch ([tempModel.l_is_admin integerValue]) {
        case 1:
            self.peopleImageView.image = [UIImage imageNamed:@"icon_pic_zjl"];
            self.markImageView.image = [UIImage imageNamed:@"icon_zjl"];
            break;
        case 2:
            self.peopleImageView.image = [UIImage imageNamed:@"icon_pic_ywjl"];
            self.markImageView.image = [UIImage imageNamed:@"icon_ywjl"];
            break;
        case 3:
            self.peopleImageView.image = [UIImage imageNamed:@"icon_pic_ckgl"];
            self.markImageView.image = [UIImage imageNamed:@"icon_ckgl"];
            break;
        case 4:
            self.peopleImageView.image = [UIImage imageNamed:@"icon_pic_fhy"];
            self.markImageView.image = [UIImage imageNamed:@"icon_fhy"];
            break;
        case 5:
            self.peopleImageView.image = [UIImage imageNamed:@"icon_pic_cw"];
            self.markImageView.image = [UIImage imageNamed:@"icon_cw"];
            break;
        default:
            break;
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
