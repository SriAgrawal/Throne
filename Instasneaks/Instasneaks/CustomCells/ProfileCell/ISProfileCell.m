//
//  ISProfileCell.m
//  Instasneaks
//
//  Created by Suresh patel on 20/07/16.
//  Copyright © 2016 Mobiloitte. All rights reserved.
//

#import "ISProfileCell.h"

@implementation ISProfileCell

- (void)awakeFromNib {
    [super awakeFromNib];
    UINib *cellNib = [UINib nibWithNibName:@"ISShopCollectionsCell" bundle:nil];
    [self.collectionView_collectionsItem registerNib:cellNib forCellWithReuseIdentifier:@"shopCollectionsCell"];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
