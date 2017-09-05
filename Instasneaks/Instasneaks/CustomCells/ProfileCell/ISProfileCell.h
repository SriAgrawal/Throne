//
//  ISProfileCell.h
//  Instasneaks
//
//  Created by Suresh patel on 20/07/16.
//  Copyright © 2016 Mobiloitte. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ISProfileCell : UITableViewCell

@property (weak, nonatomic) IBOutlet UILabel            * label_title;
@property (weak, nonatomic) IBOutlet UIButton           * button_arrow;
@property (weak, nonatomic) IBOutlet UICollectionView   * collectionView_collectionsItem;

@end
