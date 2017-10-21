//
//  UIImageView+ImageViewCategory.m
//  ShangCheng
//
//  Created by TongLi on 2017/2/20.
//  Copyright © 2017年 TongLi. All rights reserved.
//

#import "UIImageView+ImageViewCategory.h"
#import "UIImageView+WebCache.h"
@implementation UIImageView (ImageViewCategory)
- (void)setWebImageURLWithImageUrlStr:(NSString *)imageUrlStr withErrorImage:(UIImage *)errorImage withIsCenter:(BOOL)isCenter {
    NSLog(@"-----%@",[NSString stringWithFormat:@"http://ima.ertj.cn:8002/%@",imageUrlStr]);
    NSURL *imageUrl = [NSURL URLWithString:[NSString stringWithFormat:@"http://ima.ertj.cn:8002/%@",imageUrlStr]];
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
