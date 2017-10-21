//
//  RegisterHeaderView.m
//  GongHuo
//
//  Created by TongLi on 2017/10/15.
//  Copyright © 2017年 TongLi. All rights reserved.
//

#import "RegisterHeaderView.h"

@implementation RegisterHeaderView

- (void)updateWithStep:(NSInteger)step {
    
    switch (step) {
        case 1:
            {
                self.imgOne.image = [UIImage imageNamed:@"icon_1_select"];
                self.imgTwo.image = [UIImage imageNamed:@"icon_2_normal"];
                self.imgThree.image = [UIImage imageNamed:@"icon_3_normal"];
                
                for (UILabel *pointLab1 in self.pointViewOne.subviews) {
                    pointLab1.textColor = kMainColor;
                }
                for (UILabel *pointLab2 in self.pointViewTwo.subviews) {
                    pointLab2.textColor = k666666Color;
                }
                
                self.txtOneLabel.textColor = kMainColor;
                self.txtTwoLabel.textColor = k666666Color;
                self.txtThreeLabel.textColor = k666666Color;
            }
            break;
        case 2:
            {
                self.imgOne.image = [UIImage imageNamed:@"icon_1_done"];
                self.imgTwo.image = [UIImage imageNamed:@"icon_2_select"];
                self.imgThree.image = [UIImage imageNamed:@"icon_3_normal"];
                
                for (UILabel *pointLab1 in self.pointViewOne.subviews) {
                    pointLab1.textColor = kColor(28, 176, 32, 1);
                }
                for (UILabel *pointLab2 in self.pointViewTwo.subviews) {
                    pointLab2.textColor = kMainColor;
                }
                
                self.txtOneLabel.textColor = k333333Color;
                self.txtTwoLabel.textColor = kMainColor;
                self.txtThreeLabel.textColor = k666666Color;
            }
            break;
        case 3:
            {
                self.imgOne.image = [UIImage imageNamed:@"icon_1_done"];
                self.imgTwo.image = [UIImage imageNamed:@"icon_2_done"];
                self.imgThree.image = [UIImage imageNamed:@"icon_3_select"];
                
                for (UILabel *pointLab1 in self.pointViewOne.subviews) {
                    pointLab1.textColor = kColor(28, 176, 32, 1);
                }
                for (UILabel *pointLab2 in self.pointViewTwo.subviews) {
                    pointLab2.textColor = kColor(28, 176, 32, 1);
                }
                
                self.txtOneLabel.textColor = k333333Color;
                self.txtTwoLabel.textColor = k333333Color;
                self.txtThreeLabel.textColor = kMainColor;
            }
            break;
        default:
            break;
    }
    
}


/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
