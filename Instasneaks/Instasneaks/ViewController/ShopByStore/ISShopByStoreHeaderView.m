//
//  ISShopByStoreHeaderView.m
//  Instasneaks
//
//  Created by Suresh patel on 12/10/16.
//  Copyright © 2016 Mobiloitte. All rights reserved.
//

#import "ISShopByStoreHeaderView.h"
#import "MXParallaxHeader.h"

@interface ISShopByStoreHeaderView () <MXParallaxHeader>

@end
@implementation ISShopByStoreHeaderView
+ (instancetype)instantiateFromNib
{
    NSArray *views = [[NSBundle mainBundle] loadNibNamed:NSStringFromClass(self.class) owner:nil options:nil];
    return [views firstObject];
}
#pragma mark <MXParallaxHeader>
- (void)parallaxHeaderDidScroll:(MXParallaxHeader *)parallaxHeader {
    // You can track the header progress here
}

@end
