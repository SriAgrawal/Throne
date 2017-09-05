//
//  ISDetailHeaderView.h
//  Instasneaks
//
//  Created by Suresh patel on 19/10/16.
//  Copyright © 2016 Mobiloitte. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "HCSStarRatingView.h"
@class HCSStarRatingView;

@interface ISDetailHeaderView : UIView

@property (weak, nonatomic) IBOutlet UIImageView        * imageView_banner;
@property (weak, nonatomic) IBOutlet UIImageView        * imageView_profile;
@property (weak, nonatomic) IBOutlet UITextField        * textField_storeTag;
@property (weak, nonatomic) IBOutlet UILabel            * label_userName;
@property (weak, nonatomic) IBOutlet UILabel            * label_itemsCount;
@property (weak, nonatomic) IBOutlet UILabel            * lable_title;
@property (weak, nonatomic) IBOutlet UIButton           * button_left;
@property (weak, nonatomic) IBOutlet UIButton *button_right;
@property (weak, nonatomic) IBOutlet UIButton *shareBtn;
@property (strong, nonatomic) IBOutlet HCSStarRatingView * ratingView;

+ (instancetype)instantiateFromNib;

@end
