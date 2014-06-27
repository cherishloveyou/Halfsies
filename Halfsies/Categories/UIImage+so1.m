//
//  UIImage+so1.m
//  PhotoTest1
//
//  Created by Mitchell Porter on 2/20/14.
//  Copyright (c) 2014 Mitchell Porter. All rights reserved.
//

#import "UIImage+so1.h"

@implementation UIImage (so1)

- (UIImage *)crop:(CGRect)rect {
    if (self.scale > 1.0f) {
        rect = CGRectMake(rect.origin.x * self.scale,
                          rect.origin.y * self.scale,
                          rect.size.width * self.scale,
                          rect.size.height * self.scale);
    }
    
    CGImageRef imageRef = CGImageCreateWithImageInRect(self.CGImage, rect);
    UIImage *result = [UIImage imageWithCGImage:imageRef scale:self.scale orientation:self.imageOrientation];
    CGImageRelease(imageRef);
    return result;
}
@end
