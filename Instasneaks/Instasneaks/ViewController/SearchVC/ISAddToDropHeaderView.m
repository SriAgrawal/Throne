//
//  ISAddToDropHeaderView.m
//  Instasneaks
//
//  Created by Suresh patel on 12/09/16.
//  Copyright © 2016 Mobiloitte. All rights reserved.
//

#import "ISAddToDropHeaderView.h"
#import "MXParallaxHeader.h"

@interface ISAddToDropHeaderView () <MXParallaxHeader>

@end

@implementation ISAddToDropHeaderView

+ (instancetype)instantiateFromNib {
    NSArray *views = [[NSBundle mainBundle] loadNibNamed:NSStringFromClass(self.class) owner:nil options:nil];
    return [views firstObject];
}

#pragma mark <MXParallaxHeader>

- (void)parallaxHeaderDidScroll:(MXParallaxHeader *)parallaxHeader {
    // You can track the header progress here
}

@end
