//
//  ISFeatureCell.h
//  Instasneaks
//
//  Created by Ankurgupta148 on 07/10/16.
//  Copyright © 2016 Mobiloitte. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ISFeatureCell : UITableViewCell

@property (strong, nonatomic) IBOutlet UICollectionView * collectionView_ISFeature;
@property (strong, nonatomic) IBOutlet UIImageView      * imageView_profile;
@property (strong, nonatomic) IBOutlet UILabel          * label_userName;
@property (strong, nonatomic) IBOutlet UILabel          * label_detail;
@property (strong, nonatomic) IBOutlet UIButton         * button_profile;
@property (strong, nonatomic) IBOutlet UIView           * view_bg;

@end
