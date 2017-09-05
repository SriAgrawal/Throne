//
//  ISCollectionsCell.h
//  Instasneaks
//
//  Created by Suresh patel on 18/07/16.
//  Copyright © 2016 Mobiloitte. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ISCollectionsCell : UITableViewCell

@property (weak, nonatomic) IBOutlet UIButton * button_shopCollection;
@property (weak, nonatomic) IBOutlet UILabel * label_itemName;
@property (weak, nonatomic) IBOutlet UILabel * label_userName;
@property (strong, nonatomic) IBOutlet UICollectionView *collectionCell;
@property (weak, nonatomic) IBOutlet UIButton * button_userProfile;
@property (strong, nonatomic) IBOutlet UIImageView *userProfileImage;
@property (strong, nonatomic) IBOutlet UIView *topSeperatorView;
@property (weak, nonatomic) IBOutlet UIButton * button_favorite;

@end
