//
//  RootCollectionViewCell.h
//  GongHuo
//
//  Created by TongLi on 2017/7/1.
//  Copyright © 2017年 TongLi. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface RootCollectionViewCell : UICollectionViewCell
@property (weak, nonatomic) IBOutlet UIImageView *cellImageView;
@property (weak, nonatomic) IBOutlet UILabel *cellTitleLabel;

- (void)updateRootCellWithInfo:(NSDictionary *)infoDic;
@end
