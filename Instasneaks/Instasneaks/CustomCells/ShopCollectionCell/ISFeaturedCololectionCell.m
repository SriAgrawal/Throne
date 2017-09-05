//
//  ISFeaturedCololectionCell.m
//  Instasneaks
//
//  Created by Ankurgupta148 on 07/10/16.
//  Copyright © 2016 Mobiloitte. All rights reserved.
//

#import "ISFeaturedCololectionCell.h"

@implementation ISFeaturedCololectionCell

- (void)awakeFromNib {
    [super awakeFromNib];
    
    [self.layer setCornerRadius:4];
    [self.layer setMasksToBounds:YES];
    // Initialization code
}

@end
