//
//  ThingCollectionViewCell.h
//  Instasneaks
//
//  Created by Ankurgupta148 on 06/10/16.
//  Copyright © 2016 Mobiloitte. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ThingCollectionViewCell : UICollectionViewCell

@property (strong, nonatomic) IBOutlet UIImageView *imageView_BackgroundView;
@property (strong, nonatomic) IBOutlet UIImageView *imageView_UserProfile;
@property (strong, nonatomic) IBOutlet UILabel *label_UserName;
@property (strong, nonatomic) IBOutlet UILabel *label_NoOfProduct;
@property (strong, nonatomic) IBOutlet UIButton *favBtn;
@property (strong, nonatomic) IBOutlet UIView * bgView;
@property (strong, nonatomic) IBOutlet NSLayoutConstraint *backGroundImageHeightConstant;
@end
