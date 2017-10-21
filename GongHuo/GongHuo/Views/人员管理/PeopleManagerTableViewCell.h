//
//  PeopleManagerTableViewCell.h
//  GongHuo
//
//  Created by TongLi on 2017/7/4.
//  Copyright © 2017年 TongLi. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Manager.h"
@interface PeopleManagerTableViewCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UIImageView *peopleImageView;
@property (weak, nonatomic) IBOutlet UILabel *nameAndPhoneLabel;
@property (weak, nonatomic) IBOutlet UILabel *addressLabel;
//头衔image
@property (weak, nonatomic) IBOutlet UIImageView *markImageView;

- (void)updatePeopleManagerCellWithModel:(UserListModel *)tempModel;

@end
