//
//  ISStoreDetailHeaderView.m
//  Instasneaks
//
//  Created by Suresh patel on 18/10/16.
//  Copyright © 2016 Mobiloitte. All rights reserved.
//

#import "ISStoreDetailHeaderView.h"

@interface ISStoreDetailHeaderView () <MXParallaxHeader>

@end

@implementation ISShopByStoreHeaderView

+ (instancetype)ISStoreDetailHeaderView {
    NSArray *views = [[NSBundle mainBundle] loadNibNamed:NSStringFromClass(self.class) owner:nil options:nil];
    return [views firstObject];
}

#pragma mark <MXParallaxHeader>

- (void)parallaxHeaderDidScroll:(MXParallaxHeader *)parallaxHeader {
    // You can track the header progress here
}

@end
