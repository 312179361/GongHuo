//
//  UIImageView+ImageViewCategory.m
//  ShangCheng
//
//  Created by TongLi on 2017/2/20.
//  Copyright © 2017年 TongLi. All rights reserved.
//

#import "UIImageView+ImageViewCategory.h"
#import "UIImageView+WebCache.h"
#import "InterfaceManager.h"
@implementation UIImageView (ImageViewCategory)
- (void)setWebImageURLWithImageUrlStr:(NSString *)imageUrlStr withErrorImage:(UIImage *)errorImage withIsCenter:(BOOL)isCenter {

    InterfaceManager *interM = [InterfaceManager shareInstance];
    if (![imageUrlStr containsString:@"http"]) {
        imageUrlStr = [NSString stringWithFormat:@"%@%@",[interM mainImageUrl],imageUrlStr];

        
    }
    NSLog(@"---%@",imageUrlStr);
    
    NSURL *imageUrl = [NSURL URLWithString:imageUrlStr];
    
    self.contentMode = UIViewContentModeScaleToFill;
    [self sd_setImageWithURL:imageUrl completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, NSURL *imageURL) {
        if (error != nil) {
            if (isCenter == YES) {
                self.contentMode = UIViewContentModeCenter;
            }
            NSLog(@"++%@",imageUrl);
            if (errorImage!= nil) {
                self.image = errorImage;
            }
        }
    }];
}

@end
