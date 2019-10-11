//
//  LineButton.m
//  GongHuo
//
//  Created by TongLi on 2017/7/4.
//  Copyright © 2017年 TongLi. All rights reserved.
//

#import "LineButton.h"

@implementation LineButton

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        
    }
    return self;
}

-(void)setColor:(UIColor *)color{
    self.lineColor = [color copy];
    [self setNeedsDisplay];
}


- (void) drawRect:(CGRect)rect {
    CGRect textRect = self.titleLabel.frame;
    CGContextRef contextRef = UIGraphicsGetCurrentContext();
    
    CGFloat descender = self.titleLabel.font.descender;
    if([self.lineColor isKindOfClass:[UIColor class]]){
        CGContextSetStrokeColorWithColor(contextRef, self.lineColor.CGColor);
    }
    
    CGContextMoveToPoint(contextRef, textRect.origin.x, textRect.origin.y + textRect.size.height + descender+1 +5);
    CGContextAddLineToPoint(contextRef, textRect.origin.x + textRect.size.width, textRect.origin.y + textRect.size.height + descender+1 +5);
    
    CGContextClosePath(contextRef);
    CGContextDrawPath(contextRef, kCGPathStroke);
}


/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
