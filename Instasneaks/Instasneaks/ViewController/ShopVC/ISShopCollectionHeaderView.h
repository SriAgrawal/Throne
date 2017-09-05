//
//  ISShopCollectionHeaderView.h
//  Instasneaks
//
//  Created by Ankurgupta148 on 07/10/16.
//  Copyright © 2016 Mobiloitte. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ISShopCollectionHeaderView : UIView
@property (weak, nonatomic) IBOutlet UIButton   * burtton_back;
@property (weak, nonatomic) IBOutlet UIButton   * burtton_done;
@property (weak, nonatomic) IBOutlet UIButton   * burtton_short;
@property (weak, nonatomic) IBOutlet UIButton   * burtton_size;
@property (weak, nonatomic) IBOutlet UIButton   * burtton_condition;
@property (weak, nonatomic) IBOutlet UIButton   * burtton_brand;
@property (weak, nonatomic) IBOutlet UIButton   * burtton_color;


@property (strong, nonatomic) IBOutlet UIImageView *conditionArrowImage;
@property (strong, nonatomic) IBOutlet UIImageView *colorArrowImage;
@property (strong, nonatomic) IBOutlet UIImageView *brandArrowImage;
@property (strong, nonatomic) IBOutlet UIImageView *sizeArrowImage;

@property (strong, nonatomic) IBOutlet UILabel *sizeLbl;
@property (strong, nonatomic) IBOutlet UILabel *brandLbl;
@property (strong, nonatomic) IBOutlet UILabel *colorLbl;
@property (strong, nonatomic) IBOutlet UILabel *conditionLbl;

+ (instancetype)instantiateFromNib;

@end
