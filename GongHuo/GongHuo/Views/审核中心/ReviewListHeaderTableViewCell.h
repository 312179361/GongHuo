//
//  ReviewListHeaderTableViewCell.h
//  GongHuo
//
//  Created by TongLi on 2017/7/4.
//  Copyright © 2017年 TongLi. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Manager.h"
@interface ReviewListHeaderTableViewCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UIImageView *reviewStatusImageView;
@property (weak, nonatomic) IBOutlet UILabel *reviewStatusLabel;
- (void)updateHeaderCellWithListModel:(CheckListModel *)listModel;
@end
