//
//  ISCollectionsCell.m
//  Instasneaks
//
//  Created by Suresh patel on 18/07/16.
//  Copyright © 2016 Mobiloitte. All rights reserved.
//

#import "ISCollectionsCell.h"

@implementation ISCollectionsCell

- (void)awakeFromNib {
    [super awakeFromNib];
    
    self.topSeperatorView.layer.shadowRadius  = 1.5f;
    self.topSeperatorView.layer.shadowColor   = [UIColor lightGrayColor].CGColor;
    self.topSeperatorView.layer.shadowOffset  = CGSizeMake(0.0f, 0.0f);
    self.topSeperatorView.layer.shadowOpacity = 0.9f;
    self.topSeperatorView.layer.masksToBounds = NO;
    
    UIEdgeInsets shadowInsets     = UIEdgeInsetsMake(0, 0, -1.5f, 0);
    UIBezierPath *shadowPath      = [UIBezierPath bezierPathWithRect:UIEdgeInsetsInsetRect(self.topSeperatorView.bounds, shadowInsets)];
    self.topSeperatorView.layer.shadowPath    = shadowPath.CGPath;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
