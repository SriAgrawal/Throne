//
//  ISShopCollectionHeaderView.m
//  Instasneaks
//
//  Created by Ankurgupta148 on 07/10/16.
//  Copyright © 2016 Mobiloitte. All rights reserved.
//

#import "ISShopCollectionHeaderView.h"
#import "MXParallaxHeader.h"
@interface ISShopCollectionHeaderView () <MXParallaxHeader>

@end

@implementation ISShopCollectionHeaderView

+ (instancetype)instantiateFromNib {
    NSArray *views = [[NSBundle mainBundle] loadNibNamed:NSStringFromClass(self.class) owner:nil options:nil];
    return [views firstObject];
}

#pragma mark <MXParallaxHeader>
- (void)parallaxHeaderDidScroll:(MXParallaxHeader *)parallaxHeader {
    // You can track the header progress here
}
@end
