//
//  ISFeatureCell.m
//  Instasneaks
//
//  Created by Ankurgupta148 on 07/10/16.
//  Copyright © 2016 Mobiloitte. All rights reserved.
//

#import "ISFeatureCell.h"

@implementation ISFeatureCell

- (void)awakeFromNib {
    [super awakeFromNib];
    
    self.view_bg.layer.shadowRadius  = 1.0f;
    self.view_bg.layer.shadowColor   = [UIColor grayColor].CGColor;
    self.view_bg.layer.shadowOffset  = CGSizeMake(0.0f, 0.0f);
    self.view_bg.layer.shadowOpacity = 0.9f;
    self.view_bg.layer.masksToBounds = NO;
    
    UIEdgeInsets shadowInsets     = UIEdgeInsetsMake(0, 0, 1.0f, 0);
    UIBezierPath *shadowPath      = [UIBezierPath bezierPathWithRect:UIEdgeInsetsInsetRect(self.view_bg.bounds, shadowInsets)];
    self.view_bg.layer.shadowPath    = shadowPath.CGPath;
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
