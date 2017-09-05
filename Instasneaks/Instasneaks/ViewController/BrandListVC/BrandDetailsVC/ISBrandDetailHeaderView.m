//
//  ISBrandDetailHeaderView.m
//  Instasneaks
//
//  Created by Suresh patel on 13/09/16.
//  Copyright © 2016 Mobiloitte. All rights reserved.
//

#import "ISBrandDetailHeaderView.h"

@implementation ISBrandDetailHeaderView

+ (instancetype)instantiateFromNib {
    NSArray *views = [[NSBundle mainBundle] loadNibNamed:NSStringFromClass(self.class) owner:nil options:nil];
    return [views firstObject];
}


@end
