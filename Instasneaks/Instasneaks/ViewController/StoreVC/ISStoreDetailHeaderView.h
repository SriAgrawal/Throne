//
//  ISStoreDetailHeaderView.h
//  Instasneaks
//
//  Created by Suresh patel on 18/10/16.
//  Copyright © 2016 Mobiloitte. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Header.h"

@class DXStarRatingView;

@interface ISStoreDetailHeaderView : UIView

@property (weak, nonatomic) IBOutlet UIImageView        * imageView_banner;
@property (weak, nonatomic) IBOutlet UIImageView        * imageView_profile;
@property (weak, nonatomic) IBOutlet UIImageView        * imageView_store;
@property (weak, nonatomic) IBOutlet UITextField        * textField_storeTag;
@property (weak, nonatomic) IBOutlet UILabel            * label_userName;
@property (weak, nonatomic) IBOutlet UILabel            * label_itemsCount;
@property (strong, nonatomic) IBOutlet DXStarRatingView * ratingView;

+ (instancetype)instantiateFromNib;

@end
