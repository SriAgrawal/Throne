//
//  ISUsedCollectionCell.m
//  Instasneaks
//
//  Created by Suresh patel on 19/07/16.
//  Copyright © 2016 Mobiloitte. All rights reserved.
//

#import "ISUsedCollectionCell.h"

@implementation ISUsedCollectionCell

- (void)awakeFromNib {
    [super awakeFromNib];
    
    [self.layer setCornerRadius:3.0];
    [self.layer setMasksToBounds:YES];

    // Initialization code
}

@end
