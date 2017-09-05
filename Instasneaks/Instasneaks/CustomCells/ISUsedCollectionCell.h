//
//  ISUsedCollectionCell.h
//  Instasneaks
//
//  Created by Suresh patel on 19/07/16.
//  Copyright © 2016 Mobiloitte. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ISUsedCollectionCell : UICollectionViewCell

@property (strong, nonatomic) IBOutlet UIImageView      * imageView_collectionItem;
@property (strong, nonatomic) IBOutlet UIButton         * button_price;
@property (strong, nonatomic) IBOutlet UILabel          * label_itemTitel;
@property (strong, nonatomic) IBOutlet UILabel          * label_itemSize;
@property (strong, nonatomic) IBOutlet UILabel          * label_itemConditions;

@end
