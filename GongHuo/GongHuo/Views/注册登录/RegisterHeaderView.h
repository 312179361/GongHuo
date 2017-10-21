//
//  RegisterHeaderView.h
//  GongHuo
//
//  Created by TongLi on 2017/10/15.
//  Copyright © 2017年 TongLi. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface RegisterHeaderView : UIView
@property (weak, nonatomic) IBOutlet UIImageView *imgOne;
@property (weak, nonatomic) IBOutlet UIImageView *imgTwo;
@property (weak, nonatomic) IBOutlet UIImageView *imgThree;

@property (weak, nonatomic) IBOutlet UIView *pointViewOne;
@property (weak, nonatomic) IBOutlet UIView *pointViewTwo;

@property (weak, nonatomic) IBOutlet UILabel *txtOneLabel;
@property (weak, nonatomic) IBOutlet UILabel *txtTwoLabel;
@property (weak, nonatomic) IBOutlet UILabel *txtThreeLabel;

- (void)updateWithStep:(NSInteger)step ;


@end
