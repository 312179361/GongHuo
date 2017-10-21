//
//  LineButton.h
//  GongHuo
//
//  Created by TongLi on 2017/7/4.
//  Copyright © 2017年 TongLi. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface LineButton : UIButton


@property (nonatomic,strong)IBInspectable UIColor *lineColor;

- (void)setColor:(UIColor*)color;


@end
