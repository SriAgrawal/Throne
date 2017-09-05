//
//  ISEditListingCell.h
//  Instasneaks
//
//  Created by Shridhar Agarwal on 01/09/16.
//  Copyright © 2016 Mobiloitte. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Header.h"

@interface ISEditListingCell : UITableViewHeaderFooterView

@property (strong, nonatomic) IBOutlet UILabel *placeHolderLbl;
@property (strong, nonatomic) IBOutlet UITextField *editTxtField;
@property (strong, nonatomic) IBOutlet UIButton *drownImageBtn;
@property (strong, nonatomic) IBOutlet NSLayoutConstraint *editTextConstraints;
@property (strong, nonatomic) IBOutlet UIView *containerView;

@end
