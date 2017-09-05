//
//  ISShopByStoreHeaderView.h
//  Instasneaks
//
//  Created by Suresh patel on 12/10/16.
//  Copyright © 2016 Mobiloitte. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ISShopByStoreHeaderView : UIView

@property (weak, nonatomic) IBOutlet UILabel    * lable_title;
@property (weak, nonatomic) IBOutlet UIButton    * button_left;
@property (weak, nonatomic) IBOutlet UIButton    * button_right;

+ (instancetype)instantiateFromNib;

@end
