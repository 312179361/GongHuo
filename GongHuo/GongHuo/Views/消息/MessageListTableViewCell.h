//
//  MessageListTableViewCell.h
//  GongHuo
//
//  Created by TongLi on 2017/10/18.
//  Copyright © 2017年 TongLi. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "NewsModel.h"

@interface MessageListTableViewCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UIImageView *messageImageView;
@property (weak, nonatomic) IBOutlet UILabel *messageLabel;
@property (weak, nonatomic) IBOutlet UILabel *messageTimeLabel;

- (void)updateMessageListWithModel:(NewsModel *)newsModel;

@end
