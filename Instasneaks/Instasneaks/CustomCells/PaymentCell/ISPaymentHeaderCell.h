//
//  ISPaymentHeaderCell.h
//  Instasneaks
//
//  Created by Shridhar Agarwal on 20/07/16.
//  Copyright © 2016 Mobiloitte. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ISPaymentHeaderCell : UITableViewHeaderFooterView
@property (strong, nonatomic) IBOutlet UILabel *selectedLbl;
@property (strong, nonatomic) IBOutlet UILabel *placeHolderLbl;
@property (strong, nonatomic) IBOutlet UIButton *addBtn;
@property (strong, nonatomic) IBOutlet NSLayoutConstraint *addBtnWidthConstraints;

@end
