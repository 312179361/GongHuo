//
//  RootCollectionViewCell.m
//  GongHuo
//
//  Created by TongLi on 2017/7/1.
//  Copyright © 2017年 TongLi. All rights reserved.
//

#import "RootCollectionViewCell.h"

@implementation RootCollectionViewCell
- (void)updateRootCellWithInfo:(NSDictionary *)infoDic {
    self.cellImageView.image = [UIImage imageNamed:[infoDic objectForKey:@"img"]];
    self.cellTitleLabel.text = [infoDic objectForKey:@"title"];
}

@end
