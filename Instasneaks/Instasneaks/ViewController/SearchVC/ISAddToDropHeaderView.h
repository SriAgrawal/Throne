//
//  ISAddToDropHeaderView.h
//  Instasneaks
//
//  Created by Suresh patel on 12/09/16.
//  Copyright © 2016 Mobiloitte. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ISAddToDropHeaderView : UIView

@property (strong, nonatomic) IBOutlet UISearchBar *searchBar;
@property (weak, nonatomic) IBOutlet UIButton   * burtton_back;
@property (weak, nonatomic) IBOutlet UIButton   * burtton_done;
@property (weak, nonatomic) IBOutlet UIButton   * burtton_short;
@property (weak, nonatomic) IBOutlet UIButton   * burtton_size;
@property (weak, nonatomic) IBOutlet UIButton   * burtton_condition;
@property (weak, nonatomic) IBOutlet UIButton   * burtton_brand;
@property (weak, nonatomic) IBOutlet UIButton   * burtton_color;
@property (strong, nonatomic) IBOutlet UIButton *buttonGender;


@property (strong, nonatomic) IBOutlet UIImageView *conditionArrowImage;
@property (strong, nonatomic) IBOutlet UIImageView *colorArrowImage;
@property (strong, nonatomic) IBOutlet UIImageView *brandArrowImage;
@property (strong, nonatomic) IBOutlet UIImageView *sizeArrowImage;
@property (strong, nonatomic) IBOutlet UIImageView *genderArrowImage;

@property (strong, nonatomic) IBOutlet UILabel *sizeLbl;
@property (strong, nonatomic) IBOutlet UILabel *brandLbl;
@property (strong, nonatomic) IBOutlet UILabel *colorLbl;
@property (strong, nonatomic) IBOutlet UILabel *conditionLbl;
@property (strong, nonatomic) IBOutlet UILabel *genderLbl;

+ (instancetype)instantiateFromNib;

@end
