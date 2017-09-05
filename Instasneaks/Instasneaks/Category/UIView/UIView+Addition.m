//
//  UIView+Addition.m
//  UrgencyApp
//
//  Created by Raj Kumar Sharma on 16/05/16.
//  Copyright © 2016 Mobiloitte. All rights reserved.
//

#import "UIView+Addition.h"

@implementation UIView (Addition)

@dynamic corner;
@dynamic borderColor;

- (void)setCorner:(CGFloat)corner {
    [self.layer setCornerRadius:corner];
}

- (void)setBorderColor:(UIColor *)borderColor {
    [self.layer setBorderColor:borderColor.CGColor];
    [self.layer setBorderWidth:1.0f];
}

@end
