//
//  ISShipingAddressCell.h
//  Instasneaks
//
//  Created by Shridhar Agarwal on 19/07/16.
//  Copyright © 2016 Mobiloitte. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "header.h"

@interface ISShipingAddressCell : UITableViewCell
@property (strong, nonatomic) IBOutlet PATextField *addressTextField;
@property (strong, nonatomic) IBOutlet PATextField *phoneTextField;
@property (strong, nonatomic) IBOutlet UIImageView *downArrowImageView;

@end
