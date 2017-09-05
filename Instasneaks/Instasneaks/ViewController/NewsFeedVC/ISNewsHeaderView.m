//
//  ISNewsHeaderView.m
//  Instasneaks
//
//  Created by Shridhar Agarwal on 03/10/16.
//  Copyright © 2016 Mobiloitte. All rights reserved.
//

#import "ISNewsHeaderView.h"

@implementation ISNewsHeaderView

+ (instancetype)instantiateFromNib {
    NSArray *views = [[NSBundle mainBundle] loadNibNamed:NSStringFromClass(self.class) owner:nil options:nil];
    return [views firstObject];
}

@end
