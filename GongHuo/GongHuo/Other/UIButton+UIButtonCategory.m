//
//  UIButton+UIButtonCategory.m
//  GongHuo
//
//  Created by TongLi on 2017/10/25.
//  Copyright © 2017年 TongLi. All rights reserved.
//

#import "UIButton+UIButtonCategory.h"
#import "UIButton+WebCache.h"
@implementation UIButton (UIButtonCategory)

- (void)setWebImageURLWithImageUrlStr:(NSString *)imageUrlStr withErrorImage:(UIImage *)errorImage {
    
    if (![imageUrlStr containsString:@"http"]) {
        imageUrlStr = [NSString stringWithFormat:@"https://ima.nongyao001.com:7002/%@",imageUrlStr];
        NSLog(@"---%@",imageUrlStr);
        
    }
    NSURL *imageUrl = [NSURL URLWithString:imageUrlStr];
    
    self.contentMode = UIViewContentModeScaleToFill;
    
    [self sd_setImageWithURL:imageUrl forState:UIControlStateNormal completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, NSURL *imageURL) {
        if (error != nil) {
            
            if (errorImage!= nil) {
                [self setImage:errorImage forState:UIControlStateNormal];
            }
        }
    }];
    
}
@end
