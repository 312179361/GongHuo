//
//  MessageListTableViewCell.m
//  GongHuo
//
//  Created by TongLi on 2017/10/18.
//  Copyright © 2017年 TongLi. All rights reserved.
//

#import "MessageListTableViewCell.h"
#import "UIImageView+ImageViewCategory.h"
@implementation MessageListTableViewCell
- (void)updateMessageListWithModel:(NewsModel *)newsModel {
    [self.messageImageView setWebImageURLWithImageUrlStr:newsModel.i_icon_path withErrorImage:nil withIsCenter:YES];

    self.messageLabel.text = newsModel.i_title;
    self.messageTimeLabel.text = newsModel.i_time_create;
    
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
