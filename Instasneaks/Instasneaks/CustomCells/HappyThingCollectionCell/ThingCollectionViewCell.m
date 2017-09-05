//
//  ThingCollectionViewCell.m
//  Instasneaks
//
//  Created by Ankurgupta148 on 06/10/16.
//  Copyright © 2016 Mobiloitte. All rights reserved.
//

#import "ThingCollectionViewCell.h"

@implementation ThingCollectionViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    
    [self.bgView.layer setShadowColor:[UIColor colorWithRed:215.0/255.0 green:215.0/255.0 blue:215.0/255.0 alpha:1.0].CGColor];
    [self.bgView.layer setShadowOpacity:1.0];
    [self.bgView.layer setShadowRadius:1.0];
    [self.bgView.layer setShadowOffset:CGSizeMake(2.0f, 2.0f)];
    [self.bgView.layer setMasksToBounds:NO];
}

@end
